# Modernization Summary - 001-upgrade-spring-boot-4-java-25

## Completed changes
- Upgraded Spring Boot parent from `2.7.18` to `4.0.0`.
- Upgraded Java target from `8` to `25` (`java.version` + compiler release).
- Migrated JSTL dependency from `javax.servlet:jstl` to `org.glassfish.web:jakarta.servlet.jsp.jstl` to align with Jakarta EE.
- Updated embedded servlet container packaging for executable deployment (Tomcat/Jasper no longer `provided`).
- Added explicit Lombok annotation processor configuration for JDK 25 compilation.
- Updated Docker build/runtime images to:
  - Build: `mcr.microsoft.com/openjdk/jdk:25-ubuntu`
  - Runtime: `mcr.microsoft.com/openjdk/jdk:25-distroless`
- Updated application/README version references to match Java 25 and Spring Boot 4.0+.

## Validation
- Baseline tests (before changes): `mvn -q test` ✅
- Post-upgrade tests (JDK 25): `mvn -q test` ✅
- Post-upgrade build (JDK 25): `mvn -q -DskipTests package` ✅
- Search validation for old references (`javax.*`, Java 8, Spring Boot 2.7.18) in source/build/config/docs updated by task: no remaining matches ✅
