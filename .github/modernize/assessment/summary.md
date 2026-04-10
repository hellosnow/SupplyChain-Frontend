# Modernization Assessment Summary

**Target Azure Services**: Azure Kubernetes Service, Azure App Service, Azure Container Apps

## Overall Statistics

**Total Applications**: 1

**Name: supplychain-frontend**
- Mandatory: 5 issues
- Potential: 0 issues
- Optional: 2 issues

> **Severity Levels Explained:**
> - **Mandatory**: The issue has to be resolved for the migration to be successful.
> - **Potential**: This issue may be blocking in some situations but not in others. These issues should be reviewed to determine whether a change is required or not.
> - **Optional**: The issue discovered is real issue fixing which could improve the app after migration, however it is not blocking.

## Applications Profile

### Name: supplychain-frontend
- **JDK Version**: 8
- **Frameworks**: Spring Boot, Spring
- **Languages**: Java
- **Build Tools**: Maven

**Key Findings**:
- **Mandatory Issues (10 locations)**:
  - <!--ruleid=azure-java-version-02000-->Legacy Java version (3 locations found)
  - <!--ruleid=spring-boot-to-azure-spring-boot-version-01000-->Spring Boot Version is End of OSS Support (3 locations found)
  - <!--ruleid=spring-framework-version-01000-->Spring Framework Version End of OSS Support (1 location found)
  - <!--ruleid=localhost-http-00001-->Local HTTP Calls (1 location found)
  - <!--ruleid=unsecure-network-protocol-00000-->Use of unsecured network protocols or URI libraries (2 locations found)
- **Optional Issues (3 locations)**:
  - <!--ruleid=jakarta-ee-version-01000-->Jakarta EE version not latest stable (1 location found)
  - <!--ruleid=hardcoded-urls-00001-->Avoid using hardcoded URLs (HTTP protocol) in source code (2 locations found)

## Next Steps

For comprehensive migration guidance and best practices, visit:
- [GitHub Copilot modernization](https://aka.ms/ghcp-appmod)

Have questions or suggestions? [Share your feedback](https://aka.ms/ghcp-appmod/feedback)
