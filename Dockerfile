FROM mcr.microsoft.com/openjdk/jdk:25-ubuntu AS build

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends maven && rm -rf /var/lib/apt/lists/*

COPY pom.xml .
RUN mvn -B dependency:go-offline

COPY src ./src
RUN mvn -B clean package -DskipTests

FROM mcr.microsoft.com/openjdk/jdk:25-distroless

WORKDIR /app
COPY --from=build /app/target/supplychain-frontend-1.0.0-LEGACY.war /app/app.war

EXPOSE 8081

ENTRYPOINT ["java", "-jar", "/app/app.war"]
