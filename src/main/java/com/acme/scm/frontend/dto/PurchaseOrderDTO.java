package com.acme.scm.frontend.dto;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class PurchaseOrderDTO {
    private Long id;
    private String orderNumber;
    private Long vendorId;
    private String vendorName;
    private BigDecimal totalAmount;
    private String status;
    private String requestedBy;
    private String approvedBy;
    private LocalDateTime requestedDate;
    private LocalDateTime approvedDate;
    private String description;
    private LocalDateTime createdAt;
}
