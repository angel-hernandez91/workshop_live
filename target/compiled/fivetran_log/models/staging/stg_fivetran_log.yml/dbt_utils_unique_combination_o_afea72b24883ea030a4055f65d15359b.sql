





with validation_errors as (

    select
        connector_name, destination_id
    from angel.workshop_live_stg_fivetran_log.stg_fivetran_log__connector
    group by connector_name, destination_id
    having count(*) > 1

)

select *
from validation_errors


