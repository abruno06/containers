#  hadoop_job image
* this is an example 

    start the image after your cluster is running
```Shell
docker run -it --rm --net cluster-5_hadoop-ring --link master --entrypoint '/bin/bash' aurelbruno06/hadoop_job
```
    inside the image
```Shell
sed s/HOSTNAME/master/ /usr/local/hadoop/etc/hadoop/core-site.xml.tmp > /usr/local/hadoop/etc/hadoop/core-site.xml
hadoop fs -mkdir /data
hadoop fs -put /root/5000-8.txt /data
hadoop fs -ls /data
hadoop jar /root/WordCount.jar WordCountDriver /data /results
[ computation ]
hadoop fs -cat /results
```
