# Use an official OpenJDK runtime as a parent image
FROM openjdk:8-jdk-slim

# Copy the executable jar into the container
COPY target/demo-0.0.1-SNAPSHOT.jar app.jar

# Expose the port that the application listens on
EXPOSE 9093

# Run the jar file
ENTRYPOINT ["java", "-jar", "app.jar"]
