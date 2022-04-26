





with validation_errors as (

    select
        active_volume_id, destination_id
    from angel.workshop_live_stg_fivetran_log.stg_fivetran_log__active_volume
    group by active_volume_id, destination_id
    having count(*) > 1

)

select *
from validation_errors


