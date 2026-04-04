package com.acme.scm.frontend.service;

import com.acme.scm.frontend.dto.PurchaseOrderDTO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpMethod;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.List;

/**
 * TECH DEBT:
 * - Uses RestTemplate (bypasses mesh, violates guardrails)
 * - Uses SLF4J instead of InternalLogger
 */
@Slf4j // TECH DEBT: Should use InternalLogger
@Service
public class BackendApiService {

    @Autowired
    private RestTemplate restTemplate; // TECH DEBT: Should use ServiceMesh SDK

    @Value("${backend.api.url}")
    private String backendApiUrl;

    public List<PurchaseOrderDTO> getAllOrders() {
        String url = backendApiUrl + "/orders";
        log.debug("Calling backend API: GET {}", url);

        // TECH DEBT: RestTemplate bypasses service mesh
        return restTemplate.exchange(
                url,
                HttpMethod.GET,
                null,
                new ParameterizedTypeReference<List<PurchaseOrderDTO>>() {}
        ).getBody();
    }

    public List<PurchaseOrderDTO> getPendingOrders() {
        String url = backendApiUrl + "/orders/pending";
        log.debug("Calling backend API: GET {}", url);

        return restTemplate.exchange(
                url,
                HttpMethod.GET,
                null,
                new ParameterizedTypeReference<List<PurchaseOrderDTO>>() {}
        ).getBody();
    }

    public PurchaseOrderDTO getOrderByNumber(String orderNumber) {
        String url = backendApiUrl + "/orders/" + orderNumber;
        log.debug("Calling backend API: GET {}", url);

        return restTemplate.getForObject(url, PurchaseOrderDTO.class);
    }

    public PurchaseOrderDTO createOrder(PurchaseOrderDTO order) {
        String url = backendApiUrl + "/orders";
        log.debug("Calling backend API: POST {}", url);

        return restTemplate.postForObject(url, order, PurchaseOrderDTO.class);
    }
}
