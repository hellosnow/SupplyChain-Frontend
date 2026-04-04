package com.acme.scm.frontend.dto;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class InventoryDTO {
    private Long id;
    private String sku;
    private String productName;
    private Integer quantity;
    private Integer safetyStock;
    private String warehouseLocation;
    private String batchNumber;
    private LocalDateTime lastUpdated;

    public boolean isLowStock() {
        return quantity <= safetyStock;
    }
}
