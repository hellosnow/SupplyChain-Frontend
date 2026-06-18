# Modernization Plan — SupplyChain-Frontend

| Field             | Value                                                    |
|-------------------|----------------------------------------------------------|
| **Phase**         | Planning                                                 |
| **Timestamp**     | 2026-04-10T12:00:00Z                                    |
| **Assessment**    | `.github/modernize/SupplyChain-Frontend/assessment.yaml` |
| **Tasks File**    | `.github/modernize/SupplyChain-Frontend/tasks.json`      |
| **Total Tasks**   | 14                                                       |
| **Total Effort**  | ~62 story points                                         |
| **Overall Status**| REQUIRES_SIGNIFICANT_CHANGES → Ready for execution       |

---

## Executive Summary

The **SupplyChain-Frontend** is a legacy Java 8 / Spring Boot 2.7 web application using JSP templating,
WAR packaging, and an outdated Dockerfile. It has **12 AppCAT incidents across 6 rules** — 10 mandatory
and 2 optional — totaling **62 story points** of estimated effort.

This plan defines **14 tasks across 5 phases** to modernize the application for Azure deployment,
addressing all mandatory AppCAT violations and critical tech debt. The plan follows a dependency-ordered
execution sequence: Java upgrade first (foundation), then Spring Boot framework upgrade (core), then
code modernization and cloud-readiness in parallel.

**No CVE vulnerabilities** were detected in the current dependency set.

---

## Current State → Target State

| Dimension          | Current (Legacy)                        | Target (Modernized)                        |
|--------------------|-----------------------------------------|--------------------------------------------|
| **Java**           | Java 8 (END OF LIFE)                    | Java 17 LTS                               |
| **Spring Boot**    | 2.7.18 (END OF OSS SUPPORT)            | 3.2.x+ (actively supported)               |
| **Spring Framework** | 5.3.x (END OF OSS SUPPORT)           | 6.1.x (auto-upgraded with Boot 3.x)       |
| **Servlet API**    | javax.servlet                           | jakarta.servlet (Jakarta EE 9+)           |
| **JSTL**           | javax.servlet:jstl                      | jakarta.servlet.jsp.jstl                   |
| **HTTP Client**    | RestTemplate (maintenance mode)         | RestClient (Spring 6.1+)                  |
| **DI Pattern**     | @Autowired field injection              | Constructor injection                      |
| **Docker Build**   | maven:3.8-openjdk-8                     | maven:3.9-eclipse-temurin-17              |
| **Docker Runtime** | tomcat:8.5-jdk8                         | tomcat:10.1-jdk17-temurin                 |
| **URLs**           | Hardcoded http:// localhost             | Externalized, HTTPS, env-var driven       |
| **Health Probes**  | None                                    | Spring Boot Actuator (/health, /readiness) |
| **Logging**        | System.out.println (partial)            | SLF4J structured logging                  |
| **Packaging**      | WAR (external Tomcat)                   | WAR (retained — JSP dependency)           |

---

## Phase 1: Java Version Upgrade (CRITICAL — Foundation)

> **Priority:** CRITICAL | **Effort:** 5 story points | **Tasks:** 2
> **Prerequisite for:** All subsequent phases

Java 8 is end-of-life and a security risk. Java 17 LTS is the minimum requirement
for Spring Boot 3.x. This phase updates the compiler settings and Docker base images.

| Task ID  | Title                                          | Effort | Depends On | AppCAT Rule               |
|----------|------------------------------------------------|--------|------------|---------------------------|
| task-1   | Upgrade Java version from 8 to 17 in pom.xml  | 2 SP   | —          | azure-java-version-02000  |
| task-2   | Update Dockerfile base images to JDK 17        | 3 SP   | task-1     | azure-java-version-02000  |

### task-1: Upgrade Java version from 8 to 17 in pom.xml

**Files:** `pom.xml`

Changes:
```xml
<!-- BEFORE -->
<java.version>8</java.version>
<maven.compiler.source>8</maven.compiler.source>
<maven.compiler.target>8</maven.compiler.target>

<!-- AFTER -->
<java.version>17</java.version>
<maven.compiler.source>17</maven.compiler.source>
<maven.compiler.target>17</maven.compiler.target>
```

**Success Criteria:** `mvn compile` succeeds with Java 17.

### task-2: Update Dockerfile base images to JDK 17

**Files:** `Dockerfile`

Changes:
```dockerfile
# BEFORE
FROM maven:3.8-openjdk-8 AS build
FROM tomcat:8.5-jdk8

# AFTER
FROM maven:3.9-eclipse-temurin-17 AS build
FROM tomcat:10.1-jdk17-temurin
```

**Success Criteria:** `docker build .` completes successfully.

---

## Phase 2: Spring Boot Framework Upgrade (CRITICAL — Core)

> **Priority:** CRITICAL | **Effort:** 16 story points | **Tasks:** 4
> **Depends on:** Phase 1 complete

Spring Boot 2.7.18 is end of OSS support. Upgrading to 3.2.x brings Spring Framework 6.1.x,
Jakarta EE 9+ namespace, and all modern platform features. This is the largest and most
impactful phase.

| Task ID  | Title                                                | Effort | Depends On     | AppCAT Rule                                  |
|----------|------------------------------------------------------|--------|----------------|----------------------------------------------|
| task-3   | Upgrade Spring Boot parent to 3.2.x                 | 5 SP   | task-1         | spring-boot-to-azure-*, spring-framework-*   |
| task-4   | Migrate javax.servlet JSTL dependency to jakarta     | 3 SP   | task-3         | spring-boot-to-azure-*                       |
| task-5   | Update JSP taglib URIs for Jakarta EE                | 3 SP   | task-4         | spring-boot-to-azure-*                       |
| task-6   | Update Spring Boot app configuration for 3.x         | 5 SP   | task-3,4,5     | spring-boot-to-azure-*                       |

### task-3: Upgrade Spring Boot parent to 3.2.x

**Files:** `pom.xml`

```xml
<!-- BEFORE -->
<version>2.7.18</version>

<!-- AFTER -->
<version>3.2.12</version>  <!-- or latest 3.2.x -->
```

### task-4: Migrate javax.servlet JSTL to jakarta namespace

**Files:** `pom.xml`

```xml
<!-- BEFORE -->
<dependency>
    <groupId>javax.servlet</groupId>
    <artifactId>jstl</artifactId>
</dependency>

<!-- AFTER -->
<dependency>
    <groupId>org.glassfish.web</groupId>
    <artifactId>jakarta.servlet.jsp.jstl</artifactId>
</dependency>
<dependency>
    <groupId>jakarta.servlet.jsp.jstl</groupId>
    <artifactId>jakarta.servlet.jsp.jstl-api</artifactId>
</dependency>
```

### task-5: Update JSP taglib URIs for Jakarta EE

**Files:** All 6 JSP files in `src/main/webapp/WEB-INF/jsp/`

```jsp
<%-- BEFORE --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- AFTER --%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
```

### task-6: Update Spring Boot configuration for 3.x

**Files:** `application.yml`, `SupplyChainFrontendApplication.java`

- Review deprecated property keys
- Verify JSP view resolver configuration
- Validate SpringBootServletInitializer extends correctly

**Success Criteria:** `mvn spring-boot:run` starts the application. All JSP pages render correctly.

---

## Phase 3: Code Modernization (HIGH — Best Practices)

> **Priority:** HIGH | **Effort:** 12 story points | **Tasks:** 4
> **Depends on:** Phase 2 complete (task-6)

Replace deprecated patterns and anti-patterns with modern Spring 6.x equivalents.
These tasks can be executed in parallel once Phase 2 is complete.

| Task ID  | Title                                              | Effort | Depends On | Category       |
|----------|----------------------------------------------------|--------|------------|----------------|
| task-7   | Replace RestTemplate with RestClient               | 5 SP   | task-6     | Code modernize |
| task-8   | Replace @Autowired field injection → constructor   | 5 SP   | task-6     | Code quality   |
| task-9   | Replace System.out.println with SLF4J logger       | 1 SP   | task-6     | Logging        |
| task-10  | Update version string from LEGACY to SNAPSHOT       | 1 SP   | task-2     | Housekeeping   |

### task-7: Replace RestTemplate with RestClient

**Files:** `AppConfig.java`, `BackendApiService.java`, `VendorApiService.java`, `InventoryApiService.java`

```java
// BEFORE (AppConfig.java)
@Bean
public RestTemplate restTemplate() {
    return new RestTemplate();
}

// AFTER (AppConfig.java)
@Bean
public RestClient restClient(@Value("${backend.api.url}") String baseUrl) {
    return RestClient.builder()
            .baseUrl(baseUrl)
            .build();
}
```

```java
// BEFORE (Service)
restTemplate.exchange(url, HttpMethod.GET, null,
    new ParameterizedTypeReference<List<PurchaseOrderDTO>>() {}).getBody();

// AFTER (Service)
restClient.get()
    .uri("/orders")
    .retrieve()
    .body(new ParameterizedTypeReference<List<PurchaseOrderDTO>>() {});
```

### task-8: Replace @Autowired with constructor injection

**Files:** All controllers (4) and services (3) — 7 files total

```java
// BEFORE
@Slf4j
@Service
public class BackendApiService {
    @Autowired
    private RestTemplate restTemplate;
    @Value("${backend.api.url}")
    private String backendApiUrl;
}

// AFTER
@Slf4j
@Service
@RequiredArgsConstructor
public class BackendApiService {
    private final RestClient restClient;
}
```

### task-9: Replace System.out.println with SLF4J

**Files:** `SupplyChainFrontendApplication.java`

```java
// BEFORE
System.out.println("Supply Chain Frontend Started");
System.out.println("Access at: http://localhost:8081");

// AFTER
@Slf4j
...
log.info("Supply Chain Frontend Started");
log.info("Application is ready");
```

---

## Phase 4: Cloud-Readiness Remediation (HIGH — Azure)

> **Priority:** HIGH | **Effort:** 9 story points | **Tasks:** 3
> **Depends on:** Phase 2 complete (task-6)
> **Resolves:** All remaining AppCAT mandatory violations

These tasks resolve the remaining AppCAT cloud-readiness violations required for
Azure AKS, App Service, and Container Apps deployment targets.

| Task ID  | Title                                                    | Effort | Depends On    | AppCAT Rule                       |
|----------|----------------------------------------------------------|--------|---------------|-----------------------------------|
| task-11  | Externalize hardcoded backend URL via env vars           | 3 SP   | task-6        | hardcoded-urls-00001              |
| task-12  | Switch HTTP → HTTPS for all service communication        | 3 SP   | task-9,11     | unsecure-network-protocol-00000, localhost-http-00001 |
| task-13  | Add Spring Boot Actuator for health probes               | 3 SP   | task-6        | (tech debt: no-health-checks)     |

### task-11: Externalize backend URL

**Files:** `application.yml`

```yaml
# BEFORE
backend:
  api:
    url: http://backend:8080/api

# AFTER
backend:
  api:
    url: ${BACKEND_API_URL:https://backend:8080/api}
```

### task-12: Switch to HTTPS

**Files:** `application.yml`, `SupplyChainFrontendApplication.java`

- Change default URL protocol to `https://`
- Remove `http://localhost:8081` reference from startup banner

### task-13: Add Spring Boot Actuator

**Files:** `pom.xml`, `application.yml`

```xml
<!-- pom.xml -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-actuator</artifactId>
</dependency>
```

```yaml
# application.yml
management:
  endpoints:
    web:
      exposure:
        include: health,info
  endpoint:
    health:
      probes:
        enabled: true
      show-details: when-authorized
```

**Success Criteria:** `GET /actuator/health` returns `{"status":"UP"}`.

---

## Phase 5: Operational Hardening (MEDIUM — Future)

> **Priority:** MEDIUM | **Effort:** 8 story points | **Tasks:** 1
> **Depends on:** Phases 1-4 complete

Optional improvements for production-grade Azure deployment.

| Task ID  | Title                                                    | Effort | Depends On       |
|----------|----------------------------------------------------------|--------|------------------|
| task-14  | Add Azure deployment manifests and production Dockerfile | 8 SP   | task-2,12,13     |

### task-14: Azure deployment configuration

Create Kubernetes/Container Apps deployment manifests with:
- Health check probe configuration pointing to `/actuator/health`
- Environment variable injection for `BACKEND_API_URL`
- Resource limits and auto-scaling rules
- Non-root user in Dockerfile
- Optimized multi-stage Docker build

---

## Dependency Graph

```
Phase 1 (Foundation)
  task-1: Java 8 → 17 (pom.xml)
    ├─► task-2: Dockerfile JDK 17
    │     └─► task-10: Version string update
    │     └─► task-14: Azure deploy config
    └─► task-3: Spring Boot 2.7 → 3.2
          └─► task-4: javax.servlet → jakarta JSTL
                └─► task-5: JSP taglib URIs
                      └─► task-6: Spring Boot 3.x config validation
                            ├─► task-7: RestTemplate → RestClient
                            ├─► task-8: @Autowired → constructor injection
                            ├─► task-9: System.out → SLF4J
                            │     └─► task-12: HTTP → HTTPS
                            ├─► task-11: Externalize URLs
                            │     └─► task-12: HTTP → HTTPS
                            └─► task-13: Add Actuator
                                  └─► task-14: Azure deploy config
```

---

## AppCAT Violation Resolution Matrix

| AppCAT Rule ID                                 | Severity  | Incidents | Resolved By    |
|------------------------------------------------|-----------|-----------|----------------|
| azure-java-version-02000                       | mandatory | 3         | task-1, task-2 |
| spring-boot-to-azure-spring-boot-version-01000 | mandatory | 3         | task-3 → task-6|
| spring-framework-version-01000                 | mandatory | 1         | task-3 (auto)  |
| localhost-http-00001                           | mandatory | 1         | task-12        |
| hardcoded-urls-00001                           | optional  | 2         | task-11        |
| unsecure-network-protocol-00000                | mandatory | 2         | task-12        |
| **Total**                                      |           | **12**    | **All resolved**|

---

## Risk Assessment

| Risk                                    | Impact | Mitigation                                                    |
|-----------------------------------------|--------|---------------------------------------------------------------|
| JSP incompatibility with Jakarta EE     | HIGH   | Test JSP rendering after each Phase 2 task. Rollback path via git. |
| Spring Boot 3.x property changes        | MEDIUM | Use spring-boot-properties-migrator dependency during transition. |
| RestClient API differences              | LOW    | RestClient is a direct synchronous replacement — API is similar. |
| WAR packaging retained (JSP dependency) | LOW    | Acceptable for now. WAR→JAR requires JSP→Thymeleaf migration (separate project). |

---

## Excluded from This Plan (Future Considerations)

These items were identified in the assessment but are **out of scope** for this modernization plan:

1. **WAR → JAR conversion** — Requires migrating JSP → Thymeleaf (or frontend SPA). Large effort, separate initiative.
2. **Spring Security / Azure AD (Entra ID)** — Authentication integration is a separate security workstream.
3. **JSP → Modern frontend** — Consider React/Angular/Vue with REST API. Separate project.
4. **Azure App Configuration** — Can replace environment variables for centralized config. Post-migration enhancement.

---

## Execution Notes

1. **Execute phases sequentially** — Phase 1 before Phase 2, Phase 2 before Phases 3-4.
2. **Phases 3 and 4 can run in parallel** — Code modernization and cloud-readiness are independent.
3. **Build verification after each task** — Run `mvn clean compile` (minimum) or `mvn verify` after each change.
4. **Git commit after each task** — Enable easy rollback if issues arise.
5. **Docker build after Phase 1** — Verify containerized build works before proceeding.
6. **Full integration test after Phase 2** — Start the app and verify all JSP pages render correctly.
