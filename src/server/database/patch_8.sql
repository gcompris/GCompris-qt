CREATE VIEW _daily_activities AS
    SELECT activity_.activity_id, activity_name, substr(result_datetime,0,11) AS result_day, count(result_.activity_id) AS count_activity
      FROM result_, activity_
     WHERE activity_.activity_id=result_.activity_id
     GROUP BY result_.activity_id, result_day;

UPDATE activity_
   SET activity_name=SUBSTR(activity_name,0,INSTR(activity_name, '/'));
