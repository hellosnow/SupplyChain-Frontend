# Modernization Plan: SupplyChain Frontend Azure Migration

**Project**: supplychain-frontend

---

## Technical Framework

- **Language**: Java 8
- **Framework**: Spring Boot 2.7.18 (Spring Framework 5.x)
- **Build Tool**: Maven
- **Packaging**: WAR (deployed on Tomcat 8.5)
- **Key Dependencies**: Spring MVC, JSP/JSTL, Lombok, RestTemplate

---

## Overview

> This migration upgrades the SupplyChain Frontend application
> from Java 8 / Spring Boot 2.7.18 to Java 21 / Spring Boot 3.x
> and prepares it for deployment on Azure Container Apps.
> The application currently runs as a WAR on Tomcat 8.5 using
> legacy Java 8 base images. The new architecture will:
>
> - Upgrade to Java 21 and Spring Boot 3.x with Jakarta EE
>   namespace migration
> - Resolve all known CVE vulnerabilities in project dependencies
> - Update containerization for Azure Container Apps deployment
>   readiness
>
> The migration follows a phased approach: upgrade first, then
> security remediation, then containerization.

---

## Migration Impact Summary

| Application          | Original Service       | New Azure Service       | Authentication   | Comments                            |
|----------------------|------------------------|-------------------------|------------------|-------------------------------------|
| supplychain-frontend | Tomcat 8.5 / Java 8   | Azure Container Apps    | Managed Identity | Upgrade Java 21 / Spring Boot 3.x  |

---

## Upgrade

**Description**: Upgrade the application from Spring Boot 2.7.18
(Java 8) to Spring Boot 3.x (Java 21), including the javax.* to
jakarta.* namespace migration and Spring Framework 6.x upgrade.

**Requirements**:
  Upgrade Spring Boot from 2.7.18 to the latest 3.x version.
  This includes upgrading Java from 8 to 21, migrating javax.*
  imports to jakarta.* (Jakarta EE), and upgrading Spring
  Framework to 6.x. Ensure all dependencies are compatible
  with the new versions.

**App Scope**: Root project (.)

---

## Security Compliance

**Description**: Validate and fix CVE vulnerabilities in project
dependencies to ensure a secure deployment on Azure.

**Requirements**:
  Scan all project dependencies for known CVE vulnerabilities
  and apply fixes by upgrading affected dependencies to patched
  versions. Ensure no critical or high-severity CVEs remain
  after remediation.

**Environment Configuration**:
  Runtime: Java 21 (established by upgrade task)
  Build tool: Maven

**App Scope**: Root project (.)

**Skills**:
  - Skill Name: validate-cves-and-fix
    - Skill Location: builtin

---

## Containerization

**Description**: Update the existing Dockerfile to use Java 21
base images and prepare for Azure Container Apps deployment.

**Requirements**:
  Update the multi-stage Dockerfile to use Java 21-compatible
  base images. Ensure the container builds and runs correctly
  with the upgraded application. The Dockerfile currently uses
  maven:3.8-openjdk-8 (build) and tomcat:8.5-jdk8 (runtime).

**Dockerfile**: ./Dockerfile (existing, to be updated)
