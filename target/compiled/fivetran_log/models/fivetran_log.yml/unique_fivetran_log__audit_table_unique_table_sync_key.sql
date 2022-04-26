
    
    

select
    unique_table_sync_key as unique_field,
    count(*) as n_records

from angel.workshop_live_fivetran_log.fivetran_log__audit_table
where unique_table_sync_key is not null
group by unique_table_sync_key
having count(*) > 1


