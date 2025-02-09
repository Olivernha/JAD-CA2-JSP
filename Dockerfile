FROM tomcat:9-jdk11

# Remove default webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Create necessary directories
RUN mkdir -p /usr/local/tomcat/webapps/ROOT

# Copy WAR file
COPY *.war /usr/local/tomcat/webapps/ROOT.war

# Enable JSP compilation
RUN mkdir -p /usr/local/tomcat/work/Catalina/localhost/

# Add logging configuration
RUN echo "org.apache.jasper.servlet.level = FINE" >> /usr/local/tomcat/conf/logging.properties

# Configure Tomcat to show errors
COPY web.xml /usr/local/tomcat/conf/web.xml

EXPOSE 8080

CMD ["catalina.sh", "run"]