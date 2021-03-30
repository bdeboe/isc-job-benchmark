LOAD DATA
  FROM FILE '${DATA_DIR}keyword.csv'
  INTO keyword
  USING '{ "from": {"file": {"escapechar":"\\"} } }'
