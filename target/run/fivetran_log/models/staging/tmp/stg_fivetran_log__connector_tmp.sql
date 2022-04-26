
  create or replace  view angel.workshop_live_stg_fivetran_log.stg_fivetran_log__connector_tmp 
  
   as (
    select *
from angel.fivetran_log.connector
  );
