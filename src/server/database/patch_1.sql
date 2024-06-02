CREATE INDEX idx_result_datetime ON result_ ( result_datetime );
ALTER TABLE result_ ADD result_succeed INTEGER   NOT NULL DEFAULT 0;
UPDATE result_ SET result_succeed=json_extract(result_data,'$.ok');
