delete from activiti_carma.act_ru_variable;

delete from activiti_carma.act_ru_task;

delete from activiti_carma.act_ru_identitylink;

delete from activiti_carma.act_ru_event_subscr;

update activiti_carma.act_ru_execution set SUPER_EXEC_ = NULL where act_ru_execution.SUPER_EXEC_ is not NULL;
update activiti_carma.act_ru_execution set PARENT_ID_ = NULL where act_ru_execution.PARENT_ID_ is not NULL;

delete from activiti_carma.act_ru_execution;

delete from carma_protoman.protocol_enroll;