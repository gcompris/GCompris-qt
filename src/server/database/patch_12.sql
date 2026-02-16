ALTER TABLE dataset_ ADD is_created_dataset BOOLEAN  NOT NULL DEFAULT TRUE;

ALTER TABLE dataset_ ADD internal_name TEXT;
UPDATE dataset_ SET internal_name = concat("c-", dataset_name);

DROP VIEW _dataset_activity;

CREATE VIEW _dataset_activity AS
    SELECT dataset_.dataset_id, dataset_.activity_id, dataset_objective, dataset_name, internal_name, dataset_difficulty, dataset_content, is_created_dataset, activity_name
      FROM dataset_, activity_
     WHERE dataset_.activity_id=activity_.activity_id;

