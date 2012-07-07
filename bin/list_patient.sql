-- Patients
SELECT   i.create_ts, 
         i.acm_context, 
         i.acm_elmnt_key_code, 
         i.acm_elmnt_kind,
         i.CONTEXT,
         i.data_type, 
         i.data_value,
         i.date_time, 
         i.instance_row_id,
         i.parent_instance_row_id, 
         i.patient_sk_id,
         i.root_instance_row_id, 
         i.USAGE
    FROM pdr.INSTANCE i, pdr.external_id e
   WHERE e.patient_sk_id = i.root_instance_row_id
ORDER BY i.create_ts DESC, e.external_id_ext, i."CONTEXT"

/

