-- depends_on: angel.fivetran_log.connector

with connector as (
    
    select * 
    from angel.workshop_live_fivetran_log.fivetran_log__connector_status
),

-- grab api calls, schema changes, and record modifications
log_events as (

    select 
        connector_id,
        cast( date_trunc('day', created_at) as date) as date_day,
        case 
            when event_subtype in ('create_table', 'alter_table', 'create_schema', 'change_schema_config') then 'schema_change' 
            else event_subtype end as event_subtype,

        sum(case when event_subtype = 'records_modified' then cast( 

  parse_json( message_data )['count'] as 
    int
 )
        else 1 end) as count_events 

    from angel.workshop_live_stg_fivetran_log.stg_fivetran_log__log

    where event_subtype in ('api_call', 
                            'records_modified', 
                            'create_table', 'alter_table', 'create_schema', 'change_schema_config') -- all schema changes
                            
        and connector_id is not null

    group by 1,2,3
),

pivot_out_events as (

    select
        connector_id,
        date_day,
        max(case when event_subtype = 'api_call' then count_events else 0 end) as count_api_calls,
        max(case when event_subtype = 'records_modified' then count_events else 0 end) as count_record_modifications,
        max(case when event_subtype = 'schema_change' then count_events else 0 end) as count_schema_changes

    from log_events
    group by 1,2
),

connector_event_counts as (

    select
        pivot_out_events.date_day,
        pivot_out_events.count_api_calls,
        pivot_out_events.count_record_modifications,
        pivot_out_events.count_schema_changes,
        connector.connector_name,
        connector.connector_id,
        connector.connector_type,
        connector.destination_name,
        connector.destination_id,
        connector.set_up_at
    from
    connector left join pivot_out_events 
        on pivot_out_events.connector_id = connector.connector_id
),

spine as (

    
    
    
    
    

    





with rawdata as (

    

    

    with p as (
        select 0 as generated_number union all select 1
    ), unioned as (

    select

    
    p0.generated_number * power(2, 0)
     + 
    
    p1.generated_number * power(2, 1)
     + 
    
    p2.generated_number * power(2, 2)
     + 
    
    p3.generated_number * power(2, 3)
     + 
    
    p4.generated_number * power(2, 4)
     + 
    
    p5.generated_number * power(2, 5)
     + 
    
    p6.generated_number * power(2, 6)
     + 
    
    p7.generated_number * power(2, 7)
     + 
    
    p8.generated_number * power(2, 8)
     + 
    
    p9.generated_number * power(2, 9)
    
    
    + 1
    as generated_number

    from

    
    p as p0
     cross join 
    
    p as p1
     cross join 
    
    p as p2
     cross join 
    
    p as p3
     cross join 
    
    p as p4
     cross join 
    
    p as p5
     cross join 
    
    p as p6
     cross join 
    
    p as p7
     cross join 
    
    p as p8
     cross join 
    
    p as p9
    
    

    )

    select *
    from unioned
    where generated_number <= 629
    order by generated_number



),

all_periods as (

    select (
        

    dateadd(
        day,
        row_number() over (order by 1) - 1,
        cast('2020-08-12' as date)
        )


    ) as date_day
    from rawdata

),

filtered as (

    select *
    from all_periods
    where date_day <= 

    dateadd(
        week,
        1,
        date_trunc('day', 
    current_timestamp::
    timestamp_ntz

)
        )



)

select * from filtered

 
),

connector_event_history as (

    select
        cast(spine.date_day as date) as date_day,
        connector_event_counts.connector_name,
        connector_event_counts.connector_id,
        connector_event_counts.connector_type,
        connector_event_counts.destination_name,
        connector_event_counts.destination_id,
        max(case 
            when cast(spine.date_day as date) = connector_event_counts.date_day then connector_event_counts.count_api_calls
            else 0
        end) as count_api_calls,
        max(case 
            when cast(spine.date_day as date) = connector_event_counts.date_day then connector_event_counts.count_record_modifications
            else 0
        end) as count_record_modifications,
        max(case 
            when cast(spine.date_day as date) = connector_event_counts.date_day then connector_event_counts.count_schema_changes
            else 0
        end) as count_schema_changes
    from
    spine join connector_event_counts
        on spine.date_day  >= cast( date_trunc('day', connector_event_counts.set_up_at) as date)

    group by 1,2,3,4,5,6
),

-- now rejoin spine to get a complete calendar
join_event_history as (
    
    select
        spine.date_day,
        connector_event_history.connector_name,
        connector_event_history.connector_id,
        connector_event_history.connector_type,
        connector_event_history.destination_name,
        connector_event_history.destination_id,
        max(connector_event_history.count_api_calls) as count_api_calls,
        max(connector_event_history.count_record_modifications) as count_record_modifications,
        max(connector_event_history.count_schema_changes) as count_schema_changes

    from
    spine left join connector_event_history
        on cast(spine.date_day as date) = connector_event_history.date_day

    group by 1,2,3,4,5,6
),

final as (

    select *
    from join_event_history

    where cast(date_day as timestamp) <= 
    current_timestamp::
    timestamp_ntz



    order by date_day desc
)

select *
from final