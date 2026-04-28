# Modernization Plan: SupplyChain Frontend — Upgrade and Azure Migration

**Project**: SupplyChain Frontend (`supplychain-frontend`)

---

## Technical Framework

- **Language**: Java 8 (target: Java 25)
- **Framework**: Spring Boot 2.7.18 / Spring Framework 5.x (target: Spring Boot 4.x / Spring Framework 7.x)
- **Build Tool**: Maven 3.x (target: Maven 3.9+)
- **Database**: None (frontend UI service, calls backend API)
- **Key Dependencies**: Spring Boot Web, Apache Tomcat Jasper (JSP), javax.servlet JSTL, Lombok, SLF4J (`@Slf4j`), `RestTemplate`

---

## Overview

This migration modernizes the SupplyChain Frontend from a legacy Java 8 / Spring Boot 2.7.18 WAR application
to a cloud-native service running on Azure Container Apps (ACA). The application currently uses end-of-life
Java 8 and Spring Boot 2.7.18, prohibited service-to-service communication patterns (`RestTemplate`),
prohibited logging libraries (SLF4J / `System.out.println`), hardcoded HTTP connection strings, and carries
known CVE vulnerabilities in its outdated dependencies. The new architecture will:

- Run on **Java 25 / Spring Boot 4.x** for long-term support, latest security patches, and modern runtime performance.
- Use the **ServiceMesh SDK** (`com.acme.mesh.ServiceMesh`) for all service-to-service communication, providing
  automatic mTLS termination, circuit breaking, distributed tracing, and canary routing per Acme Corp guardrails.
- Use **InternalLogger** (`com.acme.logging.InternalLogger`) for all logging, ensuring structured JSON output
  with trace-context injection per Acme Corp policy.
- Authenticate users via **Microsoft Entra ID (Azure AD)** with OAuth 2.0 / OIDC, replacing legacy session-based
  authentication per Acme Corp policy.
- Store all sensitive values and connection strings in **Azure Key Vault**, accessed via Spring Cloud Azure
  with Managed Identity, per Acme Corp policy.
- Deploy as a container on **Azure Container Apps (ACA)** using Java 25 distroless images per Acme Corp
  replatform strategy for all Java supply chain services.
- Pass all CVE scanning gates with no known high or critical vulnerabilities remaining.

The migration follows a phased approach: upgrade the runtime first, then transform service integrations and
guardrail violations in parallel, remediate CVE vulnerabilities, containerize with updated images, and finally
deploy to Azure Container Apps.

---

## Migration Impact Summary

| Application           | Original Service              | New Azure Service                    | Authentication    | Comments                          |
|-----------------------|-------------------------------|--------------------------------------|-------------------|-----------------------------------|
| supplychain-frontend  | Java 8 / Spring Boot 2.7.18   | Java 25 / Spring Boot 4.x            | N/A               | EOL runtime and framework         |
| supplychain-frontend  | RestTemplate (HTTP client)    | ServiceMesh SDK                      | Managed Identity  | Policy: bypasses mesh layer       |
| supplychain-frontend  | SLF4J / System.out.println    | InternalLogger                       | N/A               | Policy: no trace-context support  |
| supplychain-frontend  | Session-based authentication  | Azure AD (OAuth 2.0 / OIDC)          | OAuth 2.0 / OIDC  | Policy: all user auth via Azure AD|
| supplychain-frontend  | Hardcoded HTTP URLs in config | Azure Key Vault                      | Managed Identity  | Policy: externalize configuration |
| supplychain-frontend  | Tomcat WAR on Java 8 image    | Azure Container Apps (ACA)           | Managed Identity  | Replatform to ACA                 |

---

## Tasks

### Task 001: Upgrade Spring Boot to 4.x

Upgrade the application runtime from Java 8 / Spring Boot 2.7.18 to Java 25 / Spring Boot 4.x, including
Spring Framework 7.x migration and full Jakarta EE namespace migration (`javax.*` → `jakarta.*`). This is the
foundation task that all subsequent transform tasks depend on. It directly resolves the following mandatory
AppCAT assessment findings: `azure-java-version-02000` (Java 8 end-of-life),
`spring-boot-to-azure-spring-boot-version-01000` (Spring Boot 2.7.18 end-of-life), and
`spring-framework-version-01000` (Spring Framework end-of-life).

### Task 002: Migrate Service Communication to ServiceMesh SDK

Replace all `RestTemplate` usages with the ServiceMesh SDK (`com.acme.mesh.ServiceMesh`) across all service
classes (`BackendApiService`, `InventoryApiService`, `VendorApiService`) and the `AppConfig` bean definition,
per Acme Corp guardrails that prohibit `RestTemplate` because it bypasses the mesh layer.

### Task 003: Migrate Logging to InternalLogger

Replace all SLF4J (`@Slf4j`) annotations and `System.out.println` / `System.err.println` calls with
`InternalLogger` (`com.acme.logging.InternalLogger`) per Acme Corp policy. This also resolves the
`localhost-http-00001` and `unsecure-network-protocol-00000` AppCAT findings in
`SupplyChainFrontendApplication.java` (the `System.out.println` statement containing `http://localhost:8081`
will be removed).

### Task 004: Migrate User Authentication to Azure AD

Migrate user-facing authentication from legacy session-based authentication to Microsoft Entra ID (Azure AD)
using OAuth 2.0 / OIDC, per Acme Corp policy that requires all user-facing authentication to use Azure AD.

### Task 005: Migrate Credentials and Connection Strings to Azure Key Vault

Externalize all hardcoded connection strings and sensitive configuration values from `application.yml` and
source code to Azure Key Vault, accessed via Spring Cloud Azure with Managed Identity. This resolves the
`hardcoded-urls-00001` and `unsecure-network-protocol-00000` AppCAT findings in `application.yml`
(the hardcoded `http://backend:8080/api` URL will be moved to Key Vault).

---

## Security Compliance

**Description**: Validate and fix all CVE (Common Vulnerabilities and Exposures) issues in the project's
Maven dependencies to ensure no known security vulnerabilities remain before containerization and deployment.

**Requirements**: All CVE issues must be fixed. No high or critical CVE vulnerabilities should be present in
any dependency after remediation. All dependencies must be updated to safe versions while maintaining
compatibility with Java 25 / Spring Boot 4.x.

**Environment Configuration**: Java 25 runtime and Maven 3.9+ build tool, established by task
`001-upgrade-spring-boot-4x`.

**App Scope**: `.` (project root — single-module Maven project)

**Skills**:
- Skill Name: `validate-cves-and-fix`
  - Skill Location: `builtin`

---

## Containerization

Containerize the application for Azure Container Apps deployment using a multi-stage Docker build. The build
stage uses `mcr.microsoft.com/openjdk/jdk:25-ubuntu` and the runtime stage uses
`mcr.microsoft.com/openjdk/jdk:25-distroless` per Acme Corp target artifact requirements. The existing
`Dockerfile` at the project root will be updated accordingly.

---

## Deployment

Deploy the containerized application to Azure Container Apps (ACA) per Acme Corp's default replatform
strategy for all Java services in the supply chain system. Bicep IaC files will be generated to provision the
required ACA environment, with Managed Identity configured to grant access to Azure Key Vault and other
dependent Azure services.
