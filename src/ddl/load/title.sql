LOAD DATA
  FROM FILE '${DATA_DIR}title.csv'
  INTO title
  USING '{ "from": {"file": {"escapechar":"\\"} } }'
