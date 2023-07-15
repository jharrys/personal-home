-- Clinical Data
SELECT   i.create_ts, 
         i.acm_context, 
         i.acm_elmnt_key_code,
         i.acm_elmnt_kind, 
         i.CONTEXT,
         i.data_type, 
         i.data_value,
         i.data_value2, 
         i.date_time, 
         c.clinical_data_sk_id,  
         e.external_id_cncpt, 
         e.external_id_ext, 
         e.external_id_rt, 
         i.ii_extension, 
         i.ii_root, 
         i.instance_row_id,
         i.operator_ecid,
         i.original_txt, 
         i.parent_instance_row_id,
         i.root_instance_row_id, 
         i.units_code_ecid, 
         i.units_original_txt,
         c.contact_sk_id,
         cc.admin_encounter_ii_rt, 
         cc.admin_encounter_ii_ext,
         cc.clinical_encounter_ii_rt, 
         cc.clinical_encounter_ii_ext,
         i.USAGE
    FROM cdr.clinical_data c,
         cdr.external_id e,
         cdr.INSTANCE i,
         contact.contact cc
   WHERE c.clinical_data_sk_id = i.clinical_data_sk_id
     AND i.src_system_sk_id = e.src_system_sk_id
     AND c.contact_sk_id = cc.contact_sk_id
ORDER BY i.create_ts DESC, c.clinical_data_sk_id, i.CONTEXT

/
