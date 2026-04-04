package com.acme.scm.frontend.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class DashboardStatsDTO {
    private int pendingOrdersCount;
    private int lowStockItemsCount;
    private int activeVendorsCount;
    private BigDecimal monthlyPurchaseTotal;
}
