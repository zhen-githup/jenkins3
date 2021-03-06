FROM centos:latest
MAINTAINER linzhen "13760224840@163.com"



#安装JDK
ADD ./file/jdk-7u21-linux-x64.rpm /usr/local/
RUN rpm -ivh /usr/local/jdk-7u21-linux-x64.rpm
#RUN yum install maven  -y 
#RUN apt-get update
#RUN sudo add-apt-repository ppa:openjdk-r/ppa 
RUN yum install -y wget


#安装tomcat
RUN mkdir /var/tmp/tomcat
COPY ./file/apache-tomcat-7.0.85.tar.gz /var/tmp/tomcat
#RUN wget -P /var/tmp/tomcat http://mirrors.noc.im/apache/tomcat/tomcat-8/v8.0.33/bin/apache-tomcat-8.0.33.tar.gz
RUN tar xzf /var/tmp/tomcat/apache-tomcat-7.0.85.tar.gz -C /var/tmp/tomcat
RUN rm -rf /var/tmp/tomcat/apache-tomcat-7.0.85.tar.gz

#安装maven
RUN mkdir /var/tmp/maven
#RUN wget -P /var/tmp/maven http://mirrors.cnnic.cn/apache/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz
COPY ./file/apache-maven-3.3.3-bin.tar.gz /var/tmp/maven 
RUN tar xzf /var/tmp/maven/apache-maven-3.3.3-bin.tar.gz -C /var/tmp/maven
RUN rm -rf /var/tmp/maven/apache-maven-3.3.3-bin.tar.gz
#设置maven环境变量
#RUN mv /usr/lib/jvm/java* /usr/lib/jvm/java
#ENV JAVA_HOME=/usr/lib/jvm/java-1.7.0-openjdk-1.7.0.211-2.6.17.1.el7_6.x86_64/jre
ENV JAVA_HOME=/usr/java/jdk1.7.0_21
ENV MAVEN_HOME=/var/tmp/maven/apache-maven-3.3.3
ENV PATH=$JAVA_HOME:$MAVEN_HOME/bin:$PATH
RUN mkdir /var/tmp/webapp
ADD ./ /var/tmp/webapp
RUN cd /var/tmp/webapp && mvn package && cp /var/tmp/webapp/target/CIJD.war /var/tmp/tomcat/apache-tomcat-7.0.85/webapps

EXPOSE 8080

CMD ["./var/tmp/tomcat/apache-tomcat-7.0.85/bin/catalina.sh","run"]
