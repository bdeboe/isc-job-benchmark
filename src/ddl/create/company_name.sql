CREATE TABLE company_name (
    id integer NOT NULL PRIMARY KEY,
    name character varying(32000) NOT NULL,
    country_code character varying(6),
    imdb_id integer,
    name_pcode_nf character varying(5),
    name_pcode_sf character varying(5),
    md5sum character varying(32)
)