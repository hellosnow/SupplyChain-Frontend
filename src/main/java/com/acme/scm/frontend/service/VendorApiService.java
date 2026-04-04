package com.acme.scm.frontend.service;

import com.acme.scm.frontend.dto.VendorDTO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpMethod;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.List;

@Slf4j
@Service
public class VendorApiService {

    @Autowired
    private RestTemplate restTemplate;

    @Value("${backend.api.url}")
    private String backendApiUrl;

    public List<VendorDTO> getAllVendors() {
        String url = backendApiUrl + "/vendors";
        log.debug("Calling backend API: GET {}", url);

        return restTemplate.exchange(
                url,
                HttpMethod.GET,
                null,
                new ParameterizedTypeReference<List<VendorDTO>>() {}
        ).getBody();
    }
}
