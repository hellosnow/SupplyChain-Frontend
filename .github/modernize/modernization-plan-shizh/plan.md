# Modernization Plan: SupplyChain Frontend Upgrade and Azure Migration

**Project**: supplychain-frontend

---

## Technical Framework

- **Language**: Java 8
- **Framework**: Spring Boot 2.7.18 (Spring Framework 5.x)
- **Build Tool**: Maven 3
- **Database**: N/A (frontend service)
- **Key Dependencies**: Spring Web MVC, RestTemplate, SLF4J / Lombok (@Slf4j),
  javax.servlet JSTL, Tomcat Jasper (JSP)

---

## Overview

> This migration upgrades the Supply Chain Frontend service from its legacy Java 8 /
> Spring Boot 2.7.18 stack to Java 25 / Spring Boot 4.x and deploys it to Azure
> Container Apps (ACA). The application currently runs as a WAR deployed to an
> embedded Tomcat with JSP views, uses RestTemplate for back-end API calls, SLF4J
> for logging, and contains hardcoded HTTP URLs in both source code and configuration.
>
> The new architecture will:
>
> - Run on Java 25 with Spring Boot 4.x and Spring Framework 7.x (Jakarta EE
>   namespace) to eliminate all EOL framework and JDK issues identified in the
>   AppCAT assessment report.
> - Replace RestTemplate with the internal ServiceMesh SDK
>   (`com.acme.mesh.ServiceMesh`) to comply with the Acme Corp guardrail requiring
>   all service-to-service calls to pass through the mesh layer.
> - Replace SLF4J / `System.out.println` with InternalLogger
>   (`com.acme.logging.InternalLogger`) to provide trace-ID injection and structured
>   JSON logging as mandated by policy.
> - Store the hardcoded backend API URL (and any other sensitive values) in Azure
>   Key Vault and retrieve them via the Spring Cloud Azure Key Vault starter with
>   Managed Identity authentication.
> - Remediate all CVE vulnerabilities in project dependencies.
> - Be containerised with a multi-stage Dockerfile using the approved Microsoft
>   OpenJDK 25 base images and deployed to Azure Container Apps.
>
> The migration follows a phased approach: framework upgrade → code modernisation
> → security hardening → containerisation → deployment.

---

## Migration Impact Summary

| Application           | Original Service                        | New Azure Service                  | Authentication   | Comments                                         |
|-----------------------|-----------------------------------------|------------------------------------|------------------|--------------------------------------------------|
| supplychain-frontend  | Spring Boot 2.7.18 / Java 8             | Spring Boot 4.x / Java 25          | N/A              | Mandatory: EOL framework (AppCAT rules)          |
| supplychain-frontend  | RestTemplate (direct HTTP)              | ServiceMesh SDK                    | Managed Identity | Policy guardrail: must route through mesh        |
| supplychain-frontend  | SLF4J / `System.out.println`            | InternalLogger                     | N/A              | Policy guardrail: trace-ID and structured logs   |
| supplychain-frontend  | Hardcoded `http://backend:8080/api` URL | Azure Key Vault                    | Managed Identity | Policy: secrets/config must not be hard-coded    |
| supplychain-frontend  | Local WAR deployment                    | Azure Container Apps               | Managed Identity | Charter default: replatform all services to ACA  |

---

## Tasks

### 1. Upgrade Spring Boot to 4.x (Java 25)

Upgrade the application from Spring Boot 2.7.18 / Java 8 to Spring Boot 4.x / Java 25,
including the Spring Framework 7.x upgrade and the `javax.*` → `jakarta.*` namespace
migration. This resolves all `mandatory` assessment findings for legacy Java version
(`azure-java-version-02000`) and Spring Boot/Framework EOL
(`spring-boot-to-azure-spring-boot-version-01000`, `spring-framework-version-01000`).

### 2. Migrate RestTemplate to ServiceMesh SDK

Replace all `RestTemplate` usage in service classes and the `AppConfig` bean with the
internal `ServiceMesh SDK` (`com.acme.mesh.ServiceMesh`). This satisfies the Acme Corp
guardrail that prohibits direct HTTP clients that bypass the mesh layer.

### 3. Migrate Logging to InternalLogger

Replace all SLF4J (`@Slf4j`, `LoggerFactory`) and `System.out.println` /
`System.err.println` usage with `InternalLogger` (`com.acme.logging.InternalLogger`).
This satisfies the Acme Corp guardrail that requires all logging to use the internal
framework for trace context and structured JSON output.

### 4. Migrate Hardcoded Credentials to Azure Key Vault

Migrate the hardcoded backend API URL (`http://backend:8080/api`) and any other
sensitive configuration values from `application.yml` and source code to Azure Key Vault.
Configure the Spring Cloud Azure Key Vault starter with Managed Identity for
credential-free access.

### 5. Security Compliance — CVE Remediation

Scan all project dependencies for known CVE vulnerabilities and upgrade or replace
any affected packages. All CVEs must be resolved before containerisation.

---

## Security Compliance

**Description**: Remediate all CVE vulnerabilities found in project dependencies to
ensure the application meets security requirements before deployment to Azure.

**Requirements**:
All CVE issues in project dependencies must be fixed. No known vulnerabilities with
Critical or High severity are permitted in the final build.

**Environment Configuration**:
Java 25 and Maven 3.9+ established by the Spring Boot 4.x upgrade task.

**App Scope**:
`.` (repository root — single-module Maven project)

**Skills**:
- Skill Name: validate-cves-and-fix
  - Skill Location: builtin

---

## Containerisation

Create a multi-stage Dockerfile for the upgraded application using the approved
Microsoft OpenJDK 25 base images:

- **Build stage**: `mcr.microsoft.com/openjdk/jdk:25-ubuntu`
- **Runtime stage**: `mcr.microsoft.com/openjdk/jdk:25-distroless`

The container must expose port `8081` and run as a non-root user.

---

## Deployment

Deploy the containerised application to Azure Container Apps (ACA) as a new service,
using Bicep IaC. Service-to-service authentication must use Managed Identity.

---

*Generated by Acme Corp Modernization Playbook — plan name: modernization-plan-shizh*
