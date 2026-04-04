package com.acme.scm.frontend.dto;

import lombok.Data;
import java.math.BigDecimal;

@Data
public class VendorDTO {
    private Long id;
    private String vendorCode;
    private String name;
    private String contactPerson;
    private String email;
    private String phone;
    private String address;
    private BigDecimal performanceScore;
    private String status;
}
