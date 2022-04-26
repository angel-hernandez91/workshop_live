with account as (
    
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