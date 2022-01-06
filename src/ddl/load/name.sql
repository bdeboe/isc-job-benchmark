LOAD DATA
  FROM FILE '${DATA_DIR}name.csv'
  INTO name
  USING '{ "from": {"file": {"escapechar":"\\"} } }'
