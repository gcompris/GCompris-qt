CREATE TABLE sequence_ (
       	sequence_id          INTEGER NOT NULL  PRIMARY KEY AUTOINCREMENT ,
	sequence_objective   TEXT NOT NULL    ,
	sequence_name        TEXT NOT NULL    ,
	CONSTRAINT unq_sequence_id UNIQUE ( sequence_id )
 );

CREATE TABLE activity_with_datasets_ ( 
	act_dat_id           INTEGER NOT NULL  PRIMARY KEY AUTOINCREMENT ,
	activity_id          INTEGER NOT NULL    ,
	dataset_id           INTEGER NOT NULL    ,
	FOREIGN KEY ( activity_id ) REFERENCES activity_( activity_id )  ,
	FOREIGN KEY ( dataset_id ) REFERENCES dataset_( dataset_id )  
 );
 
CREATE TABLE sequence_with_activity_ ( 
	seq_act_id            INTEGER NOT NULL  PRIMARY KEY AUTOINCREMENT ,
	sequence_id           INTEGER NOT NULL    ,
	activity_with_data_id INTEGER NOT NULL    ,
	activity_rank         INTEGER NOT NULL    ,
	FOREIGN KEY ( sequence_id ) REFERENCES sequence_( sequence_id )  ,
	FOREIGN KEY ( activity_with_data_id ) REFERENCES activity_with_datasets_( id )  
 );

CREATE VIEW sequence_activity_ AS
SELECT sequence_.sequence_id, sequence_.sequence_name, sequence_.sequence_objective,
       activity_with_datasets_.activity_id, sequence_with_activity_.activity_rank,
       activity_.activity_name, dataset_.dataset_id, dataset_.dataset_name, dataset_.internal_name
  FROM sequence_, sequence_with_activity_, activity_with_datasets_, dataset_, activity_
WHERE sequence_.sequence_id=sequence_with_activity_.sequence_id
  AND sequence_with_activity_.activity_with_data_id=activity_with_datasets_.act_dat_id
  AND activity_.activity_id=activity_with_datasets_.activity_id
  AND dataset_.dataset_id=activity_with_datasets_.dataset_id
ORDER BY sequence_.sequence_id, sequence_with_activity_.activity_rank ASC;
