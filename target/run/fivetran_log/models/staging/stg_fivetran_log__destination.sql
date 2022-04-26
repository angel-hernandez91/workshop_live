

      create or replace transient table angel.workshop_live_stg_fivetran_log.stg_fivetran_log__destination  as
      (with destination as (

    select * from angel.fivetran_log.destination

),

fields as (

    select
        id as destination_id,
        account_id,
        cast(created_at as 
    timestamp_ntz
) as created_at,
        name as destination_name,
        region
    
    from destination
)

select * from fields
      );
    