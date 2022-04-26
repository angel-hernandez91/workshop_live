with fivetran_user as (

    select * from angel.fivetran_log.user

),

fields as (

    select
        id as user_id,
        cast(created_at as 
    timestamp_ntz
) as created_at,
        email,
        email_disabled as has_disabled_email_notifications,
        family_name as last_name,
        given_name as first_name,
        phone,
        verified as is_verified
        
    from fivetran_user

)

select * from fields