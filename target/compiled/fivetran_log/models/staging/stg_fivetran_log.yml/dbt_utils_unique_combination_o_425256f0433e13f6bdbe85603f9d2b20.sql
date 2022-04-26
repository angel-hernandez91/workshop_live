





with validation_errors as (

    select
        measured_month, destination_id
    from angel.workshop_live_stg_fivetran_log.stg_fivetran_log__credits_used
    group by measured_month, destination_id
    having count(*) > 1

)

select *
from validation_errors


