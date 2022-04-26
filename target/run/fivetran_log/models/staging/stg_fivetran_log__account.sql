

      create or replace transient table angel.workshop_live_stg_fivetran_log.stg_fivetran_log__account  as
      (with account as (
    
    select * from angel.fivetran_log.account

),

fields as (

    select
        id as account_id,
        country,
        cast(created_at as 
    timestamp_ntz
) as created_at,
        name as account_name,
        status
        
    from account

)

select * from fields
      );
    