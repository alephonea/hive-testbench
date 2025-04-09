#!/bin/bash

set -e
set -x

SCALE=200
output=${HOME}/run_${SCALE}

mkdir -p $output

queries=$(seq 1 22)
SCRIPT_PATH=$(dirname $BASH_SOURCE)
settings="${SCRIPT_PATH}/.././sample-queries-tpch/testbench.settings"
db="tpch_flat_orc_$SCALE"

for num in $queries
do
  query_path="${SCRIPT_PATH}/../sample-queries-tpch/tpch_query${num}.sql"
  explain_path="/tmp/tcph-q-explain-${num}.sql"
  echo "EXPLAIN " > $explain_path
  cat $query_path >> $explain_path
  echo "use $db; source $explain_path;" | hive -i "$settings" 2>&1 | tee -a $output/${num}.explain
  echo "use $db; source $query_path;" | hive -i "$settings" 2>&1 | tee -a $output/${num}.log
  grep "Time taken" $output/${num}.log | tail -n 1 | grep -o -E "[0-9]+\.[0-9]+" > $output/${num}.time
done

echo $cmd
