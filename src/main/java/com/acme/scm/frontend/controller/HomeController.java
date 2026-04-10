package com.acme.scm.frontend.controller;

import com.acme.scm.frontend.dto.PurchaseOrderDTO;
import com.acme.scm.frontend.service.BackendApiService;
import com.acme.scm.frontend.service.InventoryApiService;
import com.acme.scm.frontend.service.VendorApiService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.time.LocalDateTime;
import java.util.List;

@Slf4j
@Controller
@RequiredArgsConstructor
public class HomeController {

    private final BackendApiService backendApiService;
    private final InventoryApiService inventoryApiService;
    private final VendorApiService vendorApiService;

    @GetMapping("/")
    public String home(Model model) {
        log.info("Loading home page");

        try {
            // Get dashboard statistics
            int pendingOrdersCount = backendApiService.getPendingOrders().size();
            int lowStockItemsCount = inventoryApiService.getLowStockItems().size();
            int activeVendorsCount = (int) vendorApiService.getAllVendors().stream()
                    .filter(v -> "ACTIVE".equals(v.getStatus()))
                    .count();

            // Calculate today's activity
            List<PurchaseOrderDTO> allOrders = backendApiService.getAllOrders();
            LocalDateTime startOfDay = LocalDateTime.now().withHour(0).withMinute(0).withSecond(0);
            long todayOrdersCount = allOrders.stream()
                    .filter(o -> o.getCreatedAt() != null && o.getCreatedAt().isAfter(startOfDay))
                    .count();

            model.addAttribute("pendingOrdersCount", pendingOrdersCount);
            model.addAttribute("lowStockItemsCount", lowStockItemsCount);
            model.addAttribute("activeVendorsCount", activeVendorsCount);
            model.addAttribute("todayOrdersCount", todayOrdersCount);

        } catch (Exception e) {
            log.error("Failed to load dashboard data", e);
            model.addAttribute("pendingOrdersCount", 0);
            model.addAttribute("lowStockItemsCount", 0);
            model.addAttribute("activeVendorsCount", 0);
            model.addAttribute("todayOrdersCount", 0L);
        }

        return "home";
    }
}
