
  create or replace  view angel.workshop_live.my_second_dbt_model 
  
   as (
    -- Use the `ref` function to select from other models

select *
from angel.workshop_live.my_first_dbt_model
where id = 1
  );
