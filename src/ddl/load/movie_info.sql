LOAD DATA
  FROM FILE '${DATA_DIR}movie_info.csv'
  INTO movie_info
  USING '{ "from": {"file": {"escapechar":"\\"} } }'
