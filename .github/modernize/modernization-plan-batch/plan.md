# Modernization Plan: SupplyChain Frontend Azure Migration

**Project**: SupplyChain Frontend

---

## Technical Framework

- **Language**: Java 8
- **Framework**: Spring Boot 2.7.18
- **Build Tool**: Maven
- **Database**: N/A (Frontend only; calls backend REST APIs)
- **Key Dependencies**: Spring Boot Web, Embedded Tomcat,
  JSP/JSTL, Lombok

---

## Overview

This migration upgrades and modernizes the SupplyChain Frontend
application for deployment on Azure. The application currently
runs on Java 8 with Spring Boot 2.7.18 and uses several
technologies prohibited by the Acme Corp playbook. The new
architecture will:

- Upgrade the Java runtime to Java 25 and Spring Boot to 4.0+
  per Acme Corp playbook targets
- Replace prohibited technologies (RestTemplate, SLF4J,
  exception-based error handling) with approved alternatives
  (ServiceMesh SDK, InternalLogger, Result\<T\> pattern)
- Validate and fix all CVE vulnerabilities in project
  dependencies
- Containerize and deploy the application to Azure Container
  Apps (ACA) per the Acme Corp charter

The migration follows the Acme Corp Replatform strategy for
Java supply chain services targeting Azure Container Apps.

> **Note**: The assessment report at `.github/modernize/assessment`
> was not found. This plan was generated based on direct codebase
> analysis.

---

## Migration Impact Summary

| Application          | Original Service      | New Service        | Auth       | Comments           |
|----------------------|-----------------------|--------------------|------------|--------------------|
| supplychain-frontend | Java 8 / SB 2.7.18   | Java 25 / SB 4.0+ | N/A        | Playbook target    |
| supplychain-frontend | RestTemplate          | ServiceMesh SDK    | N/A        | Prohibited tech    |
| supplychain-frontend | SLF4J / System.out    | InternalLogger     | N/A        | Prohibited tech    |
| supplychain-frontend | Exception handling    | Result\<T\>        | N/A        | Prohibited pattern |
| supplychain-frontend | Tomcat WAR on VM      | Azure Container Apps | Managed ID | Charter strategy  |

---

## Upgrade Tasks

### Task 001 — Upgrade Spring Boot to 4.0+ and Java to 25

Upgrade the application from Spring Boot 2.7.18 with Java 8
to Spring Boot 4.0+ with Java 25. This includes Jakarta EE
namespace migration (javax.* → jakarta.*) and all dependency
version alignments required for Spring Boot 4.0+.

---

## Transform Tasks

### Task 002 — Migrate RestTemplate to ServiceMesh SDK

Replace all RestTemplate-based HTTP client calls with the
ServiceMesh SDK for service-to-service communication, as
mandated by the Acme Corp playbook guardrails.

### Task 003 — Migrate Logging to InternalLogger

Replace all SLF4J logging and System.out.println usage with
InternalLogger for structured logging with trace context,
as mandated by the Acme Corp playbook guardrails.

### Task 004 — Migrate Error Handling to Result\<T\> Pattern

Replace exception-based flow control with the Result\<T\>
pattern for all business logic error handling, as mandated
by the Acme Corp playbook guardrails.

---

## Security Compliance

**Description**: Validate and fix all CVE vulnerabilities in
project dependencies.

**Requirements**: All CVE issues must be fixed. Scan all
project dependencies for known vulnerabilities and remediate
them after the upgrade to Java 25 and Spring Boot 4.0+.

**Environment Configuration**: Java 25, Spring Boot 4.0+,
Maven

**App Scope**: Project root (.)

**Skills**:
  - Skill Name: validate-cves-and-fix
    - Skill Location: builtin

---

## Containerization

### Task 006 — Update Dockerfile for Azure Container Apps

Update the existing Dockerfile to use the approved container
base images (mcr.microsoft.com/openjdk/jdk:25-ubuntu for build,
mcr.microsoft.com/openjdk/jdk:25-distroless for runtime) and
adapt for Azure Container Apps deployment.

---

## Deployment

### Task 007 — Deploy to Azure Container Apps

Deploy the modernized application to Azure Container Apps,
the default compute target per the Acme Corp charter for all
Java supply chain services.
