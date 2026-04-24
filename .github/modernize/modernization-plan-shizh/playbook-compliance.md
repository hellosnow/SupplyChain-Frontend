# Playbook Compliance Report

**Plan**: modernization-plan-shizh  
**Project**: supplychain-frontend  
**Playbooks evaluated**: charter.md · targets.md · policies.md

---

## Playbook Compliance

| Playbook | Rule | Status | Task |
|----------|------|--------|------|
| charter.md | Java 8, 11, and 17 are end-of-life; must upgrade | ✅ COVERED | 001 |
| charter.md | Spring Boot 2.x and 3.x must be upgraded | ✅ COVERED | 001 |
| charter.md | Strategy: Replatform all Java supply chain services to Azure Container Apps | ✅ COVERED | 007, 008 |
| charter.md | Use `com.acme.mesh.ServiceMesh` for service-to-service communication | ✅ COVERED | 002 |
| charter.md | Use `com.acme.logging.InternalLogger` as logging framework | ✅ COVERED | 003 |
| charter.md | Use `com.acme.commons.Result<T>` pattern for error handling | ❌ NOT COVERED | - |
| targets.md | Java target version: 25 | ✅ COVERED | 001 |
| targets.md | Spring Boot target version: 4.0+ | ✅ COVERED | 001 |
| targets.md | Maven target version: 3.9+ | ⚠️ PARTIAL | 001 |
| targets.md | Default compute platform: Azure Container Apps | ✅ COVERED | 008 |
| targets.md | ServiceMesh SDK for all service-to-service communication | ✅ COVERED | 002 |
| targets.md | Azure Key Vault for credentials, API keys, connection strings | ✅ COVERED | 005 |
| targets.md | Azure AD (OAuth 2.0 / OIDC) for user-facing authentication | ✅ COVERED | 004 |
| targets.md | Managed Identity for service-to-service authentication | ✅ COVERED | 002, 005 |
| targets.md | Replace RestTemplate → ServiceMesh SDK | ✅ COVERED | 002 |
| targets.md | Replace WebClient → ServiceMesh SDK | ✅ N/A | - |
| targets.md | Replace FeignClient → ServiceMesh SDK | ✅ N/A | - |
| targets.md | Replace OkHttp → ServiceMesh SDK | ✅ N/A | - |
| targets.md | Replace Apache HttpClient → ServiceMesh SDK | ✅ N/A | - |
| targets.md | Replace SLF4J / @Slf4j / LoggerFactory → InternalLogger | ✅ COVERED | 003 |
| targets.md | Replace Log4j → InternalLogger | ✅ N/A | - |
| targets.md | Replace Logback → InternalLogger | ✅ N/A | - |
| targets.md | Replace `java.util.logging` → InternalLogger | ✅ N/A | - |
| targets.md | Replace `System.out.println` / `System.err.println` → InternalLogger | ✅ COVERED | 003 |
| targets.md | Replace exception-based error handling → `Result<T>` pattern | ❌ NOT COVERED | - |
| targets.md | Replace JAAS authentication → Azure AD | ✅ N/A | - |
| targets.md | Replace LDAP authentication → Azure AD | ✅ N/A | - |
| targets.md | Container build image: `mcr.microsoft.com/openjdk/jdk:25-ubuntu` | ✅ COVERED | 007 |
| targets.md | Container runtime image: `mcr.microsoft.com/openjdk/jdk:25-distroless` | ✅ COVERED | 007 |
| policies.md | User-facing authentication must use Azure AD with OAuth 2.0 / OIDC | ✅ COVERED | 004 |
| policies.md | Service-to-service authentication must use Managed Identity | ✅ COVERED | 002, 005 |
| policies.md | Legacy JAAS and LDAP must be migrated | ✅ N/A | - |
| policies.md | Sensitive values must be stored in Azure Key Vault | ✅ COVERED | 005 |
| policies.md | Access secrets via Spring Cloud Azure Key Vault starter or Managed Identity | ✅ COVERED | 005 |
| policies.md | All service-to-service communication through ServiceMesh SDK (mTLS, circuit breaking) | ✅ COVERED | 002 |
| policies.md | All traffic must use TLS 1.2+ | ❌ NOT COVERED | - |
| policies.md | Data at rest must be encrypted (service-managed keys) | ❌ NOT COVERED | - |
| policies.md | Restricted data requires customer-managed encryption keys | ✅ N/A | - |
| policies.md | SOC 2 controls compliance | ⚠️ PARTIAL | 004, 005, 006 |
| policies.md | PCI-DSS (Payments portfolio only) | ✅ N/A | - |
| policies.md | Prohibited: RestTemplate | ✅ COVERED | 002 |
| policies.md | Prohibited: WebClient | ✅ N/A | - |
| policies.md | Prohibited: FeignClient | ✅ N/A | - |
| policies.md | Prohibited: OkHttp | ✅ N/A | - |
| policies.md | Prohibited: Apache HttpClient | ✅ N/A | - |
| policies.md | Prohibited: SLF4J (`@Slf4j`, `LoggerFactory`) | ✅ COVERED | 003 |
| policies.md | Prohibited: Log4j (any version) | ✅ N/A | - |
| policies.md | Prohibited: Logback (direct usage) | ✅ N/A | - |
| policies.md | Prohibited: `java.util.logging` | ✅ N/A | - |
| policies.md | Prohibited: `System.out.println` / `System.err.println` | ✅ COVERED | 003 |
| policies.md | Prohibited: JAAS | ✅ N/A | - |
| policies.md | Prohibited: LDAP | ✅ N/A | - |
| policies.md | Prohibited pattern: Throwing exceptions for business logic flow control | ❌ NOT COVERED | - |
| policies.md | Prohibited pattern: `try/catch` blocks for flow control | ❌ NOT COVERED | - |
| policies.md | Prohibited pattern: `@ControllerAdvice` for business exceptions | ❌ NOT COVERED | - |
| policies.md | Prohibited pattern: Hardcoded credentials in config files or source code | ✅ COVERED | 005 |
| policies.md | Required element: Azure Key Vault for secrets management | ✅ COVERED | 005 |
| policies.md | Required element: InternalLogger as sole logging framework | ✅ COVERED | 003 |
| policies.md | Coding standard: Use `Result<T>` for all error handling | ❌ NOT COVERED | - |
| policies.md | Coding standard: Use ServiceMesh SDK for all service-to-service communication | ✅ COVERED | 002 |
| policies.md | Coding standard: Use InternalLogger for all logging | ✅ COVERED | 003 |
| policies.md | Coding standard: Externalize config; use Azure Key Vault for sensitive values | ✅ COVERED | 005 |

---

**COVERED: 33/58  ·  NOT COVERED: 6/58  ·  PARTIAL: 2/58  ·  N/A (not applicable): 17/58**

---

## Gaps Requiring Attention

### ❌ NOT COVERED — Action Required

| # | Rule Source | Gap | Recommended Action |
|---|-------------|-----|--------------------|
| 1 | charter.md, targets.md, policies.md | No task to migrate exception-based error handling and `try/catch` flow control to `Result<T>` (`com.acme.commons.Result`) | Add a transform task to replace exception-based business logic with the `Result<T>` pattern across all controllers and services |
| 2 | policies.md | No task addresses `@ControllerAdvice` global exception handlers for business exceptions | Include in the `Result<T>` migration task above |
| 3 | policies.md | No explicit task to enforce TLS 1.2+ for all traffic | Add a task or note that TLS 1.2+ is enforced at the ACA infrastructure level via the deployment task (008), and verify ServiceMesh SDK enforces mTLS end-to-end |
| 4 | policies.md | No explicit task for data-at-rest encryption | Add a note in the deployment/infrastructure task (008) to confirm Azure-managed encryption is enabled for all Azure services used |

### ⚠️ PARTIAL — Review Recommended

| # | Rule Source | Gap | Recommended Action |
|---|-------------|-----|--------------------|
| 1 | targets.md | Maven 3.9+ target not explicitly stated in task 001 requirements | Update task 001 requirements to explicitly include upgrading Maven wrapper / enforcer to 3.9+ |
| 2 | policies.md | SOC 2 compliance is not comprehensively addressed; tasks 004, 005, 006 partially satisfy controls | Consider adding audit logging, access review, and monitoring requirements to deployment task 008 |

### ✅ N/A — Not Applicable to This Project

The following rules were evaluated but do not apply because the listed technologies are not present in the `supplychain-frontend` codebase:

- WebClient, FeignClient, OkHttp, Apache HttpClient (not in pom.xml)
- Log4j, Logback, `java.util.logging` (not used)
- JAAS, LDAP authentication (not implemented)
- PCI-DSS (not a Payments portfolio application)
- Restricted data / customer-managed encryption keys (no indication of Restricted data classification)
