





with validation_errors as (

    select
        connector_id, destination_id, table_name, measured_month
    from angel.workshop_live_fivetran_log.fivetran_log__mar_table_history
    group by connector_id, destination_id, table_name, measured_month
    having count(*) > 1

)

select *
from validation_errors


