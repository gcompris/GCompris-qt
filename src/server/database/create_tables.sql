CREATE TABLE activity_ (
	activity_id          INTEGER NOT NULL  PRIMARY KEY AUTOINCREMENT ,
	activity_name        TEXT NOT NULL    ,
	CONSTRAINT unq_activity_name UNIQUE ( activity_name )
 );

CREATE TABLE group_ (
	group_id             INTEGER NOT NULL  PRIMARY KEY AUTOINCREMENT ,
	group_name           TEXT NOT NULL    ,
	group_description    TEXT     ,
	CONSTRAINT unq_group_name UNIQUE ( group_name )
 );

CREATE TABLE teacher_ (
	teacher_id           INTEGER NOT NULL  PRIMARY KEY AUTOINCREMENT ,
	teacher_login        TEXT NOT NULL    ,
	teacher_password     TEXT NOT NULL    ,
	teacher_created      DATE NOT NULL DEFAULT CURRENT_TIMESTAMP   ,
	teacher_dbversion    INTEGER NOT NULL DEFAULT 0   ,
	teacher_dbcrypted    INTEGER NOT NULL DEFAULT 0   ,
	CONSTRAINT unq_teacher_login UNIQUE ( teacher_login )
 );

CREATE TABLE user_ (
	user_id              INTEGER NOT NULL  PRIMARY KEY AUTOINCREMENT ,
	user_name            TEXT NOT NULL    ,
	user_password        TEXT NOT NULL    ,
	CONSTRAINT unq_user_name UNIQUE ( user_name )
 );

CREATE TABLE group_user_ (
	group_id             INTEGER NOT NULL    ,
	user_id              INTEGER NOT NULL    ,
	CONSTRAINT pk_group_users PRIMARY KEY ( group_id, user_id ),
	FOREIGN KEY ( user_id ) REFERENCES user_( user_id )  ,
	FOREIGN KEY ( group_id ) REFERENCES group_( group_id )
 );

CREATE TABLE result_ (
	user_id              INTEGER NOT NULL    ,
	activity_id          INTEGER NOT NULL    ,
	result_datetime      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP   ,
	result_data          TEXT NOT NULL    ,
	result_success       INTEGER NOT NULL DEFAULT 0   ,
	result_duration      INTEGER NOT NULL DEFAULT -1   ,
	FOREIGN KEY ( user_id ) REFERENCES user_( user_id )  ,
	FOREIGN KEY ( activity_id ) REFERENCES activity_( activity_id )
 );

CREATE TABLE dataset_ (
	dataset_id           INTEGER NOT NULL  PRIMARY KEY AUTOINCREMENT ,
	activity_id          INTEGER NOT NULL    ,
	dataset_objective    TEXT NOT NULL    ,
	dataset_name         TEXT NOT NULL    ,
	dataset_difficulty   INTEGER NOT NULL   ,
	dataset_content      TEXT NOT NULL    ,
        is_created_dataset   BOOLEAN  NOT NULL  ,
	FOREIGN KEY ( activity_id ) REFERENCES activity_( activity_id ),
	CONSTRAINT unq_dataset_name UNIQUE ( dataset_name, activity_id )
 );

CREATE INDEX idx_activity_user_id ON result_ ( user_id );

CREATE INDEX idx_activity_user_name ON result_ ( activity_id );

CREATE INDEX idx_result_datetime ON result_ ( result_datetime );
