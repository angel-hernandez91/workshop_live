
    
    

select
    destination_id as unique_field,
    count(*) as n_records

from angel.workshop_live_stg_fivetran_log.stg_fivetran_log__destination
where destination_id is not null
group by destination_id
having count(*) > 1


