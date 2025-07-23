# Start from Jenkins LTS (controller compatible)
FROM jenkins/jenkins:lts

# Switch to root to install required tools
USER root

# Install Maven and clean up apt cache
RUN apt-get update \
    && apt-get install -y maven \
    && rm -rf /var/lib/apt/lists/*

# Expose Maven and JDK on PATH
ENV MAVEN_HOME=/usr/share/maven \
    JAVA_HOME=/usr/local/openjdk-17 \
    PATH=$MAVEN_HOME/bin:$JAVA_HOME/bin:$PATH

# Drop back to the non-root Jenkins user
USER jenkins
