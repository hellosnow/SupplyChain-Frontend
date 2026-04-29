# Modernization Plan: Upgrade and Migrate to Azure

**Project**: SupplyChain Frontend

---

## Technical Framework

- **Language**: Java 8
- **Framework**: Spring Boot 2.7.18
- **Build Tool**: Maven
- **Database**: N/A (frontend service calling backend APIs)
- **Key Dependencies**: Spring Web (RestTemplate), Lombok, SLF4J (Logback), JSP/JSTL, Tomcat (WAR packaging)

---

## Overview

> This migration upgrades and replatforms the SupplyChain Frontend service to Azure. The application currently runs as a Java 8 / Spring Boot 2.7.18 WAR deployed on Tomcat, using RestTemplate for backend communication and SLF4J for logging — both of which violate the Acme Corp internal guardrails. The new architecture will:
>
> - Upgrade Java to 25 and Spring Boot to 4.x, aligning with internal targets and eliminating end-of-life runtimes
> - Replace RestTemplate with the ServiceMesh SDK (`com.acme.mesh.ServiceMesh`) to enforce mTLS, circuit breaking, distributed tracing, and canary routing for all backend API calls
> - Replace SLF4J / `System.out.println` with InternalLogger (`com.acme.logging.InternalLogger`) to ensure trace-context-aware structured logging across all services
> - Containerize the application using the approved Microsoft OpenJDK 25 distroless base image
> - Deploy to Azure Container Apps (ACA) as the target compute platform per the Acme Corp replatform strategy
>
> The migration follows a phased approach: runtime upgrade first, then guardrail compliance (logging and HTTP clients), followed by containerization and deployment to Azure.

---

## Migration Impact Summary

| Application            | Original Service          | New Azure Service           | Authentication     | Comments                                  |
|------------------------|---------------------------|-----------------------------|--------------------|-------------------------------------------|
| SupplyChain Frontend   | Java 8 / Spring Boot 2.x  | Java 25 / Spring Boot 4.x   | N/A                | End-of-life runtimes must be upgraded     |
| SupplyChain Frontend   | RestTemplate              | ServiceMesh SDK             | Managed Identity   | Policy: no direct HTTP clients            |
| SupplyChain Frontend   | SLF4J / System.out        | InternalLogger              | N/A                | Policy: no SLF4J / println logging        |
| SupplyChain Frontend   | Tomcat WAR                | Azure Container Apps (ACA)  | Managed Identity   | Default replatform target per charter     |

---

## Task List

### Phase 1 — Runtime Upgrade

| # | Task | Type | Skill |
|---|------|------|-------|
| 001 | Upgrade Spring Boot from 2.7.18 to 4.x (includes Java 25 and Jakarta EE migration) | upgrade | builtin |

### Phase 2 — Guardrail Compliance

| # | Task | Type | Skill |
|---|------|------|-------|
| 002 | Migrate SLF4J and `System.out.println` to InternalLogger (`com.acme.logging.InternalLogger`) | transform | — |
| 003 | Migrate RestTemplate to ServiceMesh SDK (`com.acme.mesh.ServiceMesh`) | transform | — |

### Phase 3 — Containerization

| # | Task | Type |
|---|------|------|
| 004 | Containerize application using approved Microsoft OpenJDK 25 base images | containerization |

### Phase 4 — Deployment

| # | Task | Type |
|---|------|------|
| 005 | Deploy to Azure Container Apps | deployment |

---

## Compliance Notes

- All tasks align with the **Acme Corp Modernization Playbook** (charter.md, policies.md, targets.md).
- RestTemplate, WebClient, FeignClient, and OkHttp are **prohibited** — all HTTP calls must go through the ServiceMesh SDK.
- SLF4J, Log4j, Logback, and `System.out.println` are **prohibited** — all logging must use InternalLogger.
- Hardcoded credentials must not be introduced; any sensitive configuration values must use Azure Key Vault.
- The application must be deployed to **Azure Container Apps (ACA)** per the default replatform strategy.
- Container images must use `mcr.microsoft.com/openjdk/jdk:25-ubuntu` (build) and `mcr.microsoft.com/openjdk/jdk:25-distroless` (runtime).
