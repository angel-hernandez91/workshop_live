begin;
    
        
        
    

    

    merge into angel.workshop_live_fivetran_log.fivetran_log__audit_table as DBT_INTERNAL_DEST
        using angel.workshop_live_fivetran_log.fivetran_log__audit_table__dbt_tmp as DBT_INTERNAL_SOURCE
        on 
            DBT_INTERNAL_SOURCE.unique_table_sync_key = DBT_INTERNAL_DEST.unique_table_sync_key
        

    
    when matched then update set
        "CONNECTOR_ID" = DBT_INTERNAL_SOURCE."CONNECTOR_ID","CONNECTOR_NAME" = DBT_INTERNAL_SOURCE."CONNECTOR_NAME","TABLE_NAME" = DBT_INTERNAL_SOURCE."TABLE_NAME","DESTINATION_ID" = DBT_INTERNAL_SOURCE."DESTINATION_ID","DESTINATION_NAME" = DBT_INTERNAL_SOURCE."DESTINATION_NAME","WRITE_TO_TABLE_START" = DBT_INTERNAL_SOURCE."WRITE_TO_TABLE_START","WRITE_TO_TABLE_END" = DBT_INTERNAL_SOURCE."WRITE_TO_TABLE_END","SYNC_START" = DBT_INTERNAL_SOURCE."SYNC_START","SYNC_END" = DBT_INTERNAL_SOURCE."SYNC_END","SUM_ROWS_REPLACED_OR_INSERTED" = DBT_INTERNAL_SOURCE."SUM_ROWS_REPLACED_OR_INSERTED","SUM_ROWS_UPDATED" = DBT_INTERNAL_SOURCE."SUM_ROWS_UPDATED","SUM_ROWS_DELETED" = DBT_INTERNAL_SOURCE."SUM_ROWS_DELETED","UNIQUE_TABLE_SYNC_KEY" = DBT_INTERNAL_SOURCE."UNIQUE_TABLE_SYNC_KEY"
    

    when not matched then insert
        ("CONNECTOR_ID", "CONNECTOR_NAME", "TABLE_NAME", "DESTINATION_ID", "DESTINATION_NAME", "WRITE_TO_TABLE_START", "WRITE_TO_TABLE_END", "SYNC_START", "SYNC_END", "SUM_ROWS_REPLACED_OR_INSERTED", "SUM_ROWS_UPDATED", "SUM_ROWS_DELETED", "UNIQUE_TABLE_SYNC_KEY")
    values
        ("CONNECTOR_ID", "CONNECTOR_NAME", "TABLE_NAME", "DESTINATION_ID", "DESTINATION_NAME", "WRITE_TO_TABLE_START", "WRITE_TO_TABLE_END", "SYNC_START", "SYNC_END", "SUM_ROWS_REPLACED_OR_INSERTED", "SUM_ROWS_UPDATED", "SUM_ROWS_DELETED", "UNIQUE_TABLE_SYNC_KEY")

;
    commit;