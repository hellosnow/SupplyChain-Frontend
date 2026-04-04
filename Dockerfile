# TECH DEBT: Uses old Java 8 base image
FROM maven:3.8-openjdk-8 AS build

WORKDIR /app

COPY pom.xml .
RUN mvn dependency:go-offline

COPY src ./src
RUN mvn clean package -DskipTests

FROM tomcat:8.5-jdk8

WORKDIR /usr/local/tomcat

RUN rm -rf webapps/*

COPY --from=build /app/target/supplychain-frontend-1.0.0-LEGACY.war webapps/ROOT.war

EXPOSE 8081

CMD ["catalina.sh", "run"]
