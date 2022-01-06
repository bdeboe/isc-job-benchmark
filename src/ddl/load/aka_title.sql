LOAD DATA
  FROM FILE '${DATA_DIR}aka_title.csv'
  INTO aka_title
  USING '{ "from": {"file": {"escapechar":"\\"} } }'
