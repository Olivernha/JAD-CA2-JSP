# Use Tomcat base image
FROM tomcat:9-jdk11

# Remove default Tomcat applications
RUN rm -rf /usr/local/tomcat/webapps/*

# Create directory for your application
WORKDIR /usr/local/tomcat/webapps

# Copy your WAR file into webapps directory
# Note: Replace your-app.war with your actual WAR file name
COPY target/CA1.war webapps/ROOT.war

# Expose port 8080
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]