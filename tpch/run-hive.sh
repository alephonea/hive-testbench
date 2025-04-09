#!/bin/bash

set -e
set -x

queries="1"
SCALE=200
SCRIPT_PATH=$(dirname $BASH_SOURCE)
settings="${SCRIPT_PATH}/.././sample-queries-tpch/testbench.settings"
db="tpch_flat_orc_$SCALE"

for num in $queries
do
  query_path="${SCRIPT_PATH}/../sample-queries-tpch/tpch_query${num}.sql"
  explain_path="/tmp/tcph-q-explain-${num}.sql"
  echo "EXPLAIN " > $explain_path
  cat $query_path >> $explain_path
  cmd="echo 'use $db; source $explain_path;' | hive -i $settings"
  cmd="echo 'use $db; source $query_path;' | hive -i $settings"
done

echo $cmd
