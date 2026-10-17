# Build the WAR with the same Java LTS line used by the production container.
FROM maven:3.9-eclipse-temurin-21 AS build

WORKDIR /app
COPY pom.xml .
COPY src ./src
COPY data/images ./data/images

RUN mvn --no-transfer-progress clean package -DskipTests

# Run the application as the ROOT context so /health and the public URLs work
# directly from the Render URL.
FROM tomcat:10.1-jdk21-temurin

RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=build /app/target/crop-knowledge-web.war /usr/local/tomcat/webapps/ROOT.war

ENV CATALINA_OPTS="-Dfile.encoding=UTF-8"
EXPOSE 8080

# Render provides PORT at runtime (normally 10000). Keep 8080 as the local
# default and update Tomcat's connector when a different port is supplied.
CMD ["sh", "-c", "sed -i \"s/port=\\\"8080\\\"/port=\\\"${PORT:-8080}\\\"/\" \"$CATALINA_HOME/conf/server.xml\" && exec catalina.sh run"]
