FROM tomcat:9-jdk11

# Remove default webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Create the ROOT directory
RUN mkdir -p /usr/local/tomcat/webapps/ROOT

# Copy your WAR file
COPY *.war /usr/local/tomcat/webapps/ROOT.war

# Create a health check file
RUN echo "OK" > /usr/local/tomcat/webapps/ROOT/health.txt

# Configure shutdown port and command
RUN sed -i 's/shutdown="SHUTDOWN"/shutdown="RENDERSHUTDOWN"/g' /usr/local/tomcat/conf/server.xml && \
    sed -i 's/port="8005"/port="-1"/g' /usr/local/tomcat/conf/server.xml

EXPOSE 8080

# Add healthcheck
HEALTHCHECK --interval=30s --timeout=3s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:8080/health.txt || exit 1

CMD ["catalina.sh", "run"]