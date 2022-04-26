





with validation_errors as (

    select
        connector_id, destination_id, date_day
    from angel.workshop_live_fivetran_log.fivetran_log__connector_daily_events
    group by connector_id, destination_id, date_day
    having count(*) > 1

)

select *
from validation_errors


