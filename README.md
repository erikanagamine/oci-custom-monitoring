# OCI Custom Monitoring

The usage of this script is by your own responsability. The main object is help if you need to monitoring some resource on OCI.

If you are not familiar with OCI monitoring, please check in: https://docs.cloud.oracle.com/en-us/iaas/Content/Monitoring/Concepts/monitoringoverview.htm

For custom monitoring you will need to configure OCI cli, please check it in: https://docs.cloud.oracle.com/en-us/iaas/tools/oci-cli/2.12.8/oci_cli_docs/


# Instructions

1. Download script: wget https://raw.githubusercontent.com/erikanagamine/oci-custom-monitoring/master/my-custom-metrics.sh

[oracle@teste ~]$ wget https://raw.githubusercontent.com/erikanagamine/oci-custom-monitoring/master/my-custom-metrics.sh
--2020-09-23 16:16:27--  https://raw.githubusercontent.com/erikanagamine/oci-custom-monitoring/master/my-custom-metrics.sh
Resolving raw.githubusercontent.com (raw.githubusercontent.com)... 151.101.200.133
Connecting to raw.githubusercontent.com (raw.githubusercontent.com)|151.101.200.133|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 2525 (2.5K) [text/plain]
Saving to: 'my-custom-metrics.sh'

100%[==============================================================================>] 2,525       --.-K/s   in 0s

2020-09-23 16:16:28 (25.1 MB/s) - 'my-custom-metrics.sh' saved [2525/2525]

2. Give the permissions

[oracle@teste ~]$ chmod +x my-custom-metrics.sh

3. Customize script with your own parameters
CompartmentId
Region

4. Schedule the script:

```
[oracle@teste ~]$ crontab -l
#monitoring collect
*/5 * * * * sh -x my-custom-metrics.sh -i all > /tmp/monitoring_gen.log
```

5. Install and configure oci cli

