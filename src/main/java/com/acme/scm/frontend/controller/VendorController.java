package com.acme.scm.frontend.controller;

import com.acme.scm.frontend.service.VendorApiService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Slf4j
@Controller
@RequestMapping("/vendors")
@RequiredArgsConstructor
public class VendorController {

    private final VendorApiService vendorApiService;

    @GetMapping
    public String vendors(Model model) {
        log.info("Loading vendors page");

        try {
            model.addAttribute("vendors", vendorApiService.getAllVendors());
        } catch (Exception e) {
            log.error("Failed to load vendors", e);
            model.addAttribute("error", "Failed to load vendors: " + e.getMessage());
        }

        return "vendors";
    }
}
