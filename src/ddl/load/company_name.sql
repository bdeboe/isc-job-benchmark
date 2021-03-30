LOAD DATA
  FROM FILE '${DATA_DIR}company_name.csv'
  INTO company_name
  USING '{ "from": {"file": {"escapechar":"\\"} } }'
