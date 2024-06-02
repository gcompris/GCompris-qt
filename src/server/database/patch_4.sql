ALTER TABLE result_ RENAME COLUMN result_succeed TO result_success;
UPDATE result_ SET result_success=json_extract(result_data,'$.ok');
UPDATE result_ SET result_data=JSON_REMOVE(result_data, '$.ok');

ALTER TABLE result_ ADD result_duration INTEGER   NOT NULL DEFAULT -1;
UPDATE result_ SET result_duration=json_extract(result_data,'$.elapsed');
UPDATE result_ SET result_data=JSON_REMOVE(result_data, '$.elapsed');

DROP VIEW IF EXISTS _all_users_activities;
CREATE VIEW _all_users_activities AS
SELECT user_.user_id, activity_.activity_id, user_name, activity_name, result_datetime, result_success, result_duration, result_data
  FROM result_, activity_, user_
 WHERE result_.activity_id=activity_.activity_id
   AND result_.user_id=user_.user_id
 ORDER BY user_name, activity_name, result_datetime;
