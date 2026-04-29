# Modernization Plan: Upgrade and Migrate to Azure

**Project**: SupplyChain Frontend

---

## Technical Framework

- **Language**: Java 8
- **Framework**: Spring Boot 2.7.18
- **Build Tool**: Maven (managed via Spring Boot parent 2.7.18)
- **Database**: None (frontend service; backend data accessed via HTTP API)
- **Key Dependencies**: Spring MVC, JSP/JSTL, RestTemplate (HTTP client),
  SLF4J/Lombok `@Slf4j` (logging), Tomcat WAR deployment

---

## Overview

This migration upgrades and replatforms the SupplyChain Frontend service to
Azure. The application currently runs on Java 8 with Spring Boot 2.7.18 as a
WAR-packaged web application deployed on Tomcat, using RestTemplate for
backend API calls and SLF4J for logging. The new architecture will:

- Upgrade to Java 25 and Spring Boot 4.x (Spring Framework 7.x, Jakarta EE)
  to remediate end-of-life runtimes mandated by the playbook
- Replace RestTemplate with the ServiceMesh SDK (`com.acme.mesh.ServiceMesh`)
  for all service-to-service communication, enabling mTLS, circuit breaking,
  distributed tracing, and canary routing
- Replace SLF4J / `@Slf4j` with InternalLogger
  (`com.acme.logging.InternalLogger`) for trace-context-aware structured
  logging
- Externalize hardcoded credentials and configuration to Azure Key Vault,
  accessed via Managed Identity, eliminating plaintext secrets
- Containerize the application with Microsoft OpenJDK 25 base images and
  deploy to Azure Container Apps (ACA)

The migration follows a phased approach: runtime upgrade first, then
policy-required library migrations, containerization, and finally deployment
to Azure Container Apps.

---

## Migration Impact Summary

| Application          | Original Service              | New Azure Service           | Authentication    | Comments                               |
|----------------------|-------------------------------|-----------------------------|-------------------|----------------------------------------|
| SupplyChain Frontend | Java 8 / Spring Boot 2.7.18   | Java 25 / Spring Boot 4.x   | N/A               | EOL upgrade per playbook targets       |
| SupplyChain Frontend | RestTemplate (HTTP client)    | ServiceMesh SDK             | Managed Identity  | Policy-required; mesh routing & mTLS   |
| SupplyChain Frontend | SLF4J / @Slf4j (logging)      | InternalLogger              | N/A               | Policy-required; trace context logging |
| SupplyChain Frontend | Hardcoded config/credentials  | Azure Key Vault             | Managed Identity  | Policy-required; secrets management    |
| SupplyChain Frontend | Tomcat WAR (Java 8 image)     | Azure Container Apps (ACA)  | Managed Identity  | Replatform per charter strategy        |
