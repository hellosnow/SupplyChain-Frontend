package com.acme.scm.frontend;

import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;

@Slf4j
@SpringBootApplication
public class SupplyChainFrontendApplication extends SpringBootServletInitializer {

    public static void main(String[] args) {
        SpringApplication.run(SupplyChainFrontendApplication.class, args);
        log.info("========================================");
        log.info("Supply Chain Frontend Started");
        log.info("Access at: http://localhost:8081");
        log.info("========================================");
    }
}
