package com.acme.scm.frontend.service;

import com.acme.scm.frontend.dto.InventoryDTO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClient;

import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class InventoryApiService {

    private final RestClient restClient;

    public List<InventoryDTO> getAllInventory() {
        log.debug("Calling backend API: GET /inventory");
        return restClient.get()
                .uri("/inventory")
                .retrieve()
                .body(new ParameterizedTypeReference<>() {});
    }

    public List<InventoryDTO> getLowStockItems() {
        log.debug("Calling backend API: GET /inventory/low-stock");
        return restClient.get()
                .uri("/inventory/low-stock")
                .retrieve()
                .body(new ParameterizedTypeReference<>() {});
    }
}
