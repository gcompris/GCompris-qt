CREATE VIEW _daily_ratios AS
    SELECT result_.user_id, result_.activity_id, activity_name, user_name, date(result_datetime) AS result_day, count(result_.activity_id) AS count_activity, avg(result_success) AS success_ratio, sum(result_duration) AS sum_duration
      FROM result_, activity_, user_
     WHERE result_.activity_id=activity_.activity_id
     AND result_.user_id=user_.user_id
     GROUP BY result_day, result_.activity_id;
