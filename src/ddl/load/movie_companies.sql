LOAD DATA
  FROM FILE '${DATA_DIR}movie_companies.csv'
  INTO movie_companies
  USING '{ "from": {"file": {"escapechar":"\\"} } }'
