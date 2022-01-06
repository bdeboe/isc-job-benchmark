LOAD DATA
  FROM FILE '${DATA_DIR}cast_info.csv'
  INTO cast_info
  USING '{ "from": {"file": {"escapechar":"\\"} } }'
