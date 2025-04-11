DROP VIEW _dataset_activity;

CREATE VIEW _dataset_activity AS
    SELECT dataset_.dataset_id, dataset_.activity_id, dataset_objective, dataset_name, dataset_difficulty, dataset_content, activity_name
      FROM dataset_, activity_
     WHERE dataset_.activity_id=activity_.activity_id;
