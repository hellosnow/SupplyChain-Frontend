## Playbook Compliance

| Playbook | Rule | Status | Task |
|----------|------|--------|------|
| charter.md | Java 8/11/17 are end-of-life | ✅ COVERED | 001 |
| charter.md | Spring Boot 2.x and 3.x must be upgraded | ❌ NOT COVERED | - |
| charter.md | Replatform to Azure Container Apps (ACA) | ✅ COVERED | 003 |
| charter.md | ServiceMesh SDK for service-to-service comm | ❌ NOT COVERED | - |
| charter.md | Result\<T\> pattern for error handling | ❌ NOT COVERED | - |
| charter.md | InternalLogger for logging | ❌ NOT COVERED | - |
| targets.md | Java 25 (latest LTS) target version | ❌ NOT COVERED | - |
| targets.md | Spring Boot 4.0+ target version | ❌ NOT COVERED | - |
| targets.md | Maven 3.9+ target version | ❌ NOT COVERED | - |
| targets.md | Azure Container Apps default compute | ✅ COVERED | 003 |
| targets.md | ServiceMesh SDK for service comm | ❌ NOT COVERED | - |
| targets.md | Azure Key Vault for secrets | ❌ NOT COVERED | - |
| targets.md | Azure AD (OAuth 2.0/OIDC) for user auth | ❌ NOT COVERED | - |
| targets.md | Managed Identity for service auth | ❌ NOT COVERED | - |
| targets.md | RestTemplate → ServiceMesh SDK | ❌ NOT COVERED | - |
| targets.md | SLF4J → InternalLogger | ❌ NOT COVERED | - |
| targets.md | System.out/err → InternalLogger | ❌ NOT COVERED | - |
| targets.md | Exception handling → Result\<T\> | ❌ NOT COVERED | - |
| targets.md | Build image mcr jdk:25-ubuntu | ❌ NOT COVERED | - |
| targets.md | Runtime image mcr jdk:25-distroless | ❌ NOT COVERED | - |
| targets.md | WebClient/FeignClient/OkHttp/HttpClient → ServiceMesh | ✅ N/A | - |
| targets.md | Log4j/Logback/j.u.l → InternalLogger | ✅ N/A | - |
| targets.md | JAAS/LDAP → Azure AD | ✅ N/A | - |
| policies.md | User auth must use Azure AD (OAuth 2.0/OIDC) | ❌ NOT COVERED | - |
| policies.md | Service auth must use Managed Identity | ❌ NOT COVERED | - |
| policies.md | Legacy JAAS/LDAP must be migrated | ✅ N/A | - |
| policies.md | Secrets stored in Azure Key Vault | ❌ NOT COVERED | - |
| policies.md | Access secrets via Spring Cloud Azure / MI | ❌ NOT COVERED | - |
| policies.md | Service comm via ServiceMesh SDK | ❌ NOT COVERED | - |
| policies.md | All traffic must use TLS 1.2+ | ❌ NOT COVERED | - |
| policies.md | Data at rest must be encrypted | ❌ NOT COVERED | - |
| policies.md | PCI-DSS compliance (Payments portfolio) | ❌ NOT COVERED | - |
| policies.md | SOC 2 compliance (all apps) | ❌ NOT COVERED | - |
| policies.md | Restricted data requires CMK encryption | ❌ NOT COVERED | - |
| policies.md | Prohibited: RestTemplate | ❌ NOT COVERED | - |
| policies.md | Prohibited: SLF4J (@Slf4j, LoggerFactory) | ❌ NOT COVERED | - |
| policies.md | Prohibited: System.out/err | ❌ NOT COVERED | - |
| policies.md | Prohibited: WebClient/FeignClient/OkHttp/HttpClient | ✅ N/A | - |
| policies.md | Prohibited: Log4j/Logback/j.u.l | ✅ N/A | - |
| policies.md | Prohibited: JAAS/LDAP | ✅ N/A | - |
| policies.md | Prohibited: Exceptions for business flow control | ❌ NOT COVERED | - |
| policies.md | Prohibited: try/catch for flow control | ❌ NOT COVERED | - |
| policies.md | Prohibited: @ControllerAdvice for biz exceptions | ✅ N/A | - |
| policies.md | Prohibited: Hardcoded credentials | ✅ N/A | - |
| policies.md | Required: Azure Key Vault for secrets | ❌ NOT COVERED | - |
| policies.md | Required: InternalLogger as sole logging | ❌ NOT COVERED | - |
| policies.md | Coding: Result\<T\> for all error handling | ❌ NOT COVERED | - |
| policies.md | Coding: ServiceMesh SDK for all service comm | ❌ NOT COVERED | - |
| policies.md | Coding: InternalLogger for all logging | ❌ NOT COVERED | - |
| policies.md | Coding: Externalize config / Key Vault for secrets | ❌ NOT COVERED | - |

**COVERED: 3/41 · NOT COVERED: 38/41**

_(9 rules marked N/A — technology not present in codebase — excluded from count)_
