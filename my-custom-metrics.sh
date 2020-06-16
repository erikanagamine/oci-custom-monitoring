#!/bin/bash

export compartmentId=<put your compartmentOCId here to monitoring>
export mymetricsnamespace=cpu
export collectDate=`date --utc +%Y-%m-%dT%H:%M:%S+00:00`



echo '[
    {
      "compartmentId": "'`echo $compartmentId`'",
      "datapoints": [
        {
          "count": 1,
          "timestamp": "'`echo $collectDate`'",
          "value": '`echo uptime | cut -d, -f3 | cut -d: -f2 | awk '{print int($1+0.5)}'`'
        }
      ],
      "dimensions": {
        "metric": "cpu",
        "server": "'`hostname`'"
      },
      "metadata": {
        "category": "'`hostname`'",
        "note": "Metrics from my server - '`hostname`'"
      },
      "name": "cpu",
      "namespace": "'`echo $mymetricsnamespace`'",
      "resourceGroup": "Infrastructure"
    }
  ]'  > custom-metrics.json


## send metrics to console
oci monitoring metric-data post --endpoint https://telemetry-ingestion.us-ashburn-1.oraclecloud.com --metric-data file://./custom-metrics.json
