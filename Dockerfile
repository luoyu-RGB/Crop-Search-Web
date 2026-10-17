# Build the WAR with the same Java LTS line used by the production container.
FROM maven:3.9-eclipse-temurin-21 AS build

WORKDIR /app
COPY pom.xml .
COPY src ./src
COPY data/images ./data/images

RUN mvn --no-transfer-progress clean package -DskipTests

# Run the application as the ROOT context so /health and the public URLs work
# directly from Render or Hugging Face Spaces.
FROM tomcat:10.1-jdk21-temurin

RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=build /app/target/crop-knowledge-web.war /usr/local/tomcat/webapps/ROOT.war

ENV CATALINA_OPTS="-Dfile.encoding=UTF-8"
ENV PORT=7860
EXPOSE 7860

# Hugging Face Spaces uses port 7860. Render provides PORT at runtime and this
# command updates Tomcat's connector for that port when the value is present.
CMD ["sh", "-c", "sed -i \"s/port=\\\"8080\\\"/port=\\\"${PORT:-7860}\\\"/\" \"$CATALINA_HOME/conf/server.xml\" && exec catalina.sh run"]
