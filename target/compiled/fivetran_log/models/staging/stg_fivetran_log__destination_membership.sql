with destination_membership as (
    
    select * from angel.fivetran_log.destination_membership

),

fields as (

    select
        destination_id,
        user_id,
        cast(activated_at as 
    timestamp_ntz
) as activated_at,
        cast(joined_at as 
    timestamp_ntz
) as joined_at,
        role as destination_role
        
    from destination_membership
)

select * from fields