--Script to clean out base GE content
connect / as sysdba

delete from cpf.PACKAGE_ASSOCIATION_INSTANCE;
delete from cpf.PACKAGE_CONCEPT;
delete from cpf.PACKAGE_DEPENDENCY;
delete from cpf.PACKAGE_KEYWORD;
delete from cpf.PACKAGE_VARIANT;
delete from cpf.VARIANT_CONTENT_DEPENDENCY;
delete from cpf.VARIANT_TERMINOLOGY_DEPENDENCY;
delete from cpf.JOB;
delete from cpf.PACKAGE;
delete from cpf.CONTENT_VARIANT;

delete from cmr.PACKAGE_DEPENDENCY;
delete from cmr.PACKAGE_KEYWORD;
delete from cmr.PACKAGE_MANIFEST;
delete from cmr.VARIANT_CONTENT_DEPENDENCY;
delete from cmr.VARIANT_CONTEXT;
delete from cmr.VARIANT_KEYWORD;
delete from cmr.VARIANT_TERMINOLOGY_DEPENDENCY;
delete from cmr.CONTENT_VARIANT;
delete from cmr.PACKAGE;

drop table cma.CMSVER_BINVAL;
drop table cma.CMSVER_FSENTRY;
drop table cma.CMSREPO_FSENTRY;
drop table cma.CMSVER_NODE;
drop table cma.CMSVER_PROP;
drop table cma.CMSVER_REFS;
drop table cma.CMSWKSP_BINVAL;
drop table cma.CMSWKSP_FSENTRY;
drop table cma.CMSWKSP_NODE;
drop table cma.CMSWKSP_PROP;
drop table cma.CMSWKSP_REFS;


exit
