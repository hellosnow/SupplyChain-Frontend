package com.acme.scm.frontend.service;

import com.acme.scm.frontend.dto.VendorDTO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClient;

import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class VendorApiService {

    private final RestClient restClient;

    public List<VendorDTO> getAllVendors() {
        log.debug("Calling backend API: GET /vendors");
        return restClient.get()
                .uri("/vendors")
                .retrieve()
                .body(new ParameterizedTypeReference<>() {});
    }
}
