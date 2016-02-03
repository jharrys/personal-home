/* Check to see if user already exists in scr_user table */
SELECT
    *
FROM
    HWCIR_SCREENING.SCR_USER
WHERE
    SCR_USER.USER_NAME='${username}$';
/* Adding a new user to SCR */
INSERT
INTO
    HWCIR_SCREENING.SCR_USER
    (
        id,
        email,
        first_name,
        last_name,
        pager,
        pager_end_time,
        pager_start_time,
        user_name
    )
    VALUES
    (
    (
    (
        SELECT
            MAX(id)
        FROM
            HWCIR_SCREENING.SCR_USER
    )
    +1
    )
    ,
    '${email address}$',
    '${First}$',
    '${Last}$',
    NULL,
    NULL,
    NULL,
    '${username}$'
    );
/* Receive alerts; alert_method_id (1 for email, 2 for pager), evaluation_model_id get model and
location_group_id */
INSERT
INTO
    EVAL_MDL_ALRT_RECI
    (
        ID,
        ALERT_METHOD_ID,
        ALERT_RECIPIENT_ID,
        EVALUATION_MODEL_ID,
        LOCATION_GROUP_ID
    )
    VALUES
    (
    (
    (
        SELECT
            MAX(id)
        FROM
            EVAL_MDL_ALRT_RECI
    )
    + 1
    )
    ,
    ${alert type||1||BigDecimal}$,
    (
        SELECT
            id
        FROM
            SCR_USER
        WHERE
            user_name='${username}$' ),
    ${surveyid||(null)||BigDecimal}$,
    ${locationid||(null)||BigDecimal}$
    );
/* Add user reviews of alerts; location_group_id, scr_user, survey_id (should match
location_group_id choice) */
INSERT
INTO
    SURVEY_REVIEW_USER_LOC_GROUP
    (
        ID,
        LOCATION_GROUP_ID,
        REVIEW_USER_ID,
        SCR_SURVEY_ID
    )
    VALUES
    (
    (
    (
        SELECT
            MAX(id)
        FROM
            SURVEY_REVIEW_USER_LOC_GROUP
    )
    + 1
    )
    ,
    ${locationid||(null)||BigDecimal}$,
    (
        SELECT
            id
        FROM
            SCR_USER
        WHERE
            user_name='${username}$' ),
    ${surveyid||(null)||BigDecimal}$
    );
/* delete user */
delete from HWCIR_SCREENING.EVAL_MDL_ALRT_RECI where EVAL_MDL_ALRT_RECI.ALERT_RECIPIENT_ID=${userid||(null)||BigDecimal}$;
delete from HWCIR_SCREENING.SURVEY_REVIEW_USER_LOC_GROUP where SURVEY_REVIEW_USER_LOC_GROUP.REVIEW_USER_ID=${userid||(null)||BigDecimal}$;
delete from HWCIR_SCREENING.SCR_USER where SCR_USER.ID=${userid||(null)||BigDecimal}$;
/* remove specific user from receiving any alerts */
delete from HWCIR_SCREENING.EVAL_MDL_ALRT_RECI where alert_recipient_id=(select id from scr_user where scr_user.LAST_NAME='${userlastname}$');

/* Join query to identify data_drive_event data - use to smoke test and compare with production */
SELECT
    p.mmi,
    e.encounter
FROM
    data_drive_event d
INNER JOIN
    encounter e
ON
    d.encounter_id = e.id
INNER JOIN
    patient p
ON
    d.patient_id = p.id
ORDER BY
    p.mmi;

/* Query to identify xml data from the scr_intervention_evt_adt table and extract columns to test */    
SELECT
    extractvalue(xmltype(xml_event_data), '/EDAdmitEvent/Encounter/EncounterNumber'),
    xmltype(xml_event_data).extract('/EDAdmitEvent/Encounter').getStringVal()
FROM
    SCR_INTERVENTION_EVT_ADT
WHERE
    audit_date_time > to_date('2016-01-07 09:30:00', 'yyyy-mm-dd HH:MI:SS')
ORDER BY
    audit_date_time;
    
/*
** Adding myself to all alerts
*/
INSERT INTO EVAL_MDL_ALRT_RECI (ID, ALERT_METHOD_ID, ALERT_RECIPIENT_ID, EVALUATION_MODEL_ID, LOCATION_GROUP_ID) VALUES (hibernate_sequence.nextval, 1, ${userid}$, 1, 2);
INSERT INTO EVAL_MDL_ALRT_RECI (ID, ALERT_METHOD_ID, ALERT_RECIPIENT_ID, EVALUATION_MODEL_ID, LOCATION_GROUP_ID) VALUES (hibernate_sequence.nextval, 1, ${userid}$, 1, 4);
INSERT INTO EVAL_MDL_ALRT_RECI (ID, ALERT_METHOD_ID, ALERT_RECIPIENT_ID, EVALUATION_MODEL_ID, LOCATION_GROUP_ID) VALUES (hibernate_sequence.nextval, 1, ${userid}$, 1, 6);
INSERT INTO EVAL_MDL_ALRT_RECI (ID, ALERT_METHOD_ID, ALERT_RECIPIENT_ID, EVALUATION_MODEL_ID, LOCATION_GROUP_ID) VALUES (hibernate_sequence.nextval, 1, ${userid}$, 1, 8);
INSERT INTO EVAL_MDL_ALRT_RECI (ID, ALERT_METHOD_ID, ALERT_RECIPIENT_ID, EVALUATION_MODEL_ID, LOCATION_GROUP_ID) VALUES (hibernate_sequence.nextval, 1, ${userid}$, 2, 9);
INSERT INTO EVAL_MDL_ALRT_RECI (ID, ALERT_METHOD_ID, ALERT_RECIPIENT_ID, EVALUATION_MODEL_ID, LOCATION_GROUP_ID) VALUES (hibernate_sequence.nextval, 1, ${userid}$, 2, 10);
INSERT INTO EVAL_MDL_ALRT_RECI (ID, ALERT_METHOD_ID, ALERT_RECIPIENT_ID, EVALUATION_MODEL_ID, LOCATION_GROUP_ID) VALUES (hibernate_sequence.nextval, 1, ${userid}$, 2, 11);
INSERT INTO EVAL_MDL_ALRT_RECI (ID, ALERT_METHOD_ID, ALERT_RECIPIENT_ID, EVALUATION_MODEL_ID, LOCATION_GROUP_ID) VALUES (hibernate_sequence.nextval, 1, ${userid}$, 2, 12);
INSERT INTO EVAL_MDL_ALRT_RECI (ID, ALERT_METHOD_ID, ALERT_RECIPIENT_ID, EVALUATION_MODEL_ID, LOCATION_GROUP_ID) VALUES (hibernate_sequence.nextval, 1, ${userid}$, 2, 13);
INSERT INTO EVAL_MDL_ALRT_RECI (ID, ALERT_METHOD_ID, ALERT_RECIPIENT_ID, EVALUATION_MODEL_ID, LOCATION_GROUP_ID) VALUES (hibernate_sequence.nextval, 1, ${userid}$, 2, 14);
INSERT INTO EVAL_MDL_ALRT_RECI (ID, ALERT_METHOD_ID, ALERT_RECIPIENT_ID, EVALUATION_MODEL_ID, LOCATION_GROUP_ID) VALUES (hibernate_sequence.nextval, 1, ${userid}$, 2, 25);
INSERT INTO EVAL_MDL_ALRT_RECI (ID, ALERT_METHOD_ID, ALERT_RECIPIENT_ID, EVALUATION_MODEL_ID, LOCATION_GROUP_ID) VALUES (hibernate_sequence.nextval, 1, ${userid}$, 3, 16);
INSERT INTO EVAL_MDL_ALRT_RECI (ID, ALERT_METHOD_ID, ALERT_RECIPIENT_ID, EVALUATION_MODEL_ID, LOCATION_GROUP_ID) VALUES (hibernate_sequence.nextval, 1, ${userid}$, 3, 18);
INSERT INTO EVAL_MDL_ALRT_RECI (ID, ALERT_METHOD_ID, ALERT_RECIPIENT_ID, EVALUATION_MODEL_ID, LOCATION_GROUP_ID) VALUES (hibernate_sequence.nextval, 1, ${userid}$, 3, 20);
INSERT INTO EVAL_MDL_ALRT_RECI (ID, ALERT_METHOD_ID, ALERT_RECIPIENT_ID, EVALUATION_MODEL_ID, LOCATION_GROUP_ID) VALUES (hibernate_sequence.nextval, 1, ${userid}$, 3, 22);
INSERT INTO EVAL_MDL_ALRT_RECI (ID, ALERT_METHOD_ID, ALERT_RECIPIENT_ID, EVALUATION_MODEL_ID, LOCATION_GROUP_ID) VALUES (hibernate_sequence.nextval, 1, ${userid}$, 4, 24);
INSERT INTO EVAL_MDL_ALRT_RECI (ID, ALERT_METHOD_ID, ALERT_RECIPIENT_ID, EVALUATION_MODEL_ID, LOCATION_GROUP_ID) VALUES (hibernate_sequence.nextval, 1, ${userid}$, 5, 26);
INSERT INTO EVAL_MDL_ALRT_RECI (ID, ALERT_METHOD_ID, ALERT_RECIPIENT_ID, EVALUATION_MODEL_ID, LOCATION_GROUP_ID) VALUES (hibernate_sequence.nextval, 1, ${userid}$, 5, 27);
INSERT INTO EVAL_MDL_ALRT_RECI (ID, ALERT_METHOD_ID, ALERT_RECIPIENT_ID, EVALUATION_MODEL_ID, LOCATION_GROUP_ID) VALUES (hibernate_sequence.nextval, 1, ${userid}$, 5, 28);
INSERT INTO EVAL_MDL_ALRT_RECI (ID, ALERT_METHOD_ID, ALERT_RECIPIENT_ID, EVALUATION_MODEL_ID, LOCATION_GROUP_ID) VALUES (hibernate_sequence.nextval, 1, ${userid}$, 5, 29);
INSERT INTO EVAL_MDL_ALRT_RECI (ID, ALERT_METHOD_ID, ALERT_RECIPIENT_ID, EVALUATION_MODEL_ID, LOCATION_GROUP_ID) VALUES (hibernate_sequence.nextval, 1, ${userid}$, 6, 30);
INSERT INTO EVAL_MDL_ALRT_RECI (ID, ALERT_METHOD_ID, ALERT_RECIPIENT_ID, EVALUATION_MODEL_ID, LOCATION_GROUP_ID) VALUES (hibernate_sequence.nextval, 1, ${userid}$, 6, 31);
INSERT INTO EVAL_MDL_ALRT_RECI (ID, ALERT_METHOD_ID, ALERT_RECIPIENT_ID, EVALUATION_MODEL_ID, LOCATION_GROUP_ID) VALUES (hibernate_sequence.nextval, 1, ${userid}$, 6, 32);
INSERT INTO EVAL_MDL_ALRT_RECI (ID, ALERT_METHOD_ID, ALERT_RECIPIENT_ID, EVALUATION_MODEL_ID, LOCATION_GROUP_ID) VALUES (hibernate_sequence.nextval, 1, ${userid}$, 6, 33);
INSERT INTO EVAL_MDL_ALRT_RECI (ID, ALERT_METHOD_ID, ALERT_RECIPIENT_ID, EVALUATION_MODEL_ID, LOCATION_GROUP_ID) VALUES (hibernate_sequence.nextval, 1, ${userid}$, 7, 34);
INSERT INTO EVAL_MDL_ALRT_RECI (ID, ALERT_METHOD_ID, ALERT_RECIPIENT_ID, EVALUATION_MODEL_ID, LOCATION_GROUP_ID) VALUES (hibernate_sequence.nextval, 1, ${userid}$, 7, 35);
INSERT INTO EVAL_MDL_ALRT_RECI (ID, ALERT_METHOD_ID, ALERT_RECIPIENT_ID, EVALUATION_MODEL_ID, LOCATION_GROUP_ID) VALUES (hibernate_sequence.nextval, 1, ${userid}$, 7, 36);
INSERT INTO EVAL_MDL_ALRT_RECI (ID, ALERT_METHOD_ID, ALERT_RECIPIENT_ID, EVALUATION_MODEL_ID, LOCATION_GROUP_ID) VALUES (hibernate_sequence.nextval, 1, ${userid}$, 7, 37);
/*
** Adding myself to all reviews
*/
insert into SURVEY_REVIEW_USER_LOC_GROUP(ID,LOCATION_GROUP_ID,REVIEW_USER_ID,SCR_SURVEY_ID) values (hibernate_sequence.nextval, 2,${userid}$,1);
insert into SURVEY_REVIEW_USER_LOC_GROUP(ID,LOCATION_GROUP_ID,REVIEW_USER_ID,SCR_SURVEY_ID) values (hibernate_sequence.nextval, 4,${userid}$,1);
insert into SURVEY_REVIEW_USER_LOC_GROUP(ID,LOCATION_GROUP_ID,REVIEW_USER_ID,SCR_SURVEY_ID) values (hibernate_sequence.nextval, 6,${userid}$,1);
insert into SURVEY_REVIEW_USER_LOC_GROUP(ID,LOCATION_GROUP_ID,REVIEW_USER_ID,SCR_SURVEY_ID) values (hibernate_sequence.nextval, 8,${userid}$,1);
insert into SURVEY_REVIEW_USER_LOC_GROUP(ID,LOCATION_GROUP_ID,REVIEW_USER_ID,SCR_SURVEY_ID) values (hibernate_sequence.nextval, 9,${userid}$,2);
insert into SURVEY_REVIEW_USER_LOC_GROUP(ID,LOCATION_GROUP_ID,REVIEW_USER_ID,SCR_SURVEY_ID) values (hibernate_sequence.nextval, 10,${userid}$,2);
insert into SURVEY_REVIEW_USER_LOC_GROUP(ID,LOCATION_GROUP_ID,REVIEW_USER_ID,SCR_SURVEY_ID) values (hibernate_sequence.nextval, 11,${userid}$,2);
insert into SURVEY_REVIEW_USER_LOC_GROUP(ID,LOCATION_GROUP_ID,REVIEW_USER_ID,SCR_SURVEY_ID) values (hibernate_sequence.nextval, 12,${userid}$,2);
insert into SURVEY_REVIEW_USER_LOC_GROUP(ID,LOCATION_GROUP_ID,REVIEW_USER_ID,SCR_SURVEY_ID) values (hibernate_sequence.nextval, 13,${userid}$,2);
insert into SURVEY_REVIEW_USER_LOC_GROUP(ID,LOCATION_GROUP_ID,REVIEW_USER_ID,SCR_SURVEY_ID) values (hibernate_sequence.nextval, 14,${userid}$,2);
insert into SURVEY_REVIEW_USER_LOC_GROUP(ID,LOCATION_GROUP_ID,REVIEW_USER_ID,SCR_SURVEY_ID) values (hibernate_sequence.nextval, 25,${userid}$,2);
insert into SURVEY_REVIEW_USER_LOC_GROUP(ID,LOCATION_GROUP_ID,REVIEW_USER_ID,SCR_SURVEY_ID) values (hibernate_sequence.nextval, 16,${userid}$,3);
insert into SURVEY_REVIEW_USER_LOC_GROUP(ID,LOCATION_GROUP_ID,REVIEW_USER_ID,SCR_SURVEY_ID) values (hibernate_sequence.nextval, 18,${userid}$,3);
insert into SURVEY_REVIEW_USER_LOC_GROUP(ID,LOCATION_GROUP_ID,REVIEW_USER_ID,SCR_SURVEY_ID) values (hibernate_sequence.nextval, 20,${userid}$,3);
insert into SURVEY_REVIEW_USER_LOC_GROUP(ID,LOCATION_GROUP_ID,REVIEW_USER_ID,SCR_SURVEY_ID) values (hibernate_sequence.nextval, 22,${userid}$,3);
insert into SURVEY_REVIEW_USER_LOC_GROUP(ID,LOCATION_GROUP_ID,REVIEW_USER_ID,SCR_SURVEY_ID) values (hibernate_sequence.nextval, 24,${userid}$,4);
insert into SURVEY_REVIEW_USER_LOC_GROUP(ID,LOCATION_GROUP_ID,REVIEW_USER_ID,SCR_SURVEY_ID) values (hibernate_sequence.nextval, 26,${userid}$,5);
insert into SURVEY_REVIEW_USER_LOC_GROUP(ID,LOCATION_GROUP_ID,REVIEW_USER_ID,SCR_SURVEY_ID) values (hibernate_sequence.nextval, 27,${userid}$,5);
insert into SURVEY_REVIEW_USER_LOC_GROUP(ID,LOCATION_GROUP_ID,REVIEW_USER_ID,SCR_SURVEY_ID) values (hibernate_sequence.nextval, 28,${userid}$,5);
insert into SURVEY_REVIEW_USER_LOC_GROUP(ID,LOCATION_GROUP_ID,REVIEW_USER_ID,SCR_SURVEY_ID) values (hibernate_sequence.nextval, 29,${userid}$,5);
insert into SURVEY_REVIEW_USER_LOC_GROUP(ID,LOCATION_GROUP_ID,REVIEW_USER_ID,SCR_SURVEY_ID) values (hibernate_sequence.nextval, 30,${userid}$,6);
insert into SURVEY_REVIEW_USER_LOC_GROUP(ID,LOCATION_GROUP_ID,REVIEW_USER_ID,SCR_SURVEY_ID) values (hibernate_sequence.nextval, 31,${userid}$,6);
insert into SURVEY_REVIEW_USER_LOC_GROUP(ID,LOCATION_GROUP_ID,REVIEW_USER_ID,SCR_SURVEY_ID) values (hibernate_sequence.nextval, 32,${userid}$,6);
insert into SURVEY_REVIEW_USER_LOC_GROUP(ID,LOCATION_GROUP_ID,REVIEW_USER_ID,SCR_SURVEY_ID) values (hibernate_sequence.nextval, 33,${userid}$,6);
insert into SURVEY_REVIEW_USER_LOC_GROUP(ID,LOCATION_GROUP_ID,REVIEW_USER_ID,SCR_SURVEY_ID) values (hibernate_sequence.nextval, 34,${userid}$,7);
insert into SURVEY_REVIEW_USER_LOC_GROUP(ID,LOCATION_GROUP_ID,REVIEW_USER_ID,SCR_SURVEY_ID) values (hibernate_sequence.nextval, 35,${userid}$,7);
insert into SURVEY_REVIEW_USER_LOC_GROUP(ID,LOCATION_GROUP_ID,REVIEW_USER_ID,SCR_SURVEY_ID) values (hibernate_sequence.nextval, 36,${userid}$,7);
insert into SURVEY_REVIEW_USER_LOC_GROUP(ID,LOCATION_GROUP_ID,REVIEW_USER_ID,SCR_SURVEY_ID) values (hibernate_sequence.nextval, 37,${userid}$,7);
