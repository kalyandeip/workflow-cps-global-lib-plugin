# ---------- Stage 1: Build the plugin using Maven ----------
FROM maven:3.8.7-eclipse-temurin-8 as builder

WORKDIR /app
COPY . .

# Clean and build the Jenkins plugin
RUN mvn clean install -DskipTests

# ---------- Stage 2: Jenkins with plugin installed ----------
FROM jenkins/jenkins:lts

USER root

# Copy the built plugin into Jenkins plugin directory
COPY --from=builder /app/target/*.hpi /usr/share/jenkins/ref/plugins/workflow-cps-global-lib.hpi

# Optional: disable the setup wizard
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false

RUN chown -R jenkins:jenkins /usr/share/jenkins/ref/plugins

USER jenkins

EXPOSE 8080
