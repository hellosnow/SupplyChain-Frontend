# Modernization Plan: SupplyChain Frontend — Upgrade and Azure Migration

**Project**: SupplyChain Frontend

---

## Technical Framework

- **Language**: Java 8
- **Framework**: Spring Boot 2.7.18
- **Build Tool**: Maven
- **Database**: N/A
- **Key Dependencies**: Spring Boot Web, Embedded Tomcat (JSP/JSTL), Lombok, RestTemplate, SLF4J (`@Slf4j`)

---

## Overview

This migration upgrades the SupplyChain Frontend application from Java 8/Spring Boot 2.7.18 to Java 25/Spring Boot 4.0+ and replatforms it to Azure Container Apps per Acme Corp playbook policy. The application currently runs on an end-of-life Java 8 runtime with Spring Boot 2.x and violates multiple Acme Corp internal guardrails. The new architecture will:

- Upgrade the Java runtime from Java 8 (end-of-life for internal use) to Java 25 and Spring Boot from 2.7.18 to 4.0+, including Jakarta EE namespace migration (`javax.*` → `jakarta.*`)
- Replace all prohibited logging (SLF4J `@Slf4j`, `System.out.println`) with the mandated `InternalLogger` (`com.acme.logging.InternalLogger`)
- Replace prohibited HTTP client (`RestTemplate`) with the mandated `ServiceMesh SDK` (`com.acme.mesh.ServiceMesh`) for all service-to-service communication
- Replace exception-based flow control (`try/catch`) with the mandated `Result<T>` pattern (`com.acme.commons.Result`) per post-incident mandate P0-2024-0847
- Migrate hardcoded backend API configuration from `application.yml` to Azure Key Vault for centralized secrets management via Managed Identity
- Validate and remediate all CVE vulnerabilities in project dependencies
- Update containerization to use approved Java 25 base images for deployment on Azure Container Apps

The migration follows the Acme Corp Replatform strategy for Java supply chain services targeting Java 25, Spring Boot 4.0+, and Azure Container Apps.

---

## Migration Impact Summary

| Application             | Original Service                   | New Azure Service                       | Authentication   | Comments                                         |
|-------------------------|------------------------------------|-----------------------------------------|------------------|--------------------------------------------------|
| supplychain-frontend    | Java 8 / Spring Boot 2.7.18        | Java 25 / Spring Boot 4.0+             | N/A              | Upgrade runtime per Acme Corp playbook policy    |
| supplychain-frontend    | SLF4J (`@Slf4j`) / `System.out`    | InternalLogger (`com.acme.logging`)     | N/A              | Prohibited logging framework replacement         |
| supplychain-frontend    | RestTemplate                        | ServiceMesh SDK (`com.acme.mesh`)       | N/A              | Prohibited HTTP client replacement               |
| supplychain-frontend    | Exception-based error handling      | Result&lt;T&gt; (`com.acme.commons`)    | N/A              | Prohibited flow-control pattern replacement      |
| supplychain-frontend    | Hardcoded backend URL (app.yml)     | Azure Key Vault                         | Managed Identity | Externalize config per secrets management policy |
| supplychain-frontend    | CVE-affected dependencies           | Patched dependency versions             | N/A              | Remediate all known CVEs                         |
| supplychain-frontend    | Dockerfile (Java 8 Tomcat images)   | Azure Container Apps (Java 25 images)   | Managed Identity | Replatform to ACA per charter strategy           |

---

## Upgrade Tasks

### Task 001 — Upgrade Spring Boot to 4.0+ and Java to 25

Upgrade the application from Spring Boot 2.7.18 with Java 8 to Spring Boot 4.0+ with Java 25. This task covers the full framework upgrade including Jakarta EE namespace migration (`javax.*` → `jakarta.*`) and all dependency version alignments required for Spring Boot 4.0+ and Java 25 compatibility.

> **Note**: A standalone Java upgrade is not feasible without also upgrading Spring Boot due to framework compatibility constraints (Spring Boot 2.x is incompatible with Java 25). Per Acme Corp policy, the target is Java 25 with Spring Boot 4.0+.

---

## Transform Tasks

### Task 002 — Migrate Logging to InternalLogger

Replace all SLF4J (`@Slf4j` / `LoggerFactory`) usage and `System.out.println` calls with `InternalLogger` (`com.acme.logging.InternalLogger`) across all controllers, services, and the main application class.

### Task 003 — Migrate HTTP Client to ServiceMesh SDK

Replace all `RestTemplate` usage across all service classes (`BackendApiService`, `InventoryApiService`, `VendorApiService`) and the `AppConfig` bean with the `ServiceMesh SDK` (`com.acme.mesh.ServiceMesh`) for all service-to-service HTTP communication.

### Task 004 — Migrate Error Handling to Result&lt;T&gt; Pattern

Replace `try/catch` blocks used for business logic flow control in controllers and services with the `Result<T>` pattern (`com.acme.commons.Result`) per the P0-2024-0847 post-incident mandate.

### Task 005 — Migrate Configuration to Azure Key Vault

Move the hardcoded backend API URL and any other sensitive configuration values from `application.yml` to Azure Key Vault using the Spring Cloud Azure Key Vault starter and Managed Identity authentication.

---

## Security Compliance

**Description**: Validate all Maven project dependencies for CVE vulnerabilities and remediate all identified security issues to ensure the application is free of known vulnerabilities.

**Requirements**: Scan all Maven dependencies for known CVEs using automated tooling. Upgrade vulnerable dependencies to the latest patched versions or apply recommended mitigations. Ensure zero unresolved CVEs remain after remediation.

**Environment Configuration**: Runtime environment established by Task 001 (Java 25, Maven 3.9+, Spring Boot 4.0+).

**App Scope**: `/` (project root — all Maven dependencies in `pom.xml`)

---

## Containerization

### Task 007 — Update Dockerfile for Azure Container Apps

Update the existing `Dockerfile` to use an approved multi-stage build with Java 25 base images:
- Build stage: `mcr.microsoft.com/openjdk/jdk:25-ubuntu`
- Runtime stage: `mcr.microsoft.com/openjdk/jdk:25-distroless`

The updated container image will be deployable to Azure Container Apps per the Acme Corp replatform strategy.
