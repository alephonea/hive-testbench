#!/bin/bash

set -e

SCALE=$1
if test $SCALE -le 1000; then 
  SCHEMA_TYPE=flat
else
	SCHEMA_TYPE=partitioned
fi

DATABASE=tpch_flat_orc_${SCALE}

hive -i settings/load-${SCHEMA_TYPE}.sql -f ddl-tpch/bin_${SCHEMA_TYPE}/analyze.sql --database ${DATABASE}; 
