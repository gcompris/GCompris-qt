CREATE TABLE dataset_ (
	dataset_id           INTEGER NOT NULL  PRIMARY KEY AUTOINCREMENT ,
	activity_id          INTEGER NOT NULL    ,
	dataset_objective    TEXT NOT NULL    ,
	dataset_name         TEXT NOT NULL    ,
	dataset_difficulty   INTEGER NOT NULL   ,
	dataset_content      TEXT NOT NULL    ,
	FOREIGN KEY ( activity_id ) REFERENCES activity_( activity_id ),
	CONSTRAINT unq_dataset_name UNIQUE ( dataset_name, activity_id )
 );

CREATE VIEW _dataset_activity AS
    SELECT dataset_.dataset_id, dataset_.activity_id, dataset_objective, dataset_name, dataset_difficulty, dataset_content, activity_name
      FROM dataset_, activity_
     WHERE dataset_.activity_id=activity_.activity_id
     GROUP BY dataset_.activity_id;
