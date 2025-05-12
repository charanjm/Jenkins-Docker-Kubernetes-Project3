FROM tomcat:10.1-jdk17

RUN mkdir /usr/local/tomcat/webapps/myapp

COPY kubernetes/target/kubernetes-1.0-AMIT.war /usr/local/tomcat/webapps/kubernetes-1.0-AMIT.war
