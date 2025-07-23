# Stage 1: Build plugin
FROM maven:3.8.7-eclipse-temurin-8 AS builder
WORKDIR /app
COPY . .
RUN mvn clean install -DskipTests

# Stage 2: Run Jenkins with plugin installed
FROM jenkins/jenkins:lts
USER root
COPY --from=builder /app/target/*.hpi /usr/share/jenkins/ref/plugins/
RUN chown -R jenkins:jenkins /usr/share/jenkins/ref/plugins
USER jenkins
EXPOSE 8080
