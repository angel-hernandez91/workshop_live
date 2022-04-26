with destination as (

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