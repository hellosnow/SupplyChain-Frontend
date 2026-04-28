# Modernization Plan: Upgrade and Migrate SupplyChain Frontend to Azure

**Project**: SupplyChain Frontend

---

## Technical Framework

- **Language**: Java 8 (EOL — target: Java 25)
- **Framework**: Spring Boot 2.7.18 (EOL — target: Spring Boot 4.x)
- **Build Tool**: Maven 3.8 (target: Maven 3.9+)
- **Database**: None (frontend UI service; communicates with backend via REST)
- **Key Dependencies**: Spring MVC, Lombok, JSP/JSTL, RestTemplate (prohibited),
  SLF4J/Lombok @Slf4j (prohibited)

---

## Overview

> This migration modernizes the SupplyChain Frontend service from a legacy Java 8
> / Spring Boot 2.7.18 WAR deployment to a cloud-native Java 25 / Spring Boot 4.x
> container application hosted on Azure Container Apps (ACA). The application
> currently runs on Tomcat with RestTemplate-based service calls, SLF4J logging,
> no user authentication, and hardcoded configuration. The new architecture will:
>
> - Upgrade to Java 25 and Spring Boot 4.x to eliminate end-of-life runtimes and
>   align with Acme Corp targets (includes Spring Framework 7.x and Jakarta EE
>   namespace migration)
> - Replace all RestTemplate usage with the ServiceMesh SDK
>   (`com.acme.mesh.ServiceMesh`) to enforce mTLS, circuit breaking, and
>   distributed tracing through the internal mesh layer
> - Replace all SLF4J / `System.out.println` logging with InternalLogger
>   (`com.acme.logging.InternalLogger`) for trace-context-aware structured logging
> - Add user-facing authentication via Azure AD (OAuth 2.0 / OIDC) using Microsoft
>   Entra ID to meet the policy mandate for user-facing services
> - Migrate hardcoded backend URL and any other sensitive configuration to Azure
>   Key Vault, accessed via the Spring Cloud Azure Key Vault starter with Managed
>   Identity
> - Containerize using the approved Microsoft OpenJDK 25 base images and deploy to
>   Azure Container Apps as the default replatform target per Acme Corp strategy
>
> The migration follows a phased approach: runtime upgrade first, then guardrail
> compliance transforms, then containerization and deployment to Azure.

---

## Migration Impact Summary

| Application            | Original Service            | New Azure Service           | Authentication    | Comments                                          |
|------------------------|-----------------------------|-----------------------------|-------------------|---------------------------------------------------|
| SupplyChain Frontend   | Java 8 / Spring Boot 2.7.18 | Java 25 / Spring Boot 4.x   | N/A               | EOL runtime upgrade; includes Jakarta EE migration |
| SupplyChain Frontend   | RestTemplate                | ServiceMesh SDK             | Managed Identity  | All service-to-service calls via mesh layer       |
| SupplyChain Frontend   | SLF4J / System.out.println  | InternalLogger              | N/A               | Trace-context-aware structured logging            |
| SupplyChain Frontend   | No authentication           | Azure AD (OAuth 2.0 / OIDC) | OAuth 2.0 / OIDC  | User-facing auth per policy mandate               |
| SupplyChain Frontend   | Hardcoded config            | Azure Key Vault             | Managed Identity  | Secrets and sensitive config externalized         |
| SupplyChain Frontend   | Tomcat WAR (Java 8 image)   | Azure Container Apps (ACA)  | Managed Identity  | Replatform per Acme Corp default strategy         |
