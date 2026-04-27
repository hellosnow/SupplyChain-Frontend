# Modernization Plan: SupplyChain Frontend – Azure Migration & Upgrade

**Project**: SupplyChain Frontend (`supplychain-frontend`)

**Plan Name**: modernization-plan-shizh

---

## Technical Framework

- **Language**: Java 8
- **Framework**: Spring Boot 2.7.18, Spring Framework 5.x
- **Build Tool**: Maven
- **Database**: N/A (frontend web application)
- **Key Dependencies**: Spring Web (RestTemplate), Lombok, JSP/JSTL, SLF4J/Logback

---

## Overview

This migration modernizes the SupplyChain Frontend from a legacy Java 8 / Spring Boot
2.7.18 WAR application to a cloud-native Java 25 / Spring Boot 4.x containerized service
deployable on Azure Container Apps. The application currently uses end-of-life frameworks,
direct HTTP backend calls using RestTemplate (bypassing the service mesh), SLF4J logging
(no trace context), hardcoded HTTP backend URLs, and has known CVE vulnerabilities in its
dependencies. The new architecture will:

- Upgrade to Java 25 and Spring Boot 4.x per Acme Corp internal policy (Java 8, 11, 17
  are EOL; Spring Boot 2.x and 3.x must be upgraded)
- Replace RestTemplate with the ServiceMesh SDK (`com.acme.mesh.ServiceMesh`) for all
  backend service communication, providing automatic mTLS termination, circuit breaking,
  distributed tracing, and canary routing
- Migrate all logging to InternalLogger (`com.acme.logging.InternalLogger`) to ensure
  trace context integration, structured JSON output, and team tag support
- Move the hardcoded backend connection URL to Azure Key Vault for centralized secrets
  management using Managed Identity
- Remediate all CVE vulnerabilities found in project dependencies
- Containerize the application using approved Microsoft OpenJDK base images and deploy to
  Azure Container Apps as the designated target compute service

The migration follows a phased approach: framework upgrade → service mesh integration →
logging modernization → secrets management → security CVE remediation → containerization
→ Azure Container Apps deployment.

---

## Migration Impact Summary

| Application           | Original Service              | New Azure Service            | Authentication     | Comments                                      |
|-----------------------|-------------------------------|------------------------------|--------------------|-----------------------------------------------|
| supplychain-frontend  | Java 8 / Spring Boot 2.7.18   | Java 25 / Spring Boot 4.x    | N/A                | Mandatory framework upgrade (EOL per policy)  |
| supplychain-frontend  | RestTemplate (HTTP calls)     | ServiceMesh SDK              | Managed Identity   | Guardrail req; resolves HTTP/hardcoded URL    |
| supplychain-frontend  | SLF4J / System.out.println    | InternalLogger               | N/A                | Policy: trace context required in all logging |
| supplychain-frontend  | Hardcoded backend URL         | Azure Key Vault              | Managed Identity   | Policy: connection strings must be in KV      |
| supplychain-frontend  | N/A (no container)            | Azure Container Apps         | Managed Identity   | Default compute target per Acme Corp charter  |

---

## Security Compliance

**Description**: Validate and remediate all CVE (Common Vulnerabilities and Exposures)
vulnerabilities in Spring Boot 2.7.18 / Java 8 project dependencies. Ensure no high or
critical CVEs remain in the final build after the framework upgrade to Spring Boot 4.x /
Java 25.

**Requirements**:
All CVE issues must be fixed. No CVE vulnerabilities may remain in the production build.
CVE scanning must run after all upgrade and transform tasks have been applied.

**Environment Configuration**:
Runtime environment established by the Spring Boot 4.x upgrade task (Java 25, Maven 3.9+).
Build tool: Maven (established by previous upgrade task).

**App Scope**:
`.` (root project folder – `supplychain-frontend`)

**Skills**:
  - Skill Name: validate-cves-and-fix
    - Skill Location: builtin

---

For the detailed task breakdown, see [tasks.json](tasks.json).
