

      create or replace transient table angel.workshop_live_stg_fivetran_log.stg_fivetran_log__account_membership  as
      (with account_membership as (
    
    select * from angel.fivetran_log.account_membership

),

fields as (

    select
        account_id,
        user_id,
        cast(activated_at as 
    timestamp_ntz
) as activated_at,
        cast(joined_at as 
    timestamp_ntz
) as joined_at,
        role as account_role
        
    from account_membership
    
)

select * from fields
      );
    