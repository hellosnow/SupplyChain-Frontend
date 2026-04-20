# Modernization Plan: modernization-plan-0420

**Project**: SupplyChain Frontend

---

## Technical Framework

- **Language**: Java 8
- **Framework**: Spring Boot 2.7.18
- **Build Tool**: Maven
- **Database**: None (frontend web application)
- **Key Dependencies**: Spring MVC, RestTemplate, Tomcat 8.5 (external),
  JSP/JSTL, Lombok (@Slf4j), SLF4J/Logback

---

## Overview

This migration upgrades and modernizes the SupplyChain Frontend
application for deployment on Azure Container Apps.
The application currently runs on Java 8 with Spring Boot 2.7.18,
uses JSP views, and deploys as a WAR on external Tomcat 8.5.

The modernization will:

- Upgrade to Java 25 and Spring Boot 4.0+ per organizational
  playbook targets
- Replace prohibited technologies (RestTemplate, SLF4J,
  exception-based flow control) with approved alternatives
  per playbook policies
- Validate and fix all CVE vulnerabilities in dependencies
- Update containerization for Azure Container Apps deployment
  using Microsoft OpenJDK base images

The migration follows a phased approach: upgrade first, then
apply policy-mandated transforms, remediate security issues,
and finally update containerization.

---

## Migration Impact Summary

| Application          | Original Service       | New Azure Service        | Authentication   | Comments               |
|----------------------|------------------------|--------------------------|------------------|------------------------|
| SupplyChain Frontend | RestTemplate           | ServiceMesh SDK          | Managed Identity | Playbook policy        |
| SupplyChain Frontend | SLF4J / @Slf4j         | InternalLogger           | N/A              | Playbook policy        |
| SupplyChain Frontend | Exception flow control | Result\<T\> pattern      | N/A              | Playbook policy        |
| SupplyChain Frontend | Tomcat 8.5 / WAR       | Azure Container Apps     | N/A              | Replatform to ACA      |

---

## Upgrade

Upgrade the application from Java 8 / Spring Boot 2.7.18 to
Java 25 / Spring Boot 4.0+ including Jakarta EE namespace
migration (javax.* → jakarta.*), Spring Framework upgrade,
and WAR-to-JAR packaging conversion.

**Skills**:
- Skill Name: create-java-upgrade-plan
  - Skill Location: project

---

## Transform Tasks

### Migrate RestTemplate to ServiceMesh SDK

Replace all RestTemplate usage in BackendApiService,
InventoryApiService, and VendorApiService with the ServiceMesh
SDK (`com.acme.mesh.ServiceMesh`) for all service-to-service
communication, per playbook policy.

### Migrate SLF4J to InternalLogger

Replace all SLF4J / Lombok @Slf4j logging with InternalLogger
(`com.acme.logging.InternalLogger`) across all controllers and
services, per playbook policy.

### Migrate Exception Handling to Result\<T\> Pattern

Replace try-catch flow control patterns with Result\<T\>
(`com.acme.commons.Result`) pattern across all controllers
and services, per playbook policy.

---

## Security Compliance

**Description**: Validate and fix all CVE vulnerabilities in
project dependencies.

**Requirements**: All CVE vulnerabilities must be resolved
after upgrade and transform tasks are complete.

**Environment Configuration**:
  Runtime: Java 25, Spring Boot 4.0+, Maven 3.9+

**App Scope**: Project root (.)

**Skills**:
- Skill Name: validate-cves-and-fix
  - Skill Location: builtin

---

## Containerization

Update the existing Dockerfile to use the upgraded Java 25
runtime with Microsoft OpenJDK base images
(`mcr.microsoft.com/openjdk/jdk:25-ubuntu` for build,
`mcr.microsoft.com/openjdk/jdk:25-distroless` for runtime),
multi-stage build, and JAR packaging for Azure Container Apps
deployment.
