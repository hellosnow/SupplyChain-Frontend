# Modernization Plan: Java Version Upgrade

**Project**: SupplyChain Frontend

---

## Technical Framework

- **Language**: Java 8
- **Framework**: Spring Boot 2.7.18
- **Build Tool**: Maven
- **Database**: N/A
- **Key Dependencies**: Spring Boot Web, Embedded Tomcat (provided), JSTL, Lombok

---

## Overview

This migration upgrades the SupplyChain Frontend application from Java 8 and Spring Boot 2.7.18 to Java 25 and Spring Boot 4.0+. The application currently runs on an end-of-life Java 8 runtime with Spring Boot 2.x, both of which are prohibited by Acme Corp internal policy. The new architecture will:

- Upgrade the Java runtime from Java 8 (end-of-life for internal use) to Java 25 (latest LTS) per Acme Corp playbook policy
- Upgrade Spring Boot from 2.7.18 to 4.0+, which is required for Java 25 compatibility and mandated for all Spring Boot 2.x/3.x applications
- Migrate from JavaEE (`javax.*`) to Jakarta EE (`jakarta.*`) namespace as included in the Spring Boot 4.0+ upgrade

The migration follows the Acme Corp Refactor strategy for Java supply chain services (Java 8, 11, 17) targeting Java 25 and Spring Boot 4.0+.

---

## Migration Impact Summary

| Application             | Original Service              | New Service               | Authentication | Comments                                      |
|-------------------------|-------------------------------|---------------------------|----------------|-----------------------------------------------|
| supplychain-frontend    | Java 8 / Spring Boot 2.7.18   | Java 25 / Spring Boot 4.0+ | N/A            | Upgrade runtime per Acme Corp playbook policy |

---

## Upgrade Tasks

### Task 001 — Upgrade Spring Boot to 4.0+ and Java to 25

Upgrade the application from Spring Boot 2.7.18 with Java 8 to Spring Boot 4.0+ with Java 25. This task covers the full framework upgrade including Jakarta EE namespace migration (`javax.*` → `jakarta.*`) and all dependency version alignments required for Spring Boot 4.0+ compatibility.

> **Note**: The user requested a Java version upgrade. Because the project uses Spring Boot 2.x, a standalone Java upgrade is not feasible without also upgrading Spring Boot. Per Acme Corp policy, the target is Java 25 with Spring Boot 4.0+. A clarification has been raised to confirm the scope.
