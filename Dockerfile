# ---------- Stage 1: Build the plugin using Maven ----------
FROM maven:3.8.8-openjdk-8-slim AS builder

# Set working directory
WORKDIR /app

# Copy the source code
COPY . .

# Use Maven to clean and build the plugin
RUN mvn clean install -DskipTests

# ---------- Stage 2: Run Jenkins with the plugin pre-installed ----------
FROM jenkins/jenkins:lts

USER root

# Create plugins directory and copy the built plugin (.hpi) from builder stage
COPY --from=builder /app/target/*.hpi /usr/share/jenkins/ref/plugins/workflow-cps-global-lib.hpi

# Optional: disable setup wizard
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false

# Make sure Jenkins plugins are owned by Jenkins user
RUN chown -R jenkins:jenkins /usr/share/jenkins/ref/plugins

USER jenkins

EXPOSE 8080

# Entry point is Jenkins by default, so no CMD needed
