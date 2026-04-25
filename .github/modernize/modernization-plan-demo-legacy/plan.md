# Modernization Plan: Upgrade, Azure Migration, and CVE Remediation

**Project**: SupplyChain Frontend

---

## Technical Framework

- **Language**: Java 8
- **Framework**: Spring Boot 2.7.18
- **Build Tool**: Maven
- **Database**: N/A
- **Key Dependencies**: Spring Boot Web, RestTemplate, Embedded Tomcat (provided),
  JSTL, Lombok, SLF4J (via @Slf4j)

---

## Overview

This migration upgrades and modernizes the SupplyChain Frontend application for
Azure deployment. The application currently runs on Java 8 with Spring Boot 2.7.18,
uses RestTemplate for backend communication (prohibited by Acme Corp policy), and
relies on SLF4J/@Slf4j and System.out.println for logging (also prohibited by
Acme Corp policy). The new architecture will:

- Upgrade the Java runtime from Java 8 (end-of-life for internal use) to Java 25
  and Spring Boot from 2.7.18 to 4.0+, as mandated by the Acme Corp Modernization
  Playbook for all Java supply chain services
- Replace RestTemplate with the ServiceMesh SDK (`com.acme.mesh.ServiceMesh`) for
  all service-to-service communication, providing automatic circuit breaking,
  mTLS termination, distributed tracing, and canary routing
- Replace SLF4J (@Slf4j) and System.out.println with InternalLogger
  (`com.acme.logging.InternalLogger`) to enable trace context injection and
  structured JSON logging required for cloud observability
- Remediate all CVE vulnerabilities in project dependencies to satisfy Acme Corp
  security and compliance requirements
- Containerize the application using Java 25 base images and deploy to Azure
  Container Apps (ACA), the default compute platform per Acme Corp policy

The migration follows the Acme Corp Modernization Playbook Replatform strategy for
Java supply chain services targeting Azure Container Apps.

---

## Migration Impact Summary

| Application          | Original Service            | New Azure Service           | Authentication   | Comments                                           |
|----------------------|-----------------------------|-----------------------------|------------------|----------------------------------------------------|
| supplychain-frontend | Java 8 / Spring Boot 2.7.18 | Java 25 / Spring Boot 4.0+  | N/A              | Upgrade runtime per Acme Corp playbook policy      |
| supplychain-frontend | RestTemplate (HTTP calls)   | ServiceMesh SDK             | Managed Identity | Replace prohibited HTTP client with mesh SDK       |
| supplychain-frontend | SLF4J / System.out.println  | InternalLogger              | N/A              | Replace prohibited logging with InternalLogger     |
| supplychain-frontend | Maven dependencies (CVEs)   | Patched dependencies        | N/A              | Remediate all CVE vulnerabilities                  |
| supplychain-frontend | Docker (Java 8 / Tomcat)    | Azure Container Apps (ACA)  | Managed Identity | Containerize with Java 25 images, deploy to ACA    |

---

## Upgrade Tasks

### Task 001 — Upgrade Spring Boot to 4.0+ and Java to 25

Upgrade the application from Java 8 and Spring Boot 2.7.18 to Java 25 and Spring
Boot 4.0+. This covers the full framework upgrade including Jakarta EE namespace
migration (`javax.*` → `jakarta.*`) and all dependency version alignments required
for Spring Boot 4.0+ and Java 25 compatibility.

---

## Migration Tasks

### Task 002 — Migrate Logging to InternalLogger

Replace all SLF4J (`@Slf4j`, `LoggerFactory`) usage and `System.out.println` /
`System.err.println` calls with `com.acme.logging.InternalLogger`. InternalLogger
is the mandatory logging framework per Acme Corp policy, providing trace context
injection, structured JSON output, and team tag integration required for cloud
observability.

### Task 003 — Replace RestTemplate with ServiceMesh SDK

Replace all `RestTemplate` usage across the application (AppConfig,
BackendApiService, InventoryApiService, VendorApiService) with the ServiceMesh SDK
(`com.acme.mesh.ServiceMesh`). RestTemplate is prohibited by Acme Corp policy as it
bypasses the service mesh layer. All service-to-service communication must go
through the ServiceMesh SDK.

---

## Security Compliance

**Description**: Scan and remediate all CVE vulnerabilities in Maven project
dependencies.

**Requirements**: Scan all Maven dependencies for known CVEs and upgrade or replace
affected packages to resolve all critical and high severity vulnerabilities,
ensuring the project is CVE-clean per Acme Corp security and compliance
requirements (SOC 2).

**App Scope**: Root project at repository root (pom.xml).

**Skills**:
- Skill Name: validate-cves-and-fix
  - Skill Location: builtin

---

## Containerization

### Task 005 — Update Dockerfile for Java 25 and Azure Container Apps

Update the existing Dockerfile to use `mcr.microsoft.com/openjdk/jdk:25-ubuntu`
as the build stage image and `mcr.microsoft.com/openjdk/jdk:25-distroless` as the
runtime stage image, replacing the current Java 8 / Tomcat 8.5 base images.

---

## Deployment

### Task 006 — Deploy to Azure Container Apps

Deploy the containerized SupplyChain Frontend application to Azure Container Apps
(ACA), the default compute platform per Acme Corp policy. The deployment uses
Managed Identity for secure, passwordless service-to-service authentication.
