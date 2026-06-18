package com.acme.scm.frontend.service;

import com.acme.scm.frontend.dto.PurchaseOrderDTO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClient;

import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class BackendApiService {

    private final RestClient restClient;

    public List<PurchaseOrderDTO> getAllOrders() {
        log.debug("Calling backend API: GET /orders");
        return restClient.get()
                .uri("/orders")
                .retrieve()
                .body(new ParameterizedTypeReference<>() {});
    }

    public List<PurchaseOrderDTO> getPendingOrders() {
        log.debug("Calling backend API: GET /orders/pending");
        return restClient.get()
                .uri("/orders/pending")
                .retrieve()
                .body(new ParameterizedTypeReference<>() {});
    }

    public PurchaseOrderDTO getOrderByNumber(String orderNumber) {
        log.debug("Calling backend API: GET /orders/{}", orderNumber);
        return restClient.get()
                .uri("/orders/{orderNumber}", orderNumber)
                .retrieve()
                .body(PurchaseOrderDTO.class);
    }

    public PurchaseOrderDTO createOrder(PurchaseOrderDTO order) {
        log.debug("Calling backend API: POST /orders");
        return restClient.post()
                .uri("/orders")
                .body(order)
                .retrieve()
                .body(PurchaseOrderDTO.class);
    }
}
