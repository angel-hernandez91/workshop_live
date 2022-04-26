
    
    

select
    user_id as unique_field,
    count(*) as n_records

from angel.workshop_live_stg_fivetran_log.stg_fivetran_log__user
where user_id is not null
group by user_id
having count(*) > 1


