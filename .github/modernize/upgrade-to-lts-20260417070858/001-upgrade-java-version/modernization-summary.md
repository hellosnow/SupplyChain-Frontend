# Modernization Summary: 001-upgrade-java-version

## Task Description
Upgrade JDK from Java 8 to Java 25.

## Changes Made

### 1. `pom.xml`
- Updated `java.version` from `8` → `25`
- Updated `maven.compiler.source` from `8` → `25`
- Updated `maven.compiler.target` from `8` → `25`
- Added `maven.compiler.release` set to `25` (modern compiler flag)
- Upgraded `lombok.version` to `1.18.38` (required for Java 25 javac internal API compatibility — earlier versions failed with `TypeTag::UNKNOWN` error)
- Added explicit `maven-compiler-plugin` configuration with `annotationProcessorPaths` for Lombok to ensure annotation processing works correctly under Java 25

### 2. `Dockerfile`
- Build stage: Updated base image from `maven:3.8-openjdk-8` → `maven:3.9-eclipse-temurin-25`
- Runtime stage: Updated base image from `tomcat:8.5-jdk8` → `tomcat:9.0-jdk25-temurin`
- Removed the `# TECH DEBT: Uses old Java 8 base image` comment

## Issues Resolved
- **Lombok incompatibility with Java 25**: The bundled Lombok version (managed by Spring Boot 2.7.18 parent at 1.18.26) fails to process annotations under Java 25. The fix was to override `lombok.version` to `1.18.38` and explicitly declare Lombok in the compiler plugin's `annotationProcessorPaths`.

## Verification
- ✅ Build passes (`mvn clean package` with JDK 25)
- ✅ All tests pass (no test failures)
- ✅ Compiler source, target, and release all set to `25`
- ✅ Dockerfile updated to use JDK 25 base images
- ✅ No old Java 8 references remain in build configuration
