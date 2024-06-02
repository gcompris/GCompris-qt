DROP VIEW IF EXISTS _user_activity_result;

CREATE VIEW _user_activity_result AS
    SELECT user_.user_id, user_name, result_.activity_id, activity_name, count(result_.activity_id) as count_activity,
           SUM(CASE WHEN result_.result_success > 0 THEN 1 ELSE 0 END) AS count_success,
           SUM(CASE WHEN result_.result_success = 0 THEN 1 ELSE 0 END) AS count_failed
      FROM result_, user_, activity_
     WHERE user_.user_id=result_.user_id
       AND activity_.activity_id=result_.activity_id
     GROUP BY user_.user_id, activity_.activity_id;
