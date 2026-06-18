package com.acme.scm.frontend.controller;

import com.acme.scm.frontend.dto.PurchaseOrderDTO;
import com.acme.scm.frontend.service.BackendApiService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Slf4j
@Controller
@RequestMapping("/orders")
@RequiredArgsConstructor
public class OrderController {

    private final BackendApiService backendApiService;

    @GetMapping
    public String listOrders(Model model) {
        log.info("Loading orders list page");

        try {
            List<PurchaseOrderDTO> orders = backendApiService.getAllOrders();
            model.addAttribute("orders", orders);
        } catch (Exception e) {
            log.error("Failed to load orders", e);
            model.addAttribute("error", "Failed to load orders: " + e.getMessage());
        }

        return "orders/list";
    }

    @GetMapping("/pending")
    public String listPendingOrders(Model model) {
        log.info("Loading pending orders page");

        try {
            List<PurchaseOrderDTO> orders = backendApiService.getPendingOrders();
            model.addAttribute("orders", orders);
        } catch (Exception e) {
            log.error("Failed to load pending orders", e);
            model.addAttribute("error", "Failed to load pending orders: " + e.getMessage());
        }

        return "orders/pending";
    }

    @GetMapping("/new")
    public String newOrderForm(Model model) {
        log.info("Loading new order form");
        model.addAttribute("order", new PurchaseOrderDTO());
        return "orders/new";
    }

    @PostMapping
    public String createOrder(@ModelAttribute PurchaseOrderDTO order, Model model) {
        log.info("Creating new order: {}", order.getOrderNumber());

        try {
            backendApiService.createOrder(order);
            return "redirect:/orders";
        } catch (Exception e) {
            log.error("Failed to create order", e);
            model.addAttribute("error", "Failed to create order: " + e.getMessage());
            model.addAttribute("order", order);
            return "orders/new";
        }
    }
}
