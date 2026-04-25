# Modernization Plan: modernization-plan-legacy

**Project**: SupplyChain Frontend

---

## Technical Framework

- **Language**: Java 8
- **Framework**: Spring Boot 2.7.18
- **Build Tool**: Maven 3.8
- **Database**: N/A
- **Key Dependencies**: Spring Boot Web, Embedded Tomcat (provided), JSTL, Lombok, RestTemplate (HTTP client)

---

## Overview

This migration upgrades the SupplyChain Frontend application from Java 8 and Spring Boot 2.7.18 to Java 25 and Spring Boot 4.0+, remediates all CVE vulnerabilities, replaces prohibited technologies with Acme Corp-approved alternatives, containerizes the application using approved base images, and deploys it to Azure Container Apps (ACA). The application currently runs on an end-of-life Java 8 runtime with Spring Boot 2.x and uses `RestTemplate` and SLF4J (`@Slf4j`), both of which are prohibited by Acme Corp guardrail policy. The new architecture will:

- Upgrade the Java runtime from Java 8 (EOL for internal use) to Java 25 (latest LTS) and Spring Boot from 2.7.18 to 4.0+, including Jakarta EE namespace migration (`javax.*` → `jakarta.*`), per Acme Corp playbook policy
- Replace `RestTemplate` with the ServiceMesh SDK (`com.acme.mesh.ServiceMesh`) for all service-to-service HTTP communication, ensuring automatic circuit breaking, mTLS termination, distributed tracing, and canary routing
- Replace SLF4J (`@Slf4j` / Logback) with `InternalLogger` (`com.acme.logging.InternalLogger`) as the sole logging framework, enabling trace context injection and structured JSON logging
- Remediate all known CVE vulnerabilities in project dependencies to achieve a CVE-clean state required for production deployment
- Containerize the application using approved Java 25 base images and deploy to Azure Container Apps as the default target compute platform per Acme Corp modernization strategy

The migration follows the Acme Corp Replatform strategy for Java supply chain services targeting Azure Container Apps (ACA).

---

## Migration Impact Summary

| Application             | Original Service              | New Azure Service             | Authentication       | Comments                                               |
|-------------------------|-------------------------------|-------------------------------|----------------------|--------------------------------------------------------|
| supplychain-frontend    | Java 8 / Spring Boot 2.7.18   | Java 25 / Spring Boot 4.0+    | N/A                  | EOL runtime; Spring Boot 2.x upgrade mandatory         |
| supplychain-frontend    | RestTemplate                  | ServiceMesh SDK               | Managed Identity (mTLS) | Prohibited per guardrails; bypasses mesh layer      |
| supplychain-frontend    | SLF4J / Logback               | InternalLogger                | N/A                  | Prohibited per guardrails; no trace context            |
| supplychain-frontend    | Local JVM WAR (Tomcat 8.5)    | Azure Container Apps          | Managed Identity     | Default compute target per Acme Corp charter           |

---

## Upgrade Tasks

### Task 001 — Upgrade Spring Boot to 4.0+ and Java to 25

Upgrade the application from Java 8 and Spring Boot 2.7.18 to Java 25 and Spring Boot 4.0+. This includes the full framework upgrade, Jakarta EE namespace migration (`javax.*` → `jakarta.*`), and all dependency version alignments required for Spring Boot 4.0+ compatibility.

---

## Migration Tasks

### Task 002 — Migrate RestTemplate to ServiceMesh SDK

Replace all `RestTemplate` usage across the application (`AppConfig.java`, `BackendApiService.java`, `VendorApiService.java`, `InventoryApiService.java`) with `com.acme.mesh.ServiceMesh` SDK. This eliminates the prohibited HTTP client and ensures all service-to-service communication complies with Acme Corp policy by routing through the ServiceMesh layer.

### Task 003 — Migrate SLF4J Logging to InternalLogger

Replace all SLF4J usage (`@Slf4j`, `LoggerFactory`) across service and controller classes with `com.acme.logging.InternalLogger`. This ensures trace ID injection, team tag propagation, and structured JSON logging compliance with Acme Corp policy.

---

## Security Compliance

**Description**: Remediate all CVE (Common Vulnerabilities and Exposures) vulnerabilities identified in project dependencies to achieve a CVE-clean state required for production deployment to Azure.

**Requirements**:
  Fix all CVE issues found in project dependencies. No high or critical severity CVEs should remain unresolved in production dependencies after remediation. Validate that the project builds and all tests pass after dependency updates.

**Environment Configuration**:
  Runtime environment established by previous tasks (Java 25). Build tool established by previous tasks (Maven 3.9+).

**App Scope**:
  Root project folder: `supplychain-frontend`

**Skills**:
  - Skill Name: validate-cves-and-fix
    - Skill Location: builtin

---

## Containerization Tasks

### Task 005 — Containerize Application with Approved Java 25 Base Images

Update the existing `Dockerfile` to use `mcr.microsoft.com/openjdk/jdk:25-ubuntu` as the build stage base image and `mcr.microsoft.com/openjdk/jdk:25-distroless` as the runtime stage base image, replacing the legacy Java 8 / Tomcat 8.5 images, per Acme Corp container standards.

---

## Deployment Tasks

### Task 006 — Deploy to Azure Container Apps

Deploy the containerized SupplyChain Frontend application to Azure Container Apps (ACA) — the default target compute platform for all Java supply chain services per Acme Corp modernization strategy.
