CREATE DATABASE gke_test_zonal;
\c gke_test_zonal;

CREATE TABLE tb01 (
  id SERIAL UNIQUE NOT NULL,
  code VARCHAR(10) NOT NULL, -- not unique
  article TEXT,
  name TEXT NOT NULL, -- not unique
  department VARCHAR(4) NOT NULL,
  col01 TEXT NOT NULL,
  col02 TEXT NOT NULL,
  col03 TEXT NOT NULL,
  col04 TEXT NOT NULL,
  col05 TEXT NOT NULL,
  col06 TEXT NOT NULL,
  col07 TEXT NOT NULL,
  col08 TEXT NOT NULL,
  col09 TEXT NOT NULL,
  col10 TEXT NOT NULL,
  col11 TEXT NOT NULL,
  col12 TEXT NOT NULL,
  col13 TEXT NOT NULL,
  col14 TEXT NOT NULL,
  col15 TEXT NOT NULL,
  col16 TEXT NOT NULL,
  col17 TEXT NOT NULL,
  UNIQUE (code, department)
);
CREATE TABLE tb02 (
  id SERIAL UNIQUE NOT NULL,
  code VARCHAR(10) NOT NULL, -- not unique
  article TEXT,
  name TEXT NOT NULL, -- not unique
  department VARCHAR(4) NOT NULL,
  col01 TEXT NOT NULL,
  col02 TEXT NOT NULL,
  col03 TEXT NOT NULL,
  col04 TEXT NOT NULL,
  col05 TEXT NOT NULL,
  col06 TEXT NOT NULL,
  col07 TEXT NOT NULL,
  col08 TEXT NOT NULL,
  col09 TEXT NOT NULL,
  col10 TEXT NOT NULL,
  col11 TEXT NOT NULL,
  col12 TEXT NOT NULL,
  col13 TEXT NOT NULL,
  col14 TEXT NOT NULL,
  col15 TEXT NOT NULL,
  col16 TEXT NOT NULL,
  col17 TEXT NOT NULL,
  UNIQUE (code, department)
);
insert into tb01 (
    code, article, name, department,col01,col02,col03,col04,col05,col06,col07,col08,col09,col10,col11,col12,col13,col14,col15,col16,col17
)
select
    left(md5(i::text), 10),
    md5(random()::text),
    md5(random()::text),
    left(md5(i::text), 4),
    left(md5(random()::text),2),
    left(md5(random()::text),2),
    left(md5(random()::text),2),
    left(md5(random()::text),2),
    left(md5(random()::text),2),
    left(md5(random()::text),2),
    left(md5(random()::text),2),
    left(md5(random()::text),2),
    left(md5(random()::text),2),
    left(md5(random()::text),2),
    left(md5(random()::text),2),
    left(md5(random()::text),2),
    left(md5(random()::text),2),
    left(md5(random()::text),2),
    left(md5(random()::text),2),
    left(md5(random()::text),2),
    left(md5(random()::text),2)
from generate_series(1, 300000) s(i);

insert into tb02 (
    code, article, name, department,col01,col02,col03,col04,col05,col06,col07,col08,col09,col10,col11,col12,col13,col14,col15,col16,col17
)
select
    left(md5(i::text), 10),
    md5(random()::text),
    md5(random()::text),
    left(md5(i::text), 4),
    left(md5(random()::text),2),
    left(md5(random()::text),2),
    left(md5(random()::text),2),
    left(md5(random()::text),2),
    left(md5(random()::text),2),
    left(md5(random()::text),2),
    left(md5(random()::text),2),
    left(md5(random()::text),2),
    left(md5(random()::text),2),
    left(md5(random()::text),2),
    left(md5(random()::text),2),
    left(md5(random()::text),2),
    left(md5(random()::text),2),
    left(md5(random()::text),2),
    left(md5(random()::text),2),
    left(md5(random()::text),2),
    left(md5(random()::text),2)
from generate_series(1, 300000) s(i);
