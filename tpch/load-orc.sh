#!/bin/bash

set -e

TABLES="part partsupp supplier customer orders lineitem nation region"

SCALE=$1

DIR=$2
if [ X"$DIR" = "X" ]; then
	DIR=/tmp/tpch-generate
fi
	
if test $SCALE -le 1000; then 
  SCHEMA_TYPE=flat
else
	SCHEMA_TYPE=partitioned
fi

DATABASE=tpch_flat_orc_${SCALE}
BUCKETS=13
REDUCERS=$SCALE

for t in ${TABLES}
do
hive -i settings/load-${SCHEMA_TYPE}.sql -f ddl-tpch/bin_${SCHEMA_TYPE}/${t}.sql -d DB=${DATABASE} -d SOURCE=tpch_text_${SCALE} -d BUCKETS=${BUCKETS} -d SCALE=${SCALE} -d REDUCERS=${REDUCERS} -d FILE=orc
done


