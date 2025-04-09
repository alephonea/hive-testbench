#!/usr/bin/pyspark

import os.path.join
from pyspark import SparkContext

def explain(sc, handle):
    return sc._jvm.PythonSQLUtils.explainString(handle._jdf.queryExecution(), "formatted")

def run_query(target_dir, sc, sql, num):
    query_path = os.path.join(os.path.dirname(__file__), '..', 'sample-queries-tpch/tpch_query{}.sql'.format(num))
    query_text = open(query_path).read()

    handle = sql.sql(query_text)
    plan = explain(sc, handle)

    start_time = time.time()
    handle.collect()
    end_time = time.time()

    duration = end_time - start_time

    print("Query ", num, " took ", duration)
    print(plan)

    w = open(os.path.join(target_dir, str(num) + '.time'), 'w')
    w.write(str(duration))
    w.close()

    w = open(os.path.join(target_dir, str(num) + '.plan'), 'w')
    w.write(plan)
    w.close()

def main(sc):
    sql = SQLContext(sc)
    for num in range(1, 23):
        run_query(sc, sql, num)

if __name__ == '__main__':
    sc = SparkContext()
    main(sc)
