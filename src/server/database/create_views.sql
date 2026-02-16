CREATE VIEW _all_groups AS
SELECT user_.user_id, group_.group_id, group_name, user_name, user_password
 FROM group_, user_, group_user_
WHERE user_.user_id = group_user_.user_id
  AND group_user_.group_id = group_.group_id;


CREATE VIEW _all_users_activities AS
SELECT user_.user_id, activity_.activity_id, user_name, activity_name, result_datetime, result_success, result_duration, result_data
  FROM result_, activity_, user_
 WHERE result_.activity_id=activity_.activity_id
   AND result_.user_id=user_.user_id;


CREATE VIEW _all_groups_activities AS
SELECT user_.user_id, group_.group_id, activity_.activity_id, user_name, group_name, activity_name, result_datetime, result_success, result_duration, result_data
  FROM result_, activity_, user_, group_, group_user_
 WHERE result_.activity_id=activity_.activity_id
   AND group_user_.user_id=user_.user_id
   AND group_user_.group_id=group_.group_id
   AND result_.user_id=user_.user_id;


CREATE VIEW _group_users AS
    SELECT group_.group_id, group_name, group_description
    , group_concat(group_user_.user_id) AS users_id
    , group_concat(user_name) AS users_name
      FROM user_, group_, group_user_
     WHERE group_user_.group_id=group_.group_id
       AND user_.user_id=group_user_.user_id
     GROUP BY group_.group_id
  UNION
    SELECT group_.group_id, group_name, group_description, "" AS users_id, "" AS users_name
      FROM group_
     WHERE group_id IN (SELECT group_id FROM group_ WHERE group_id NOT IN (SELECT DISTINCT group_id FROM group_user_));


CREATE VIEW _user_activity_result AS
    SELECT user_.user_id, user_name, result_.activity_id, activity_name, count(result_.activity_id) AS count_activity,
           SUM(CASE WHEN result_.result_success > 0 THEN 1 ELSE 0 END) AS count_success,
           SUM(CASE WHEN result_.result_success = 0 THEN 1 ELSE 0 END) AS count_failed
      FROM result_, user_, activity_
     WHERE user_.user_id=result_.user_id
       AND activity_.activity_id=result_.activity_id
     GROUP BY user_.user_id, activity_.activity_id;


CREATE VIEW _group_activity_result AS
SELECT group_.group_id, user_.user_id, group_name, user_name, result_.activity_id, activity_name, count(result_.activity_id) AS count_activity
  FROM result_, user_, activity_, group_, group_user_
 WHERE activity_.activity_id=result_.activity_id
   AND group_user_.user_id=user_.user_id
   AND group_user_.group_id=group_.group_id
   AND result_.user_id=user_.user_id
 GROUP BY group_.group_id, activity_.activity_id;


CREATE VIEW _user_groups AS
    SELECT user_.user_id, user_name, user_password
         , group_concat(group_user_.group_id) AS groups_id, group_concat(group_name) AS groups_name
      FROM user_, group_, group_user_
      WHERE group_user_.group_id=group_.group_id
       AND user_.user_id=group_user_.user_id
    GROUP BY user_.user_id
UNION
    SELECT user_.user_id, user_name, user_password, "" AS groups_id, "" AS groups_name
      FROM user_
         WHERE user_id NOT IN (SELECT DISTINCT user_id FROM group_user_);


CREATE VIEW _daily_activities AS
    SELECT activity_.activity_id, activity_name, substr(result_datetime,0,11) AS result_day, count(result_.activity_id) AS count_activity
      FROM result_, activity_
     WHERE activity_.activity_id=result_.activity_id
     GROUP BY result_.activity_id, result_day;


CREATE VIEW _daily_ratios AS
    SELECT result_.user_id, result_.activity_id, activity_name, user_name, date(result_datetime) AS result_day, count(result_.activity_id) AS count_activity, avg(result_success) AS success_ratio, sum(result_duration) AS sum_duration
      FROM result_, activity_, user_
     WHERE result_.activity_id=activity_.activity_id
     AND result_.user_id=user_.user_id
     GROUP BY result_day, result_.activity_id;


CREATE VIEW _dataset_activity AS
    SELECT dataset_.dataset_id, dataset_.activity_id, dataset_objective, dataset_name, internal_name, dataset_difficulty, dataset_content, is_created_dataset, activity_name
      FROM dataset_, activity_
     WHERE dataset_.activity_id=activity_.activity_id;

