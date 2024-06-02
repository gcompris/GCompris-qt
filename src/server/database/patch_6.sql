DROP VIEW IF EXISTS _all_groups_activities;

DROP VIEW IF EXISTS _group_activity_result;

CREATE VIEW _all_groups_activities AS
SELECT user_.user_id, group_.group_id, activity_.activity_id, user_name, group_name, activity_name, result_datetime, result_success, result_duration, result_data
  FROM result_, activity_, user_, group_, group_user_
 WHERE result_.activity_id=activity_.activity_id
   AND group_user_.user_id=user_.user_id
   AND group_user_.group_id=group_.group_id
   AND result_.user_id=user_.user_id;

CREATE VIEW _group_activity_result AS
SELECT group_.group_id, user_.user_id, group_name, user_name, result_.activity_id, activity_name, count(result_.activity_id) as count_activity
  FROM result_, user_, activity_, group_, group_user_
 WHERE activity_.activity_id=result_.activity_id
   AND group_user_.user_id=user_.user_id
   AND group_user_.group_id=group_.group_id
   AND result_.user_id=user_.user_id
 GROUP BY group_.group_id, activity_.activity_id;
