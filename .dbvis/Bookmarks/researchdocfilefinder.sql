/*
Basic query to get the Organization ID given a Study ID.
*/
SELECT
    IDISCOVER.ORGANIZATION.ID AS orgid,
    IDISCOVER.STUDY_DEF.NAME  AS studyname,
    IDISCOVER.STUDY_DEF.ID    AS studyid
FROM
    IDISCOVER.ORGANIZATION
INNER JOIN
    IDISCOVER.STUDY_DEF
ON
    (
        IDISCOVER.ORGANIZATION.ID = IDISCOVER.STUDY_DEF.ORGANIZATION_ID)
WHERE
    IDISCOVER.STUDY_DEF.ID = 163;
    
/*
VALUE_CONSENT Query:
SQL statement used to acquire the files from the VALUE_CONSENT table and associating it with its
study_def_id,
study_enrollments, participant_studies.
*/
SELECT
    se.STUDY_DEF_ID         AS studyid,
    se.ID                   AS studyenrollmentid,
    se.PARTICIPANT_STUDY_ID AS pstudyid,
    vc.ID                   AS vfileid,
    vc.FILE_NAME            AS vfilename,
    vc.FILE_SIZE            AS vfilesize,
    vc.MIME_TYPE            AS vfilemimetype,
    vc.COMPLETE             AS vfilecomplete,
    vc.BYTES                AS vfilebytes
FROM
    IDISCOVER.FORM f
INNER JOIN
    IDISCOVER.FORM_ELEMENT fe
ON
    (
        f.ID = fe.FORM_ID)
INNER JOIN
    IDISCOVER.STUDY_FORM sf
ON
    (
        f.STUDY_FORM_ID = sf.ID)
INNER JOIN
    IDISCOVER.STUDY_ENROLLMENT se
ON
    (
        sf.PARTICIPANT_ID = se.PARTICIPANT_ID)
INNER JOIN
    IDISCOVER.VALUE_CONSENT vc
ON
    (
        fe.VALUE_ID = vc.ID)
WHERE
    se.STUDY_DEF_ID = 163
AND vc.BYTES IS NOT NULL
ORDER BY
    studyid ASC,
    pstudyid ASC,
    studyenrollmentid ASC ;
/*
VALUE_FILE Query:
SQL statement used to acquire the files from the VALUE_FILE table and associating it with its
study_def_id,
study_enrollments, participant_studies.
*/
SELECT
    se.STUDY_DEF_ID         AS studyid,
    se.ID                   AS studyenrollmentid,
    se.PARTICIPANT_STUDY_ID AS pstudyid,
    vf.ID                   AS vfileid,
    vf.NAME                 AS vfilename,
    vf.FILE_SIZE            AS vfilesize,
    vf.MIME_TYPE            AS vfilemimetype,
    vf.FILE_PATH            AS vfilepath,
    vf.HAS_BYTES            AS vfilehasbytes,
    vf.BYTES                AS vfilebytes
FROM
    IDISCOVER.FORM f
INNER JOIN
    IDISCOVER.FORM_ELEMENT fe
ON
    (
        f.ID = fe.FORM_ID)
INNER JOIN
    IDISCOVER.STUDY_FORM sf
ON
    (
        f.STUDY_FORM_ID = sf.ID)
INNER JOIN
    IDISCOVER.STUDY_ENROLLMENT se
ON
    (
        sf.PARTICIPANT_ID = se.PARTICIPANT_ID)
INNER JOIN
    IDISCOVER.VALUE_FILE vf
ON
    (
        fe.VALUE_ID = vf.ID)
WHERE
    se.STUDY_DEF_ID = 163
AND vf.BYTES IS NOT NULL
ORDER BY
    studyid ASC,
    pstudyid ASC,
    studyenrollmentid ASC ;
    
/*
VALUE_LIST_ITEM Query
SQL statement used to acquire the files from the VALUE_LIST_ITEM table and associating it with its
study_def_id,
study_enrollments, participant_studies.
*/
SELECT
    se.STUDY_DEF_ID         AS studyid,
    se.ID                   AS studyenrollmentid,
    se.PARTICIPANT_STUDY_ID AS pstudyid,
    vf.ID                   AS vfileid,
    vf.NAME                 AS vfilename,
    vf.FILE_SIZE            AS vfilesize,
    vf.MIME_TYPE            AS vfilemimetype,
    vf.FILE_PATH            AS vfilepath,
    vf.HAS_BYTES            AS vfilehasbytes,
    vf.BYTES                AS vfilebytes
FROM
    IDISCOVER.FORM f
INNER JOIN
    IDISCOVER.FORM_ELEMENT fe
ON
    (
        f.ID = fe.FORM_ID)
INNER JOIN
    IDISCOVER.STUDY_FORM sf
ON
    (
        f.STUDY_FORM_ID = sf.ID)
INNER JOIN
    IDISCOVER.STUDY_ENROLLMENT se
ON
    (
        sf.PARTICIPANT_ID = se.PARTICIPANT_ID)
INNER JOIN
    IDISCOVER.VALUE_LIST_ITEM vli
ON
    (
        fe.VALUE_ID = vli.VALUE_LIST_ID)
INNER JOIN
    IDISCOVER.VALUE_FILE vf
ON
    (
        vli.VALUE_ID = vf.ID)
WHERE
    se.STUDY_DEF_ID = 163
AND vf.BYTES IS NOT NULL
ORDER BY
    studyid ASC,
    pstudyid ASC,
    studyenrollmentid ASC ;