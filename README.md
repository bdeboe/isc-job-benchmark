# Running the JOIN Order Benchmark on IRIS

This repository contains scripts for running the JOIN Order Benchmark (JOB) on InterSystems IRIS. 
The JOIN Order Benchmark was proposed in "[How Good Are Query Optimizers, Really?](http://www.vldb.org/pvldb/vol9/p204-leis.pdf)" by Viktor Leis, Andrey Gubichev, Atans Mirchev, Peter Boncz, Alfons Kemper, Thomas Neumann; PVLDB Volume 9, No. 3, 2015. 

## Sources

The queries included in this repository are copied from https://github.com/gregrahn/join-order-benchmark.

We propose running the test using the same CSV files used in the paper, representing the IMDB Data Set from May 2013, which can be found at http://homepages.cwi.nl/~boncz/job/imdb.tgz. The license and links to the current version IMDB data set can be found at http://www.imdb.com/interfaces.

## In this repository

- `src/cls/` contains a minimal utility class to set up the environment and run the queries. The focus is on maximizing SQL feature use.
- `src/sql/` contains the JOB queries, as copied verbatim from https://github.com/gregrahn/join-order-benchmark
- `src/ddl/` contains the DDL statements to set up and load the schema. Table creation DDL is a near-verbatim copy of what's in `schematext.sql` script included with `imdb.tgz`.

## Setting up

Setup scripts leverage the new `LOAD DATA` syntax available with InterSystems IRIS 2021.3.

1. First, clone this repo into a folder of your choice we'll call `$REPO_ROOT`

2. Download the `imdb.tgz` file from the link above and untar to `$REPO_ROOT/data/`

3. Import the script runner from the `$REPO_ROOT/src/cls/` folder:

   ```ObjectScript
   do $system.OBJ.ImportDir("$REPO_ROOT/src/cls/",,"c",,1)
   ```

4. Run the `Setup()` method, supplying the path you cloned this repository to:

   ```ObjectScript
   do ##class(JOB.Utils).Setup("$REPO_ROOT")
   ```


## Overview of changes vs original DDL & SQL

### DDL

- in `role_type.sql`, adding double quotes around the reserved word "role"
- in `keyword.sql`, specify a larger max length for the keyword column as IRIS defaults to 1 rather than unlimited when not specifying a value.

### SQL 

nothing yet