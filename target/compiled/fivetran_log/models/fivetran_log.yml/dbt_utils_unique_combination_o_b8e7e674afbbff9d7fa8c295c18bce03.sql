





with validation_errors as (

    select
        connector_id, destination_id
    from angel.workshop_live_fivetran_log.fivetran_log__connector_status
    group by connector_id, destination_id
    having count(*) > 1

)

select *
from validation_errors


