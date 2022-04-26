with  credits_used as (

    select * from angel.fivetran_log.credits_used

),

fields as (
    
    select 
        destination_id,
        measured_month,
        credits_consumed
    
    from credits_used
)

select * from fields