





with validation_errors as (

    select
        destination_id, user_id
    from angel.workshop_live_stg_fivetran_log.stg_fivetran_log__destination_membership
    group by destination_id, user_id
    having count(*) > 1

)

select *
from validation_errors


