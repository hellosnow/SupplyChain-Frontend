package com.acme.scm.frontend.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestClient;

@Configuration
public class AppConfig {

    @Value("${backend.api.url}")
    private String backendApiUrl;

    @Bean
    public RestClient restClient() {
        return RestClient.builder()
                .baseUrl(backendApiUrl)
                .build();
    }
}
