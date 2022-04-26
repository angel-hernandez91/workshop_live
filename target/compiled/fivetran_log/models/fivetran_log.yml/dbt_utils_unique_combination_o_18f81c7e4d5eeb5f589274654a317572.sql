





with validation_errors as (

    select
        destination_id, measured_month
    from angel.workshop_live_fivetran_log.fivetran_log__credit_mar_destination_history
    group by destination_id, measured_month
    having count(*) > 1

)

select *
from validation_errors


