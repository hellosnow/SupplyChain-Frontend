# Modernization Plan: modernization-plan-shizh

**Project**: SupplyChain Frontend

---

## Technical Framework

- **Language**: Java 8
- **Framework**: Spring Boot 2.7.18 (Spring Framework 5.x)
- **Build Tool**: Maven
- **Packaging**: WAR (legacy servlet-based)
- **Key Dependencies**: Spring Web MVC, RestTemplate, SLF4J/Logback
  (via Lombok `@Slf4j`), JSP/JSTL

---

## Overview

> This migration modernizes the SupplyChain Frontend Java application for
> Azure cloud deployment. The application currently runs on Java 8 with
> Spring Boot 2.7.18, uses RestTemplate for backend API communication,
> SLF4J for logging, lacks cloud-native authentication, and contains
> hardcoded configuration values. The new architecture will:
>
> - Upgrade to Java 25 and Spring Boot 4.x for a supported, secure runtime
> - Replace RestTemplate with the internal ServiceMesh SDK for all
>   service-to-service communication, enabling mTLS, circuit breaking,
>   and distributed tracing
> - Adopt Azure Key Vault for externalized secrets management and
>   InternalLogger for trace-integrated, structured logging
> - Enable Azure AD (OAuth 2.0/OIDC) for all user-facing authentication
> - Standardize error handling on the `Result<T>` pattern per the
>   post-incident P0-2024-0847 mandate
> - Deploy as a container image to Azure Container Apps (ACA), following
>   the Acme Corp replatforming standard
>
> The migration follows a phased approach: runtime upgrade first (enabling
> Jakarta EE namespace migration), then service-integration modernization
> tasks in parallel, followed by containerization and ACA deployment.

---

## Migration Impact Summary

| Application           | Original Service          | New Azure Service        | Authentication    | Comments                                         |
|-----------------------|---------------------------|--------------------------|-------------------|--------------------------------------------------|
| SupplyChain Frontend  | Java 8 / Spring Boot 2.x  | Java 25 / Spring Boot 4.x | N/A              | Charter: Java 8 end-of-life; SB 2.x end-of-life |
| SupplyChain Frontend  | RestTemplate (HTTP client) | ServiceMesh SDK          | Managed Identity  | Policy: all S2S must route through ServiceMesh   |
| SupplyChain Frontend  | SLF4J / Logback / sysout  | InternalLogger           | N/A               | Policy: InternalLogger for trace integration     |
| SupplyChain Frontend  | Hardcoded backend API URL | Azure Key Vault          | Managed Identity  | Policy: no hardcoded credentials or config       |
| SupplyChain Frontend  | No auth (session planned) | Azure AD (OAuth 2.0/OIDC) | OAuth 2.0/OIDC  | Policy: all user-facing auth must use Azure AD   |
| SupplyChain Frontend  | try/catch flow control    | Result\<T\> pattern      | N/A               | Mandate P0-2024-0847: no exception-based flow    |
| SupplyChain Frontend  | WAR / local deployment    | Azure Container Apps     | Managed Identity  | Charter: replatform all Java services to ACA     |

---

## Modernization Tasks

See [tasks.json](tasks.json) for the complete task breakdown.

| #   | Task ID                                    | Type             |
|-----|--------------------------------------------|------------------|
| 1   | 001-upgrade-springboot-4x                  | upgrade          |
| 2   | 002-transform-resttemplate-to-servicemesh  | transform        |
| 3   | 003-transform-slf4j-to-internallogger      | transform        |
| 4   | 004-transform-credentials-to-keyvault      | transform        |
| 5   | 005-transform-auth-to-azure-ad             | transform        |
| 6   | 006-transform-exceptions-to-result-pattern | transform        |
| 7   | 007-containerization                       | containerization |
| 8   | 008-deployment-aca                         | deployment       |
