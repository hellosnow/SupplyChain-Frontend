# Modernization Plan: SupplyChain Frontend — Azure Migration

**Project**: SupplyChain Frontend

---

## Technical Framework

- **Language**: Java 8
- **Framework**: Spring Boot 2.7.18
- **Build Tool**: Maven 3.8
- **Database**: N/A
- **Key Dependencies**: Spring Boot Web, Embedded Tomcat (provided), JSTL, Lombok, RestTemplate, SLF4J (via Lombok `@Slf4j`)

---

## Overview

This migration upgrades and modernizes the SupplyChain Frontend application from Java 8 / Spring Boot 2.7.18 to Java 25 / Spring Boot 4.x, migrates all prohibited technology usage to approved alternatives, remediates CVE vulnerabilities, containerizes the application with production-grade base images, and deploys it to Azure Container Apps. The application currently:

- Runs on end-of-life Java 8 and Spring Boot 2.x (both prohibited by Acme Corp policy)
- Uses `RestTemplate` for service-to-service calls (bypasses mesh layer, violates guardrails)
- Uses SLF4J / `@Slf4j` for logging (no trace context, violates guardrails)
- Uses `System.out.println` in the application entry point (violates guardrails)
- Contains a legacy Dockerfile built on `maven:3.8-openjdk-8` and `tomcat:8.5-jdk8`

The new architecture will:

- Upgrade the runtime to Java 25 and Spring Boot 4.x per Acme Corp targets, including full Jakarta EE namespace migration (`javax.*` → `jakarta.*`)
- Replace all `RestTemplate` / direct HTTP client usage with the `ServiceMesh SDK` (`com.acme.mesh.ServiceMesh`) for compliant, mesh-aware service-to-service communication
- Replace all SLF4J / `System.out.println` logging with `InternalLogger` (`com.acme.logging.InternalLogger`) for trace-context-aware structured logging
- Scan all project dependencies for CVE vulnerabilities and upgrade affected packages to non-vulnerable versions
- Rebuild the container image using the approved base images (`mcr.microsoft.com/openjdk/jdk:25-ubuntu` for build, `mcr.microsoft.com/openjdk/jdk:25-distroless` for runtime)
- Deploy to Azure Container Apps (ACA) using Bicep, the default compute target for all Java supply chain services

The migration follows the Acme Corp Replatform strategy for Java supply chain services targeting Azure Container Apps.

---

## Migration Impact Summary

| Application           | Original Service                        | New Azure Service                  | Authentication     | Comments                                                        |
|-----------------------|-----------------------------------------|------------------------------------|--------------------|-----------------------------------------------------------------|
| supplychain-frontend  | Java 8 / Spring Boot 2.7.18             | Java 25 / Spring Boot 4.x          | N/A                | Upgrade runtime per Acme Corp targets; includes javax→jakarta   |
| supplychain-frontend  | RestTemplate (direct HTTP)              | ServiceMesh SDK (com.acme.mesh)    | Managed Identity   | Required per guardrail: RestTemplate is prohibited              |
| supplychain-frontend  | SLF4J / `@Slf4j` / `System.out.println`| InternalLogger (com.acme.logging)  | N/A                | Required per guardrail: SLF4J is prohibited                     |
| supplychain-frontend  | CVE-affected dependencies               | Patched dependency versions        | N/A                | Fix all CVE vulnerabilities found in project dependencies       |
| supplychain-frontend  | Tomcat 8.5 + Java 8 container           | Azure Container Apps (ACA)         | Managed Identity   | Replatform to ACA per Acme Corp modernization strategy          |

---

## Upgrade Tasks

### Task 001 — Upgrade Spring Boot to 4.x and Java to 25

Upgrade the application from Java 8 / Spring Boot 2.7.18 to Java 25 / Spring Boot 4.x. This task covers the full framework upgrade including Jakarta EE namespace migration (`javax.*` → `jakarta.*`) and all dependency version alignments required for Spring Boot 4.x and Java 25 compatibility.

---

## Transform Tasks

### Task 002 — Migrate RestTemplate to ServiceMesh SDK

Replace all `RestTemplate` usages (and the `RestTemplate` Spring bean in `AppConfig`) across `BackendApiService`, `InventoryApiService`, and `VendorApiService` with the internal `ServiceMesh SDK` (`com.acme.mesh.ServiceMesh`). This is required by Acme Corp guardrails: `RestTemplate` bypasses the mesh layer and is a prohibited technology.

### Task 003 — Migrate SLF4J and System.out.println to InternalLogger

Replace all SLF4J / Lombok `@Slf4j` logging and all `System.out.println` / `System.err.println` usages with `InternalLogger` (`com.acme.logging.InternalLogger`). This is required by Acme Corp guardrails: SLF4J has no trace context integration and is a prohibited technology.

---

## Security Compliance

**Description**: Scan all project dependencies for known CVE vulnerabilities and upgrade or replace affected packages to achieve a CVE-clean dependency tree.

**Requirements**: Detect and fix all CVE issues in the project's Maven dependencies. Upgrade vulnerable dependencies to the latest non-vulnerable versions. Ensure the project builds and tests pass after remediation.

**Environment Configuration**: Java 25 runtime and Maven 3.9+ build tool established by Task 001.

**App Scope**: `/` (project root — `pom.xml` and all transitive dependencies)

**Skills**:
- Skill Name: validate-cves-and-fix
  - Skill Location: builtin

---

## Containerization

### Task 005 — Update Dockerfile with Production-Grade Base Images

Update the existing `Dockerfile` to use the approved multi-stage build images:
- Build stage: `mcr.microsoft.com/openjdk/jdk:25-ubuntu`
- Runtime stage: `mcr.microsoft.com/openjdk/jdk:25-distroless`

Remove the legacy `maven:3.8-openjdk-8` build image and `tomcat:8.5-jdk8` runtime image. Align the build to produce a runnable JAR (Spring Boot embedded server) rather than a WAR deployed to external Tomcat, consistent with Spring Boot 4.x best practices.

---

## Deployment

### Task 006 — Deploy to Azure Container Apps

Generate Bicep infrastructure-as-code files and deploy the containerized application to Azure Container Apps (ACA). This is the default compute target for all Java supply chain services per the Acme Corp modernization strategy.
