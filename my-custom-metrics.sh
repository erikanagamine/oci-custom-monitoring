#!/bin/bash
### OCI Customized Metrics
### Version 1.0

source ~/.bashrc
## Please customize this files
export compartmentId=<your compartment ID>
export regionId=<your region>

export collectMetrics=custom-metrics.json
export collectDate=`date --utc +%Y-%m-%dT%H:%M:%S+00:00`

border()
{
    title="| $1 |"
    edge=$(echo "$title" | sed 's/./-/g')
    echo "$edge"
    echo "$title"
    echo "$edge"
}



collectCPU () {
  ## Collect CPU metrics
  export CPU_USAGE=`sar 1 5 | grep "Average" | sed 's/^.* //'`
  export mymetricsnamespace=cpu

  border "Collecting CPU - $collectDate"

  echo ' {'  >> $collectMetrics
  echo '  "compartmentId": "'`echo $compartmentId`'",'  >> $collectMetrics
  echo '  "datapoints": ['  >> $collectMetrics
  echo ' {'  >> $collectMetrics
  echo '  "count": "'`lscpu | grep "^CPU(" | cut -d: -f2`'"'  >> $collectMetrics
  echo '  ,"timestamp": "'`echo $collectDate`'"'  >> $collectMetrics
  echo '  ,"value": '`echo 100-$CPU_USAGE | bc`''  >> $collectMetrics
  echo ' }'  >> $collectMetrics
  echo '],'  >> $collectMetrics
  echo '"dimensions": {'  >> $collectMetrics
  echo ' "metric": "cpu"'  >> $collectMetrics
  echo ' ,"server": "'`hostname`'"'  >> $collectMetrics
  echo ' },'  >> $collectMetrics
  echo ' "metadata": {'  >> $collectMetrics
  echo ' "category": "'`hostname`'"'  >> $collectMetrics
  echo ' ,"note": "Metrics from my server - '`hostname`'"'  >> $collectMetrics
  echo ' },'  >> $collectMetrics
  echo ' "name": "'`echo $mymetricsnamespace`'"'  >> $collectMetrics
  echo ' ,"namespace": "'`echo $mymetricsnamespace`'_server"'  >> $collectMetrics
  echo ' },'  >> $collectMetrics

}

sendOci () {

  border "Sending to OCI - $collectDate"

  if [ -f "$collectMetrics" ]; then
    sed -i '1i[' $collectMetrics
    sed -i '$ s/.$//'  $collectMetrics
    echo "]" >> $collectMetrics
     ## send metrics to console
    oci monitoring metric-data post --endpoint https://telemetry-ingestion.$regionId.oraclecloud.com --metric-data file://./$collectMetrics
    mv $collectMetrics $collectMetrics.bkp
  else 
    echo "$collectMetrics does not exist. Please collect metrics first."
  fi

}


helpFunction()
{
   echo ""
   echo "Usage: $0 -i all -s all"
   echo -e "\t-i collect infraestructure metrics"
   echo -e "\t-s send metrics to console"
   exit 1 # Exit script after printing help
}


while getopts "i:s:" opt
do
   case "$opt" in
      i ) collectCPU;;
      s ) sendOci;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

