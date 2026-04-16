package com.acme.scm.frontend;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;

/**
 * Supply Chain Management System - Frontend Web UI
 *
 * TECH DEBT SUMMARY:
 * - Runtime aligned to Java 25
 * - Framework aligned to Spring Boot 4.x
 * - JSP (old templating, could modernize to React/Angular)
 * - RestTemplate usage (should use ServiceMesh SDK)
 * - SLF4J logging (should use InternalLogger)
 * - Session-based auth (should migrate to Azure AD with OAuth 2.0)
 */
@SpringBootApplication
public class SupplyChainFrontendApplication extends SpringBootServletInitializer {

    public static void main(String[] args) {
        SpringApplication.run(SupplyChainFrontendApplication.class, args);
        System.out.println("========================================");
        System.out.println("Supply Chain Frontend Started");
        System.out.println("Access at: http://localhost:8081");
        System.out.println("========================================");
    }
}
