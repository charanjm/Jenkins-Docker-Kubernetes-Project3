FROM tomcat:9.0.73-jdk11

RUN mkdir /usr/local/tomcat/webapps/myapp

COPY kubernetes/target/kubernetes-1.0-CHARAN.war /usr/local/tomcat/webapps/kubernetes-1.0-AMIT.war
