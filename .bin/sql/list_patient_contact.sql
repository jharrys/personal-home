-- Patient Contact
SELECT 
       c.create_ts, 
       c.start_ts, 
       c.end_ts, 
       c.type_cwe_cd, 
       c.ADMIN_ENCOUNTER_II_EXT,
       c.ADMIN_ENCOUNTER_II_RT,
       c.CLINICAL_ENCOUNTER_II_EXT,
       c.CLINICAL_ENCOUNTER_II_RT,
       c.dschrg_disposition_cwe_cd, 
       pl.participating_location_sk_id, 
       pl.role_cd participating_location_role_cd,
       pl.start_ts location_start_ts, 
       pt.create_ts provider_type_create_ts,
       pt.start_ts provider_type_start_ts,
       pt.end_ts provider_type_end_ts, 
       pt.provider_role,
       c.patient_ii_ext, 
       c.act_status_cwe_cd, 
       c.contact_sk_id        
  FROM contact.contact c,
       contact.participating_location pl,
       contact.provider_type pt
 WHERE c.contact_sk_id = pl.contact_sk_id(+) AND c.contact_sk_id = pt.contact_sk_id(+)

/

