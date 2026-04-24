# Modernization Plan: modernization-plan-shizh

**Project**: SupplyChain Frontend

---

## Technical Framework

- **Language**: Java 8 (target: Java 21)
- **Framework**: Spring Boot 2.7.18 / Spring Framework 5.x (target: Spring Boot 3.x / Spring Framework 6.x)
- **Build Tool**: Maven
- **Key Dependencies**: Spring Web, Tomcat (embedded), JSP/JSTL, Lombok

---

## Overview

This migration upgrades the SupplyChain Frontend application from Spring Boot 2.7.18 / Java 8 to Spring Boot 3.x / Java 21 and makes it cloud-ready for Azure. The application currently uses an end-of-OSS-support Spring Boot version with Java 8, contains insecure HTTP-based hardcoded URLs, and has known CVE vulnerabilities in its dependencies. The new architecture will:

- Run on Spring Boot 3.x with Java 21 LTS for long-term support, security patches, and Jakarta EE compatibility
- Replace insecure HTTP protocols and hardcoded service URLs with externalized, secure configurations suitable for Azure deployment
- Be free of known CVE vulnerabilities in all dependencies
- Use an updated container image based on Java 21 instead of the legacy Java 8/Tomcat 8.5 image

The migration proceeds in sequential phases: runtime upgrade first, followed by cloud readiness fixes, security remediation, and finally container image update.

---

## Migration Impact Summary

| Application             | Original Service               | New Azure Service / Version     | Authentication | Comments                                           |
|-------------------------|--------------------------------|---------------------------------|----------------|----------------------------------------------------|
| supplychain-frontend    | Spring Boot 2.7.18 / Java 8    | Spring Boot 3.x / Java 21       | N/A            | Includes Jakarta EE (javax.* → jakarta.*) migration |
| supplychain-frontend    | Hardcoded HTTP URLs / localhost | Externalized config (HTTPS)     | N/A            | Fix insecure protocols & hardcoded URLs             |
| supplychain-frontend    | Vulnerable dependencies (CVE)  | Patched dependencies            | N/A            | Remediate all known CVEs in project dependencies    |
| supplychain-frontend    | Dockerfile (Java 8/Tomcat 8.5) | Updated container (Java 21)     | N/A            | Update base image after Spring Boot 3.x upgrade     |

---

## Migration Tasks

### Task 1: Upgrade Spring Boot to 3.x

Upgrade the application from Spring Boot 2.7.18 / Java 8 to Spring Boot 3.x / Java 21. This upgrade includes migrating from Spring Framework 5.x to 6.x, migrating from Java EE (`javax.*`) to Jakarta EE (`jakarta.*`), and updating the Java compiler target to 21.

### Task 2: Fix Cloud Readiness Issues

Fix insecure HTTP protocols and hardcoded URLs identified in the assessment:
- Replace the hardcoded `http://backend:8080/api` URL in `application.yml` with an externalized environment variable and use HTTPS
- Remove or update the localhost HTTP reference in `SupplyChainFrontendApplication.java`

### Task 3: Security — Fix CVE Issues

Scan all project dependencies for known CVE vulnerabilities and upgrade affected dependencies to patched versions to ensure the application is CVE-clean.

### Task 4: Update Container Image

Update the existing `Dockerfile` to use a Java 21-based base image, replacing the legacy `maven:3.8-openjdk-8` and `tomcat:8.5-jdk8` images.

---

## Security Compliance

**Description**: Scan and remediate all known CVE vulnerabilities in project dependencies to ensure no critical or high-severity security issues remain.

**Requirements**: All known CVE issues in project dependencies must be identified and fixed by upgrading to patched dependency versions. The application must build and pass tests after remediation.

**Environment Configuration**: Java 21 and Maven (established by the upgrade task).

**App Scope**: `.` (root project)

**Skills**:
- Skill Name: validate-cves-and-fix
  - Skill Location: builtin
