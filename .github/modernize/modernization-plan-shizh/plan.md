# Modernization Plan: Upgrade and Migrate to Azure

**Project**: SupplyChain Frontend (`supplychain-frontend`)

---

## Technical Framework

- **Language**: Java 8
- **Framework**: Spring Boot 2.7.18
- **Build Tool**: Maven 3.x
- **Database**: N/A (frontend service, calls backend API)
- **Key Dependencies**: Spring Boot Starter Web, RestTemplate (HTTP client), Lombok (SLF4J logging), JSTL/JSP (view layer)

---

## Overview

> This migration modernizes the SupplyChain Frontend Java service to align with the Acme Corp
> Modernization Playbook and deploy it to Azure Container Apps (ACA). The application currently
> runs on Java 8 / Spring Boot 2.7.18 as a WAR artifact, uses RestTemplate for backend API
> communication, and relies on SLF4J/Lombok for logging — all of which violate active playbook
> guardrails. The new architecture will:
>
> - Upgrade the runtime from Java 8 / Spring Boot 2.x to Java 25 / Spring Boot 4.x, including
>   full Jakarta EE namespace migration, to meet the internal EOL and version targets.
> - Replace all prohibited HTTP client usages (RestTemplate) with the ServiceMesh SDK
>   (`com.acme.mesh.ServiceMesh`), ensuring every service-to-service call benefits from
>   automatic mTLS, circuit breaking, and distributed tracing.
> - Replace all prohibited logging usages (SLF4J `@Slf4j`, `System.out.println`) with the
>   internal InternalLogger (`com.acme.logging.InternalLogger`) for trace-context-aware,
>   structured JSON logging.
> - Move sensitive configuration values (backend API URL, credentials) out of source files
>   and into Azure Key Vault, accessed via Managed Identity.
> - Containerize the service using approved Microsoft OpenJDK distroless base images and
>   deploy it to Azure Container Apps as the target compute platform.
>
> The migration follows a phased approach: runtime upgrade first, then policy-compliance
> transforms, then containerization and deployment.

---

## Migration Impact Summary

| Application            | Original Service          | New Azure Service          | Authentication     | Comments                                      |
|------------------------|---------------------------|----------------------------|--------------------|-----------------------------------------------|
| supplychain-frontend   | Java 8 / Spring Boot 2.x  | Java 25 / Spring Boot 4.x  | N/A                | EOL runtime upgrade per targets.md            |
| supplychain-frontend   | RestTemplate (HTTP client) | ServiceMesh SDK            | Managed Identity   | Prohibited technology per policies.md         |
| supplychain-frontend   | SLF4J / @Slf4j / stdout   | InternalLogger             | N/A                | Prohibited technology per policies.md         |
| supplychain-frontend   | Hardcoded config values    | Azure Key Vault            | Managed Identity   | Required per policies.md secrets management   |
| supplychain-frontend   | WAR / local deployment     | Azure Container Apps (ACA) | Managed Identity   | Default compute target per charter.md         |

---

## Task List

### Phase 1 — Runtime Upgrade

| # | Task | Type | Skill |
|---|------|------|-------|
| 001 | Upgrade Spring Boot from 2.7.18 to 4.x (Java 25, Jakarta EE) | upgrade | — |

### Phase 2 — Policy-Compliance Transforms

| # | Task | Type | Skill |
|---|------|------|-------|
| 002 | Migrate RestTemplate to ServiceMesh SDK | transform | — |
| 003 | Migrate SLF4J / Lombok @Slf4j / System.out.println to InternalLogger | transform | — |
| 004 | Migrate hardcoded configuration and credentials to Azure Key Vault | transform | migration-plaintext-credential-to-azure-keyvault |

### Phase 3 — Containerization

| # | Task | Type | Skill |
|---|------|------|-------|
| 005 | Containerize application with multi-stage Dockerfile | containerization | — |

### Phase 4 — Deployment

| # | Task | Type | Skill |
|---|------|------|-------|
| 006 | Deploy to Azure Container Apps using Bicep | deployment | — |

---

## Compliance Notes

This plan is generated in accordance with the **Acme Corp Modernization Playbook** (v2025-01-15):

- All prohibited technologies (RestTemplate, WebClient, FeignClient, SLF4J, Log4j, Logback,
  `java.util.logging`, `System.out.println`) have corresponding remediation tasks.
- All hardcoded credentials and sensitive configuration values will be moved to Azure Key Vault
  (required element per policies.md).
- The target compute platform is Azure Container Apps (ACA), per the charter's 6R strategy for
  Java supply-chain services.
- Container base images are sourced from `mcr.microsoft.com/openjdk/jdk:25-ubuntu` (build) and
  `mcr.microsoft.com/openjdk/jdk:25-distroless` (runtime) per targets.md.
- Target completion: Q4 2026 (per charter.md).
