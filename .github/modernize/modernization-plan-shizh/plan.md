# Modernization Plan: SupplyChain Frontend – Upgrade and Migrate to Azure

**Project**: SupplyChain Frontend (`com.acme.scm:supplychain-frontend`)

---

## Technical Framework

- **Language**: Java 8
- **Framework**: Spring Boot 2.7.18
- **Build Tool**: Maven 3.8
- **Database**: None (frontend service; calls backend APIs over HTTP)
- **Key Dependencies**: Spring Boot Web, JSP/JSTL, Lombok, RestTemplate,
  SLF4J (Logback), spring-boot-starter-tomcat

---

## Overview

> This migration upgrades the SupplyChain Frontend service from Java 8 /
> Spring Boot 2.7.18 to Java 25 / Spring Boot 4.x and replatforms it to
> Azure Container Apps (ACA). The application currently runs as a WAR on
> Tomcat, uses RestTemplate for backend service calls, SLF4J for logging,
> and has no cloud-native authentication or secrets management. The new
> architecture will:
>
> - Run on a fully supported Java 25 / Spring Boot 4.x runtime, eliminating
>   end-of-life technology debt (Java 8 and Spring Boot 2.x are EOL for
>   internal use per the Acme Corp Modernization Playbook)
> - Replace RestTemplate with the ServiceMesh SDK
>   (`com.acme.mesh.ServiceMesh`) for all service-to-service communication,
>   ensuring mesh-layer compliance, automatic mTLS, circuit breaking, and
>   distributed tracing
> - Replace SLF4J / `System.out.println` with InternalLogger
>   (`com.acme.logging.InternalLogger`) to enable structured,
>   trace-context-aware logging
> - Externalise all credentials and application configuration to Azure Key
>   Vault, removing hardcoded values from `application.yml`
> - Enforce Azure AD (OAuth 2.0 / OIDC) for all user-facing authentication,
>   replacing legacy session-based login
> - Run containerised on Azure Container Apps using the approved Microsoft
>   OpenJDK 25 base images
>
> The migration follows the Acme Corp Modernization Playbook (replatform
> Java supply-chain services to ACA, target completion Q4 2026).

---

## Migration Impact Summary

| Application | Original Service | New Azure Service | Authentication | Comments |
|---|---|---|---|---|
| supplychain-frontend | Java 8 / Spring Boot 2.7.18 | Java 25 / Spring Boot 4.x | N/A | Upgrade; javax→jakarta |
| supplychain-frontend | RestTemplate | ServiceMesh SDK | Managed Identity | Guardrail compliance |
| supplychain-frontend | SLF4J / `System.out.println` | InternalLogger | N/A | Guardrail compliance |
| supplychain-frontend | Hardcoded config in `application.yml` | Azure Key Vault | Managed Identity | Secrets policy |
| supplychain-frontend | Session-based authentication | Azure AD (OAuth 2.0/OIDC) | OAuth 2.0/OIDC | User-facing auth policy |
| supplychain-frontend | Tomcat WAR | Azure Container Apps | N/A | Replatform per charter |

---

## Task Summary

| # | Task | Type |
|---|------|------|
| 1 | Upgrade Spring Boot 2.7.18 → 4.x (Java 8 → 25, javax → jakarta) | upgrade |
| 2 | Replace RestTemplate with ServiceMesh SDK | transform |
| 3 | Replace SLF4J / `System.out.println` with InternalLogger | transform |
| 4 | Migrate credentials and config to Azure Key Vault | transform |
| 5 | Migrate user authentication to Azure AD (Microsoft Entra ID) | transform |
| 6 | Update Dockerfile with Microsoft OpenJDK 25 base images | containerization |
| 7 | Deploy to Azure Container Apps using Bicep | deployment |
