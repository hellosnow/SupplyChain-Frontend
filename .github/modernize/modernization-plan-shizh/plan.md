# Modernization Plan: modernization-plan-shizh

**Project**: SupplyChain Frontend

---

## Technical Framework

- **Language**: Java 8
- **Framework**: Spring Boot 2.7.18, Spring Framework 5.x
- **Build Tool**: Maven
- **Database**: N/A (frontend service — delegates to backend API)
- **Key Dependencies**: Spring Boot Web, Lombok, RestTemplate (SLF4J via Lombok @Slf4j), JSP/JSTL

---

## Overview

> This migration modernizes the SupplyChain Frontend service from a legacy Spring Boot 2.7.18 / Java 8 WAR application to a cloud-native Spring Boot 4.0+ / Java 25 containerized service deployed on Azure Container Apps (ACA). The application currently uses RestTemplate for backend API calls, SLF4J for logging, session-based authentication, and has hardcoded configuration values. The new architecture will:
>
> - Upgrade the runtime to Java 25 and Spring Boot 4.0+ to eliminate end-of-OSS-support risks and security vulnerabilities
> - Replace all service-to-service HTTP calls (RestTemplate) with the ServiceMesh SDK to enforce mTLS, circuit breaking, and distributed tracing per playbook guardrails
> - Replace SLF4J / System.out.println logging with InternalLogger for structured trace-context-aware logging
> - Migrate user-facing authentication from session-based to Azure AD (OAuth 2.0 / OIDC)
> - Externalize all sensitive configuration to Azure Key Vault accessed via Managed Identity
> - Fix all known CVE vulnerabilities in third-party dependencies
> - Containerize the service using approved Microsoft OpenJDK base images and deploy to Azure Container Apps
>
> The migration follows a phased approach: framework upgrade first, then playbook-mandated code transforms, then security remediation, and finally containerization and deployment.

---

## Migration Impact Summary

```
| Application             | Original Service          | New Azure Service              | Authentication        | Comments                                      |
|-------------------------|---------------------------|--------------------------------|-----------------------|-----------------------------------------------|
| supplychain-frontend    | Spring Boot 2.7.18/Java 8 | Spring Boot 4.0+ / Java 25     | N/A                   | Framework & runtime upgrade per playbook      |
| supplychain-frontend    | RestTemplate              | ServiceMesh SDK                | Managed Identity      | Guardrail: all HTTP calls via ServiceMesh     |
| supplychain-frontend    | SLF4J / System.out        | InternalLogger                 | N/A                   | Guardrail: structured logging with trace IDs  |
| supplychain-frontend    | Session-based auth        | Azure AD (OAuth 2.0 / OIDC)    | OAuth 2.0 / OIDC      | Policy: all user auth via Azure AD            |
| supplychain-frontend    | Hardcoded config/secrets  | Azure Key Vault                | Managed Identity      | Policy: no plaintext secrets in config files  |
| supplychain-frontend    | Local WAR deployment      | Azure Container Apps           | Managed Identity      | Strategy: Replatform to ACA per playbook      |
```

---

## Migration Tasks

### Task 1 — Upgrade Spring Boot and Java Runtime

Upgrade the application from Spring Boot 2.7.18 / Java 8 to Spring Boot 4.0+ / Java 25 as mandated by the playbook (targets.md). This includes migrating `javax.*` namespaces to `jakarta.*`, updating deprecated APIs, and resolving any compatibility issues introduced by the major version jump.

**Driven by**: AppCAT findings (`spring-boot-to-azure-spring-boot-version-01000`, `spring-framework-version-01000`, `azure-java-version-02000`) and playbook targets (Java 25, Spring Boot 4.0+).

---

### Task 2 — Migrate RestTemplate to ServiceMesh SDK

Replace all `RestTemplate` usages in `AppConfig`, `BackendApiService`, `VendorApiService`, and `InventoryApiService` with `com.acme.mesh.ServiceMesh` (the internal ServiceMesh SDK). This enforces automatic circuit breaking, mTLS termination, distributed tracing, and canary routing for all service-to-service communication.

**Driven by**: Playbook guardrail prohibiting RestTemplate.

---

### Task 3 — Migrate SLF4J / System.out to InternalLogger

Replace all `@Slf4j` / `LoggerFactory` usages and `System.out.println` calls with `com.acme.logging.InternalLogger`. InternalLogger injects trace IDs, team tags, and structured JSON output required for observability compliance.

**Driven by**: Playbook guardrail prohibiting SLF4J and System.out.println. Also addresses AppCAT findings for localhost HTTP references in System.out.println.

---

### Task 4 — Migrate Authentication to Azure AD (OAuth 2.0 / OIDC)

Migrate user-facing authentication from session-based authentication to Azure AD using OAuth 2.0 / OIDC. All user authentication must use Azure AD per playbook security policy.

**Driven by**: Playbook security policy (policies.md) requiring Azure AD for all user-facing authentication.

---

### Task 5 — Externalize Credentials and Config to Azure Key Vault

Migrate hardcoded configuration values (including the backend API URL) from `application.yml` and source code to Azure Key Vault, accessed via Managed Identity using the Spring Cloud Azure Key Vault starter.

**Driven by**: Playbook security policy (policies.md) prohibiting hardcoded credentials and requiring Azure Key Vault. Also addresses AppCAT findings (`hardcoded-urls-00001`, `unsecure-network-protocol-00000`).

---

### Task 6 — Security: Fix CVE Vulnerabilities

Scan all third-party dependencies for known CVE vulnerabilities and apply fixes (version upgrades or removals) to achieve a CVE-clean dependency tree.

**Driven by**: User requirement ("make sure all CVE issues are fixed").

---

### Task 7 — Containerize the Application

Create a multi-stage Dockerfile using the approved base images:
- Build stage: `mcr.microsoft.com/openjdk/jdk:25-ubuntu`
- Runtime stage: `mcr.microsoft.com/openjdk/jdk:25-distroless`

Package the application as a container image for deployment to Azure Container Apps.

**Driven by**: Playbook strategy (Replatform to ACA) and playbook target artifacts (targets.md).

---

### Task 8 — Deploy to Azure Container Apps

Deploy the containerized application to Azure Container Apps (ACA) as specified by the playbook modernization strategy for all Java supply chain services.

**Driven by**: Playbook strategy (charter.md) — default strategy is Replatform to Azure Container Apps.

---
