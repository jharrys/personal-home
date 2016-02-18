--Script to clear out patient contact data
connect / as sysdba

delete from contact.encapsulated_file;
delete from contact.instance;
delete from contact.contact_detail;
delete from contact.contact_relationship;
delete from contact.provider_type;
delete from contact.cntct_srvc_dlvry_loctn;
delete from contact.transport;
delete from contact.contact;
delete from entity.entity_role_address;
delete from entity.entity_role_relationship;
delete from entity.external_id;
delete from entity.entity_role_telecom;
delete from entity.entity_role;
delete from entity.address;
delete from entity.contact_party_detail;
delete from entity.instance;
delete from entity.person_language_communication;
delete from entity.language_communication;
delete from entity.organization_address;
delete from entity.organization_name;
delete from entity.organization_telecom;
delete from entity.organization;
delete from entity.person_address;
delete from entity.person_detail;
delete from entity.person_name;
delete from entity.person_telecom;
delete from entity.person;
delete from entity.practitioner_privilege;
delete from entity.provider_specialty;
delete from entity.speciality;
delete from entity.telecom;
exit
