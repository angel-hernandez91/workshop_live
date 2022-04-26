





with validation_errors as (

    select
        account_id, user_id
    from angel.workshop_live_stg_fivetran_log.stg_fivetran_log__account_membership
    group by account_id, user_id
    having count(*) > 1

)

select *
from validation_errors


