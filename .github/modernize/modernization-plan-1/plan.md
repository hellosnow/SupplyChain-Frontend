# Modernization Plan: SupplyChain Frontend Modernization

**Project**: SupplyChain Frontend

---

## Technical Framework

- **Language**: Java 8
- **Framework**: Spring Boot 2.7.18
- **Build Tool**: Maven
- **Database**: N/A (stateless frontend; communicates with backend API
  via RestTemplate)
- **Key Dependencies**: Spring Boot Web, Embedded Tomcat (provided),
  JSP/JSTL, Lombok

---

## Overview

This migration upgrades and replatforms the SupplyChain Frontend
application to Azure Container Apps. The application currently runs
on Java 8 with Spring Boot 2.7.18, packaged as a WAR deployed to
Tomcat 8.5. The new architecture will:

- Upgrade the Java runtime from 8 to 25 and Spring Boot from 2.7.18
  to 4.0+ per Acme Corp playbook policy
- Validate and remediate all CVE vulnerabilities in project
  dependencies to ensure security compliance
- Containerize the application with approved base images for
  Azure Container Apps deployment
- Deploy the application to Azure Container Apps as the target
  compute platform per the Acme Corp Replatform strategy

The migration follows the Acme Corp Replatform strategy for Java
supply chain services, targeting Azure Container Apps with Java 25
and Spring Boot 4.0+.

---

## Migration Impact Summary

| Application          | Original Service             | New Azure Service           | Authentication   | Comments                          |
|----------------------|------------------------------|-----------------------------|------------------|-----------------------------------|
| supplychain-frontend | Java 8 / Spring Boot 2.7.18  | Java 25 / Spring Boot 4.0+  | Managed Identity | Upgrade runtime per playbook      |
| supplychain-frontend | Tomcat 8.5 WAR deployment    | Azure Container Apps        | Managed Identity | Replatform to ACA                 |

---

## Upgrade Tasks

### Task 001 — Upgrade Spring Boot to 4.0+ and Java to 25

Upgrade the application from Spring Boot 2.7.18 with Java 8 to
Spring Boot 4.0+ with Java 25. This task covers the full framework
upgrade including Jakarta EE namespace migration (`javax.*` →
`jakarta.*`) and all dependency version alignments required for
Spring Boot 4.0+ compatibility.

---

## Security Compliance

**Description**: Validate and fix all CVE vulnerabilities in project
dependencies

**Requirements**: Ensure all CVE issues in project dependencies are
identified and resolved. All dependencies must be free of known
critical and high-severity CVEs after remediation.

**Environment Configuration**: Runtime environment established by the
upgrade task (Java 25, Spring Boot 4.0+, Maven)

**App Scope**: Project root
(C:\Users\jessiehuang\modernize\repos\SupplyChain-frontend)

**Skills**:
  - Skill Name: validate-cves-and-fix
    - Skill Location: builtin

---

## Containerization

### Task 003 — Update Dockerfile for Azure Container Apps

Update the Dockerfile to align with the upgraded Java 25 /
Spring Boot 4.0+ runtime and prepare the application for deployment
to Azure Container Apps. The container images should use the Acme
Corp approved base images
(`mcr.microsoft.com/openjdk/jdk:25-ubuntu` for build,
`mcr.microsoft.com/openjdk/jdk:25-distroless` for runtime).

---

## Deployment

### Task 004 — Deploy to Azure Container Apps

Deploy the containerized application to Azure Container Apps as the
target compute platform per the Acme Corp modernization strategy.
