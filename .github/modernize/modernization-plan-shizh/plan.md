# Modernization Plan: SupplyChain Frontend — Upgrade, Azure Migration & CVE Remediation

**Plan Name**: modernization-plan-shizh  
**Project**: SupplyChain Frontend

---

## Technical Framework

- **Language**: Java 8
- **Framework**: Spring Boot 2.7.18, Spring Framework 5.x
- **Build Tool**: Maven 3.8
- **Database**: N/A (frontend web application)
- **Key Dependencies**: spring-boot-starter-web, tomcat-embed-jasper, JSTL, Lombok, RestTemplate

---

## Overview

This migration upgrades the SupplyChain Frontend from an end-of-support Java 8 + Spring Boot 2.7.18 stack to Java 21 + Spring Boot 3.x, resolves cloud readiness violations flagged in the AppCAT assessment, and remediates known CVE vulnerabilities in project dependencies. The application currently uses unsupported runtime versions with hardcoded HTTP URLs that prevent clean Azure deployments. The new architecture will:

- Eliminate end-of-support Java 8 and Spring Boot 2.7.18, upgrading to Java 21 and Spring Boot 3.x with full Jakarta EE namespace compliance
- Resolve cloud readiness issues by replacing hardcoded HTTP backend URLs with environment-variable-driven, HTTPS-ready configuration
- Achieve a CVE-free dependency tree to satisfy security compliance requirements before Azure deployment

The migration follows a phased approach: framework upgrade first, then cloud readiness transform and CVE remediation in parallel (both depending on the upgrade).

---

## Migration Impact Summary

| Application          | Original Service            | New Azure Service            | Authentication | Comments                                      |
|----------------------|-----------------------------|------------------------------|----------------|-----------------------------------------------|
| supplychain-frontend | Spring Boot 2.7.18 / Java 8 | Spring Boot 3.x / Java 21    | N/A            | Framework upgrade with Jakarta EE namespace   |
| supplychain-frontend | Hardcoded HTTP backend URL  | Environment-configurable URL | N/A            | Cloud readiness fix for Azure deployment      |
| supplychain-frontend | Unpatched dependencies      | CVE-free dependencies        | N/A            | Security vulnerability remediation           |

---

## Tasks

### Task 1 — Upgrade Spring Boot 3.x (001-upgrade-spring-boot-3)

Upgrade the application from Spring Boot 2.7.18 + Java 8 to Spring Boot 3.x + Java 21. This includes Spring Framework 6.x migration, Jakarta EE namespace changes (javax.* → jakarta.*), and updating the Dockerfile base images to Java 21.

### Task 2 — Fix Cloud Readiness Issues (002-transform-cloud-readiness)

*Depends on*: `001-upgrade-spring-boot-3`

Replace the hardcoded backend API URL (`http://backend:8080/api`) with environment-variable-driven configuration. Remove insecure HTTP scheme references and localhost URLs flagged by AppCAT assessment rules: `unsecure-network-protocol-00000`, `localhost-http-00001`, `hardcoded-urls-00001`.

---

## Security Compliance

**Description**: Validate and fix all known CVE vulnerabilities in project dependencies to ensure a secure, CVE-free state before Azure deployment.

**Requirements**: Scan all project dependencies for known CVE vulnerabilities and upgrade affected packages to patched versions. Ensure no critical or high-severity CVE issues remain in the dependency tree after remediation.

**Environment Configuration**: Java 21 runtime and Maven build tool as established by the Spring Boot 3.x upgrade task (`001-upgrade-spring-boot-3`).

**App Scope**: `.` (project root — supplychain-frontend)

**Skills**:
  - Skill Name: validate-cves-and-fix
    - Skill Location: builtin
