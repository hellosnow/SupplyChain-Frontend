# ── Stage 1: Build ────────────────────────────────────────────────────────────
FROM maven:3.9-eclipse-temurin-17 AS build

WORKDIR /app

# Cache dependency layer separately to speed up rebuilds
COPY pom.xml .
RUN mvn dependency:go-offline -q

COPY src ./src
RUN mvn clean package -DskipTests -q

# ── Stage 2: Runtime ──────────────────────────────────────────────────────────
FROM tomcat:10.1-jdk17-temurin

LABEL org.opencontainers.image.title="supplychain-frontend" \
      org.opencontainers.image.description="Supply Chain Management Frontend" \
      org.opencontainers.image.version="2.0.0-SNAPSHOT" \
      org.opencontainers.image.vendor="ACME Corp"

WORKDIR /usr/local/tomcat

# Remove default webapps to reduce attack surface
RUN rm -rf webapps/*

# Copy the built WAR as ROOT so it serves at /
COPY --from=build /app/target/supplychain-frontend-2.0.0-SNAPSHOT.war webapps/ROOT.war

# Create a non-root user and group, then hand ownership over
RUN groupadd --system --gid 1001 tomcatgroup && \
    useradd  --system --uid 1001 --gid tomcatgroup --no-create-home tomcatuser && \
    chown -R tomcatuser:tomcatgroup /usr/local/tomcat

USER tomcatuser

EXPOSE 8080

# Health-check: poll Spring Boot Actuator; start after 40 s, then every 30 s
HEALTHCHECK --interval=30s --timeout=5s --start-period=40s --retries=3 \
    CMD curl -f http://localhost:8080/actuator/health || exit 1

CMD ["catalina.sh", "run"]
