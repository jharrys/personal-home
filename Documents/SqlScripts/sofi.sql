-- active activity events; this is from ActivityEventDao which gets run by ActivityEventRunnable

SELECT
  ta.id                AS activity_event_entry_id,
  ta.id                AS target_activity_id,
  ae.activity_event_id AS activity_event_id,
  aee.event_dt         AS event_dt,
  NULL                 AS created_by,
  NULL                 AS created_dt,
  NULL                 AS updated_by,
  NULL                 AS updated_dt -- select id's for composite class creation
FROM target_activity ta   -- From target_activity
  JOIN activity_event ae    -- Join activity_events against target_activity on activity/category/flow/status
    ON ta.activity = ae.activity
       AND ta.flow = ae.flow
       AND ta.activity_ctgry = ae.activity_ctgry
       AND ta.status = ae.status
  JOIN activity_allow_status aas
  -- Join activity_allow_status on activity/category/flow/status (for activity_complete_ind)
    ON aas.activity = ae.activity
       AND aas.flow = ae.flow
       AND aas.activity_ctgry = ae.activity_ctgry
       AND aas.status = ae.status
  LEFT OUTER JOIN activity_event_entry aee
  -- Join activity_event_entry to ensure we haven't already created an event entry on the given date
    ON aee.target_activity_id = ta.id
       AND aee.activity_event_id = ae.activity_event_id
       AND aee.event_dt = ?1
WHERE
  (TIMESTAMPADD(DAY, ae.delay, CASE WHEN aas.cmplt_activity_ind = 1
    THEN CAST(ta.cmplt_date AS DATE)
                               ELSE ta.active_date END) = ?1
   -- Add delay to activeDate/completeDate based on actiivty_complete_ind
   OR
   CASE
   WHEN ae.recurring IS NOT
        NULL -- If recurring is defined, ensure active date is before given date and check if we land on a recurring date
     THEN CASE WHEN aas.cmplt_activity_ind = 1
       THEN CAST(ta.cmplt_date AS DATE)
          ELSE ta.active_date END <= ?1 AND
          ((TIMESTAMPDIFF(DAY, CASE WHEN aas.cmplt_activity_ind = 1
            THEN CAST(ta.cmplt_date AS DATE)
                               ELSE ta.active_date END, ?1) - ae.delay) % ae.recurring = 0)
   ELSE FALSE
   END)
  AND
  CASE
  WHEN ae.end IS NOT NULL -- If end is defined, check if delay + end is after given date, else event isn't valid
    THEN TIMESTAMPADD(DAY, ae.end + ae.delay, CASE WHEN aas.cmplt_activity_ind = 1
      THEN CAST(ta.cmplt_date AS DATE)
                                              ELSE ta.active_date END) >= ?1
  ELSE TRUE
  END
  AND aee.activity_event_entry_id IS NULL       -- We don't want duplicate events
  AND ae.active = 1;

-- dorf funded status hook - check for null funded_dt on apps with FUNDED status
select a.id,
       a.funded_dt,
       a.updated_dt last_app_update,
       ta.cmplt_date fund_loan_cmplt,
       a.updated_dt - ta.cmplt_date seconds_between
from   application a
           join target_activity ta on a.id = CAST(ta.target_id as CHAR(50))
                                      and ta.target_type = 'APP'
                                      and ta.activity = 'fund loan'
                                      and ta.status = 'CMPLT'
where  a.status = 'FUNDED'
       and a.funded_dt is null
       and a.active = 1
order by a.updated_dt desc;

-- list of activities in schd that should get the funded_dt set through dorffundedstatushook
SELECT *
FROM target_activity ta
WHERE ta.target_type = 'APP' AND ta.activity = 'fund loan' AND ta.status = 'SCHD' AND ta.flow = 'REFI'
      AND (ta.activity_ctgry = 'system' OR ta.activity_ctgry = 'tech review') AND
      ta.active_date BETWEEN date_sub(curdate(), INTERVAL 1 DAY) AND curdate();

-- find all fraud review that have occurred since midnight today
SELECT *
FROM target_activity ta
WHERE ta.status = 'FRAUD REVIEW' AND ta.cmplt_date < curdate()

-- find all activities cmplt_by/target_id=USER_ID as well as target_id=APP_ID
SELECT t.*
FROM sofi.target_activity t
WHERE cmplt_by = '2382817' or target_id='2382817' or target_id = '6521187' ORDER BY cmplt_date ASC

-- pull up the fraud_info table for a particular borrower (to see the fraud_indicator)
SELECT *
FROM fraud_info fi
WHERE fi.party_id = 940327

-- find any activities that are in assigned status with an active_date greater than now ... meaning InitiateFraudReview
-- did not cleanup all ASSIGNED and SCHD activities.
SELECT *
FROM target_activity
WHERE status = 'ASSIGNED' AND active_date > now();

-- like the one above, but joining with activity table to checkout the human_task_ind
SELECT *
FROM target_activity ta
  JOIN activities a ON ta.activity = a.activity
                       AND ta.activity_ctgry = a.activity_ctgry
                       AND ta.flow = a.flow
WHERE ta.target_type = 'APP' AND ta.asgn_to = 3236 AND
      (ta.status = 'ASSIGNED' AND ta.active_date > now() AND a.human_task_ind = 1);

-- document regenerate hook queries - see if things are processing
SELECT *
from target_activity ta
where ta.target_type='APP' and ta.flow='REFI' -- and ta.cmplt_date is null
and ((ta.activity='signing' and ta.activity_ctgry='borr action' and ta.status='REGENERATE')
  or(ta.activity='signature review' and ta.activity_ctgry='supervisor review' and ta.status='RETRY')
  or(ta.activity='fix prom packet error' and ta.activity_ctgry='tech review' and ta.status='RETRY'))
order by ta.cmplt_date desc;


-- initiate post funding qc
SELECT *
FROM target_activity
WHERE activity = 'initiate postfund qc' AND target_type = 'APP' AND status = 'SCHD';

SELECT *
FROM target_activity
WHERE activity = 'initiate postfund qc' AND target_type = 'APP' AND status = 'CMPLT'
ORDER BY cmplt_date DESC;

SELECT *
FROM target_activity
WHERE activity = 'initiate prefund qc' AND target_type = 'APP' AND status = 'CMPLT'
ORDER BY cmplt_date DESC;

SELECT *
FROM target_activity
WHERE activity = 'fund loan' AND target_type = 'APP' -- AND status = 'CMPLT'
ORDER BY cmplt_date DESC;

select now();

-- verify ProcessQcReviewResultConsumer is working (as long as it hangs around 5% it's good)
SELECT
  sum(c.SL_skipped)                                                                                        sl_skipped,
  sum(c.SL_cmplt)                                                                                          sl_cmplt,
  sum(c.SL_other)                                                                                          SL_other,
  sum(c.PL_skipped)                                                                                        PL_skipped,
  sum(c.PL_cmplt)                                                                                          PL_cmplt,
  sum(c.PL_other)                                                                                          PL_other,
  concat(round(100 * (sum(c.SL_cmplt) / (sum(c.SL_skipped) + sum(c.SL_cmplt) + sum(c.SL_other))), 2), '%') SL_rate,
  concat(round(100 * (sum(c.PL_cmplt) / (sum(c.PL_skipped) + sum(c.PL_cmplt) + sum(c.PL_other))), 2), '%') PL_rate
FROM (
       SELECT
         if(ta.flow = 'REFI' AND ta.status = 'SKIPPED', 1, 0)                 SL_SKIPPED,
         if(ta.flow = 'REFI' AND ta.status = 'CMPLT', 1, 0)                   SL_CMPLT,
         if(ta.flow = 'REFI' AND ta.status NOT IN ('SKIPPED', 'CMPLT'), 1, 0) SL_OTHER,
         if(ta.flow = 'PL' AND ta.status = 'SKIPPED', 1, 0)                   PL_SKIPPED,
         if(ta.flow = 'PL' AND ta.status = 'CMPLT', 1, 0)                     PL_CMPLT,
         if(ta.flow = 'PL' AND ta.status NOT IN ('SKIPPED', 'CMPLT'), 1, 0)   PL_OTHER
       FROM target_activity ta
       WHERE ta.activity LIKE 'initiate postfund qc'
             AND date(ta.cmplt_date) = date(now()) -- date('2018-07-17 17:00:00') -- date(now())
             AND ta.flow IN ('REFI', 'PL')
     ) c;

-- SLAA
select * from target_activity_qualifications taq
 join activity_ctgry_qualifications a ON taq.activity_ctgry_qual_id = a.activity_ctgry_qual_id
 join activity_action_qualifications a2 ON a.activity_actn_qual_id = a2.activity_actn_qual_id
 join adverse_action_reason a3 ON a2.adverse_action_reason_id = a3.id -- comment out this line if full query returns empty
where taq.target_activity_id = 91289460;

-- combine target_activity with target_cmnts on 'auto verify employment and income'
select a.activity, a.status, c.cmnt, c.created_dt
from target_activity a
join target_cmnts c on a.id = c.target_activity_id
where a.activity = 'auto verify employment and income' and a.status = 'ERROR';

select *
from target_activity t
where t.flow='MORTGAGE' and t.cmplt_date > '2018-08-24'
ORDER BY t.cmplt_date DESC ;


SELECT l FROM ApplicationLockdown l WHERE l.applicationRelation = :applicationRelation AND l.effectiveEndDate IS null ORDER BY l.id desc;

select *
from application_lockdown l
where l.application_relation_id =7083505
and l.effective_end_dt is null;

select max(id) from target_activity;

select * from target_cmnts t where t.id >=143634807 limit 10

select ar.application_id, count(*) as count
from application_relation ar
group by ar.application_id
having count > 1

select *
from target_activity
where id > 97000000
      and flow='PL' and activity = 'application review' and status in ('SCHD')

-- in QA and signing
select *
from   target_activity qa,
       target_activity s
where  qa.target_id = s.target_id
       and qa.activity = 'initiate prefund qa' and qa.status in ('SCHD', 'ASSIGNED')
       and s.activity = 'signing' and s.status in ('SCHD');

-- insert mort/stearns loan app for testing
INSERT INTO sofi.application (id, dtype, flow_version, new_loan_app_id, primary_app_id, applicant_id, coborrower_id,
                              allow_cosigner, program_id, university_id, offer_id, borr_offer_id, product_id, status,
                              submission_dt, approved_dt, funded_dt, converted_dt, signed_dt, rejected_dt,
                              reject_reason, identity_info_id, current_address_id, mailing_address_id,
                              previous_address_id, future_address_id, relocating, employment_timing, employment_info_id,
                              employer_address_id, housing_status, housing_cost, other_income, other_income_amount,
                              other_income_frequency, other_income_type, fref_type, fref_id, fref_address_id, pref_type,
                              pref_id, pref_address_id, created_dt, updated_dt, active, graduation_dt, grace_period,
                              employment_status, docs_status, program_detail, waitlist_added_dt, estimated_loan_amount,
                              zipcode, pdf_captcha, identity_verification_result, commonline_id, owner_id,
                              amount_requested, repayment_start, funding_expected, credit_info_match, assignee_id,
                              preapproval_status, domain_id, created_by, updated_by, soft_credit_pull, hard_credit_pull,
                              student_id, lock_down, pl_fund_use_id, risk_rating, risk_rating_reason,
                              risk_rating_reason_other, fraud_investigated, rush_priority, married_coapplicant)
VALUES (2049, 'MORT', '1.0', NULL, NULL, 35059, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        '2019-09-10 17:46:11', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-10 17:45:42', NULL, 1, NULL, NULL, NULL, NULL,
        NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 300000.00, NULL, NULL, NULL, NULL, 'Approve', NULL,
        'then@test.com', NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL);
