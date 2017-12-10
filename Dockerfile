FROM centos
# Install JDK&wget
RUN yum -y install java-1.8.0-openjdk java-1.8.0-openjdk-devel wget
# Add hadoop user & group
RUN groupadd hadoop && \
 useradd -d /home/hadoop -g hadoop -m hadoop
# Install Spark2.2
RUN wget http://ftp.jaist.ac.jp/pub/apache/spark/spark-2.2.0/spark-2.2.0-bin-hadoop2.7.tgz && \
 tar zxvf spark-2.2.0-bin-hadoop2.7.tgz && \
 cp -R spark-2.2.0-bin-hadoop2.7 /usr/local/spark-2.2 && \
 chown -R hadoop. /usr/local/spark-2.2 && \
 rm -rf spark-2.2.0-bin-hadoop2.7.tgz spark-2.2.0-bin-hadoop2.7
# Install Hadoop2.7.4
RUN wget http://ftp.jaist.ac.jp/pub/apache/hadoop/common/hadoop-2.7.4/hadoop-2.7.4.tar.gz && \
 tar zxvf hadoop-2.7.4.tar.gz && \
 cp -R hadoop-2.7.4 /usr/local/hadoop-2.7.4 && \
 chown -R hadoop. /usr/local/hadoop-2.7.4 && \
 rm -rf hadoop-2.7.4.tar.gz hadoop-2.7.4
# Install Scala2.11.12
RUN wget http://downloads.typesafe.com/scala/2.11.12/scala-2.11.12.tgz && \
 tar zxvf scala-2.11.12.tgz && \
 cp -R scala-2.11.12 /usr/local/scala-2.11.12 && \
 rm -rf scala-2.11.12.tgz scala-2.11.12
# Hadoop settings
RUN echo $'<?xml version="1.0" encoding="UTF-8"?>\n\
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>\n\
<configuration>\n\
<property>\n\
<name>fs.default.name</name>\n\
<value>hdfs://localhost:9000</value>\n\
</property>\n\
</configuration>' > /usr/local/hadoop-2.7.4/etc/hadoop/core-site.xml
# hadoop user settings
RUN echo $'export SPARK_HOME=/usr/local/spark-2.2\n\
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk\n\
export PATH=$PATH:$JAVA_HOME/bin\n\
export CLASSPATH=.:$JAVA_HOME/jre/lib:$JAVA_HOME/lib:$JAVA_HOME/lib/tools.jar\n\
export HADOOP_HOME=/usr/local/hadoop\n\
export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native\n\
export HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib"\n\
export PATH=$PATH:$HADOOP_HOME/bin:$SPARK_HOME/bin:/usr/local/scala-2.11.12/bin\n\
export SPARK_LOCAL_IP=127.0.0.1' >> /home/hadoop/.bash_profile
