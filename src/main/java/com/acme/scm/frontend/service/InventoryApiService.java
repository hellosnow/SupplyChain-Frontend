package com.acme.scm.frontend.service;

import com.acme.scm.frontend.dto.InventoryDTO;
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
public class InventoryApiService {

    @Autowired
    private RestTemplate restTemplate;

    @Value("${backend.api.url}")
    private String backendApiUrl;

    public List<InventoryDTO> getAllInventory() {
        String url = backendApiUrl + "/inventory";
        log.debug("Calling backend API: GET {}", url);

        return restTemplate.exchange(
                url,
                HttpMethod.GET,
                null,
                new ParameterizedTypeReference<List<InventoryDTO>>() {}
        ).getBody();
    }

    public List<InventoryDTO> getLowStockItems() {
        String url = backendApiUrl + "/inventory/low-stock";
        log.debug("Calling backend API: GET {}", url);

        return restTemplate.exchange(
                url,
                HttpMethod.GET,
                null,
                new ParameterizedTypeReference<List<InventoryDTO>>() {}
        ).getBody();
    }
}
