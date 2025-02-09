FROM tomcat:9-jdk11

# Remove default webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Create the ROOT directory
RUN mkdir -p /usr/local/tomcat/webapps/ROOT

# Copy your WAR file - make sure your WAR file is in the same folder as this Dockerfile
COPY *.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD ["catalina.sh", "run"]