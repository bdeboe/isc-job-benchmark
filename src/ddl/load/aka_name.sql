LOAD DATA
  FROM FILE '${DATA_DIR}aka_name.csv'
  INTO aka_name
  USING '{ "from": {"file": {"escapechar":"\\"} } }'
