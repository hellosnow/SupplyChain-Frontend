# Modernization Plan: Upgrade and Migrate SupplyChain Frontend to Azure

**Project**: SupplyChain Frontend

---

## Technical Framework

- **Language**: Java 8
- **Framework**: Spring Boot 2.7.18
- **Build Tool**: Maven 3.x
- **Database**: N/A (frontend web application)
- **Key Dependencies**: Spring MVC, RestTemplate (service-to-service communication),
  SLF4J / Logback (logging), Lombok, JSTL, Tomcat (embedded WAR packaging)

---

## Overview

> This migration upgrades the SupplyChain Frontend from Java 8 / Spring Boot 2.7.18 to
> Java 25 / Spring Boot 4.x and replatforms it to Azure Container Apps (ACA). The
> application currently runs as a Tomcat WAR using RestTemplate for backend API calls and
> SLF4J for logging — both of which violate Acme Corp guardrails. The new architecture
> will:
>
> - Upgrade to Java 25 and Spring Boot 4.x to meet end-of-life requirements and enable
>   cloud-native deployment on Azure.
> - Replace RestTemplate with the ServiceMesh SDK (`com.acme.mesh.ServiceMesh`) for all
>   backend API communication, enforcing mTLS, circuit breaking, distributed tracing,
>   and canary routing.
> - Replace SLF4J / Logback with InternalLogger (`com.acme.logging.InternalLogger`) for
>   trace-context-aware structured logging across all application classes.
> - Integrate Microsoft Entra ID (Azure AD) for user-facing OAuth 2.0 / OIDC
>   authentication to replace session-based access control.
> - Store all sensitive configuration values in Azure Key Vault and access them via
>   Managed Identity, eliminating hardcoded credentials and URLs.
> - Containerize the application using approved `mcr.microsoft.com/openjdk/jdk:25`
>   base images and deploy to Azure Container Apps using Bicep IaC.
>
> The migration is sequenced so each phase builds on the previous: upgrade first, then
> compliance and Azure service integrations, then containerization and deployment.

---

## Migration Impact Summary

| Application          | Original Service            | New Azure Service                   | Authentication     | Comments                                  |
|----------------------|-----------------------------|-------------------------------------|--------------------|-------------------------------------------|
| SupplyChain Frontend | Java 8 / Spring Boot 2.7.18 | Java 25 / Spring Boot 4.x           | N/A                | EOL upgrade per targets.md                |
| SupplyChain Frontend | RestTemplate                | ServiceMesh SDK                     | Managed Identity   | Guardrail: mesh required for all S2S      |
| SupplyChain Frontend | SLF4J / Logback             | InternalLogger                      | N/A                | Guardrail: trace-context logging required |
| SupplyChain Frontend | Session-based auth          | Microsoft Entra ID (OAuth 2.0/OIDC) | OAuth 2.0 / OIDC   | Policy: user auth must use Azure AD       |
| SupplyChain Frontend | Hardcoded config            | Azure Key Vault                     | Managed Identity   | Policy: secrets must be in Key Vault      |
| SupplyChain Frontend | Tomcat WAR                  | Azure Container Apps (ACA)          | Managed Identity   | Strategy: Replatform to ACA               |

---

## Modernization Tasks

### Task 001 — Spring Boot Upgrade

Upgrade the application from Spring Boot 2.7.18 (Java 8) to Spring Boot 4.x (Java 25).
This includes migrating `javax.*` namespaces to `jakarta.*` and updating all
incompatible dependencies to versions compatible with Spring Boot 4.x and Java 25.

### Task 002 — Migrate Service-to-Service Communication to ServiceMesh SDK

Replace all `RestTemplate` usage with `com.acme.mesh.ServiceMesh` for all backend API
calls. This brings automatic mTLS termination, circuit breaking, distributed tracing,
and canary routing to all service-to-service communication.

### Task 003 — Migrate Logging to InternalLogger

Replace all SLF4J (`@Slf4j`, `LoggerFactory`) and `System.out.println` usages with
`com.acme.logging.InternalLogger` across all controllers and service classes. Remove
Logback and SLF4J dependencies from the project.

### Task 004 — Migrate User Authentication to Microsoft Entra ID

Migrate user-facing authentication from session-based access control to Microsoft
Entra ID (Azure AD) using OAuth 2.0 / OIDC. All authenticated web routes must be
protected via Azure AD tokens.

### Task 005 — Migrate Credentials to Azure Key Vault

Migrate all sensitive configuration values (credentials, API keys, backend URLs,
connection strings) from `application.yml` and source code to Azure Key Vault.
Configure the application to read secrets via Managed Identity.

### Task 006 — Containerize the Application

Update the Dockerfile to use an approved multi-stage build: build stage with
`mcr.microsoft.com/openjdk/jdk:25-ubuntu` and runtime stage with
`mcr.microsoft.com/openjdk/jdk:25-distroless`. The application is packaged as a JAR
for container deployment.

### Task 007 — Deploy to Azure Container Apps

Deploy the containerized application to Azure Container Apps using Bicep IaC.
Configure Managed Identity for Azure Key Vault access and appropriate scaling,
environment, and networking settings.
