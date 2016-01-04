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