FROM maven:3.9-eclipse-temurin-25 AS build

WORKDIR /app

COPY pom.xml .
RUN mvn dependency:go-offline

COPY src ./src
RUN mvn clean package -DskipTests

FROM tomcat:9.0-jdk25-temurin

WORKDIR /usr/local/tomcat

RUN rm -rf webapps/*

COPY --from=build /app/target/supplychain-frontend-1.0.0-LEGACY.war webapps/ROOT.war

EXPOSE 8081

CMD ["catalina.sh", "run"]
