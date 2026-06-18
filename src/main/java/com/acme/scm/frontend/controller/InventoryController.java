package com.acme.scm.frontend.controller;

import com.acme.scm.frontend.service.InventoryApiService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Slf4j
@Controller
@RequestMapping("/inventory")
@RequiredArgsConstructor
public class InventoryController {

    private final InventoryApiService inventoryApiService;

    @GetMapping
    public String inventory(Model model) {
        log.info("Loading inventory page");

        try {
            model.addAttribute("inventoryItems", inventoryApiService.getAllInventory());
            model.addAttribute("lowStockItems", inventoryApiService.getLowStockItems());
        } catch (Exception e) {
            log.error("Failed to load inventory", e);
            model.addAttribute("error", "Failed to load inventory: " + e.getMessage());
        }

        return "inventory";
    }
}
