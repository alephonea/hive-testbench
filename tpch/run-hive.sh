#!/bin/bash

SCRIPT_PATH=dirname( __FILE__ );

db="tpch_flat_orc_$scale"
query="${SCRIPT_PATH}/../sample-queries-tpch/tpch_query1.sql"

$cmd="echo 'use $db; source $query;' | hive -i $settings"

bash -c $cmd"
