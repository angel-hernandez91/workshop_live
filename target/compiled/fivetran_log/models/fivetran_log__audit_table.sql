

with sync_log as (
    
    select 
        *,
        

  parse_json( message_data )['table'] as table_name

    from angel.workshop_live_stg_fivetran_log.stg_fivetran_log__log

    where event_subtype in ('sync_start', 'sync_end', 'write_to_table_start', 'write_to_table_end', 'records_modified')

    

    -- Capture the latest timestamp in a call statement instead of a subquery for optimizing BQ costs on incremental runs-- load the result from the above query into a new variable-- the query_result is stored as a dataframe. Therefore, we want to now store it as a singular value.-- compare the new batch of data to the latest sync already stored in this model
        and date(created_at) >= '2022-04-18'

    
),


connector as (

    select *
    from angel.workshop_live_fivetran_log.fivetran_log__connector_status

),

add_connector_info as (

    select 
        sync_log.*,
        connector.connector_name,
        connector.destination_id,
        connector.destination_name

    from sync_log join connector using(connector_id)
),

sync_timestamps as (

    select
        connector_id,
        connector_name,
        table_name,
        event_subtype,
        destination_id,
        destination_name,

        created_at as write_to_table_start,
        
        min(case when event_subtype = 'write_to_table_end' then created_at else null end) 
            over (partition by connector_id, table_name order by created_at ROWS between CURRENT ROW AND UNBOUNDED FOLLOWING) as write_to_table_end,

        max(case when event_subtype = 'sync_start' then created_at else null end) 
            over (partition by connector_id order by created_at ROWS between UNBOUNDED PRECEDING and CURRENT ROW) as sync_start,

        min(case when event_subtype = 'sync_end' then created_at else null end) 
            over (partition by connector_id order by created_at ROWS between CURRENT ROW AND UNBOUNDED FOLLOWING) as sync_end, -- coalesce with next_sync_start

        min(case when event_subtype = 'sync_start' then created_at else null end) 
            over (partition by connector_id order by created_at ROWS between CURRENT ROW AND UNBOUNDED FOLLOWING) as next_sync_start

    from add_connector_info

),

-- this will be the base for every record in the final CTE
limit_to_table_starts as (

    select *

    from sync_timestamps 
    where event_subtype = 'write_to_table_start'

),

records_modified_log as (

    select 
        connector_id,
        created_at,
        

  parse_json( message_data )['table'] as table_name,
        

  parse_json( message_data )['schema'] as schema_name,
        

  parse_json( message_data )['operationType'] as operation_type,
        cast (

  parse_json( message_data )['count'] as 
    int
) as row_count

    from sync_log 
    where event_subtype = 'records_modified'

),

sum_records_modified as (

    select
        limit_to_table_starts.connector_id,
        limit_to_table_starts.connector_name,
        limit_to_table_starts.table_name,
        limit_to_table_starts.destination_id,
        limit_to_table_starts.destination_name,
        limit_to_table_starts.write_to_table_start,
        limit_to_table_starts.write_to_table_end,
        limit_to_table_starts.sync_start,
        case when limit_to_table_starts.sync_end > limit_to_table_starts.next_sync_start then null else limit_to_table_starts.sync_end end as sync_end,

        sum(case when records_modified_log.operation_type = 'REPLACED_OR_INSERTED' then records_modified_log.row_count else 0 end) as sum_rows_replaced_or_inserted,
        sum(case when records_modified_log.operation_type = 'UPDATED' then records_modified_log.row_count else 0 end) as sum_rows_updated,
        sum(case when records_modified_log.operation_type = 'DELETED' then records_modified_log.row_count else 0 end) as sum_rows_deleted

    from limit_to_table_starts

    left join records_modified_log on 
        limit_to_table_starts.connector_id = records_modified_log.connector_id
        and limit_to_table_starts.table_name = records_modified_log.table_name
        -- confine it to one sync
        and records_modified_log.created_at > limit_to_table_starts.sync_start 
        and records_modified_log.created_at < coalesce(limit_to_table_starts.sync_end, limit_to_table_starts.next_sync_start) 

    group by 1,2,3,4,5,6,7,8,9

),

surrogate_key as (

    select 
        *,
        md5(cast(coalesce(cast(connector_id as 
    varchar
), '') || '-' || coalesce(cast(destination_id as 
    varchar
), '') || '-' || coalesce(cast(table_name as 
    varchar
), '') || '-' || coalesce(cast(write_to_table_start as 
    varchar
), '') as 
    varchar
)) as unique_table_sync_key

    from sum_records_modified
)

select *
from surrogate_key