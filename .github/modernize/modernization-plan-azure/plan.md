# Modernization Plan: SupplyChain Frontend Azure Migration

**Project**: supplychain-frontend

---

## Technical Framework

- **Language**: Java 8
- **Framework**: Spring Boot 2.7.18 (Spring Framework 5.x)
- **Build Tool**: Maven
- **Database**: None (frontend-only, calls backend API via RestTemplate)
- **Key Dependencies**: Spring Boot Web, Tomcat Embed Jasper (JSP), JSTL (javax.servlet), Lombok

---

## Overview

> This migration upgrades the SupplyChain Frontend application from a legacy Java 8 / Spring Boot 2.7.18 stack to modern Java 21 / Spring Boot 3.x, addresses all known CVE vulnerabilities, and prepares the application for deployment on Azure. The application currently runs as a WAR deployed on Tomcat 8.5, serving JSP-based views and communicating with a backend API via RestTemplate.
>
> The modernization will:
>
> - Upgrade the runtime to Java 21 and Spring Boot 3.x for long-term support, security patches, and modern framework capabilities
> - Resolve all known CVE vulnerabilities in project dependencies to ensure security compliance
> - Update the container image to use modern base images compatible with the upgraded stack
>
> The migration follows a phased approach: upgrade first, then security remediation, then containerization.

---

## Migration Impact Summary

| Application          | Original Service               | New Azure Service              | Authentication | Comments                          |
|----------------------|--------------------------------|--------------------------------|----------------|-----------------------------------|
| supplychain-frontend | Java 8 / Spring Boot 2.7.18   | Java 21 / Spring Boot 3.x     | N/A            | Upgrade runtime and framework     |
| supplychain-frontend | Tomcat 8.5 (JDK 8) container  | Java 21 container image        | N/A            | Modernize Dockerfile              |

---

## Upgrade

Upgrade Spring Boot from 2.7.18 to 3.x, which includes Java 8 to 21, Spring Framework 5.x to 6.x, and javax.* to jakarta.* namespace migration. This addresses the following assessment findings:

- **azure-java-version-02000**: Legacy Java version (Java 8)
- **spring-boot-to-azure-spring-boot-version-01000**: Spring Boot version End of OSS Support
- **spring-framework-version-01000**: Spring Framework version End of OSS Support

---

## Security Compliance

**Description**: Validate and fix all CVE vulnerabilities in project dependencies

**Requirements**: Ensure all dependencies are free of known CVE issues after the upgrade to Java 21 / Spring Boot 3.x

**Environment Configuration**: Java 21, Maven

**App Scope**: Project root (.)

**Skills**:
  - Skill Name: validate-cves-and-fix
    - Skill Location: builtin

---

## Containerization

Update the existing Dockerfile to use modern base images compatible with the upgraded Java 21 / Spring Boot 3.x stack, replacing the legacy maven:3.8-openjdk-8 and tomcat:8.5-jdk8 images.
