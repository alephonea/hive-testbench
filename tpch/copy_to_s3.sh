#!/bin/bash

set -e
set -x

TABLES="customer orders part partsupp supplier lineitem nation region"
SCALE=200

for t in ${TABLES}
do
echo $t
mkdir -p /tmp/${t}
hdfs dfs -ls -C /user/hive/warehouse/tpch_flat_orc_$SCALE.db/${t} | awk -F'/' '{print $NF}' > /tmp/${t}/partnames
for partname in $(</tmp/${t}/partnames)
do
  hdfs dfs -get /user/hive/warehouse/tpch_flat_orc_$SCALE.db/${t}/${partname} /tmp/${t}
  ~/s3cmd-master/s3cmd put /tmp/${t}/${partname} s3://tpch1/${t}_${partname}
  rm /tmp/${t}/${partname}
done

done
