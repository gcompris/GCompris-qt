DROP VIEW IF EXISTS _all_users_activities;

CREATE VIEW _all_users_activities AS
SELECT user_.user_id, activity_.activity_id, user_name, activity_name, result_datetime, result_success, result_duration, result_data
  FROM result_, activity_, user_
 WHERE result_.activity_id=activity_.activity_id
   AND result_.user_id=user_.user_id;
