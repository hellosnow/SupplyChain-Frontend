# Architecture Diagram

This diagram shows the current architecture of the SupplyChain Frontend application, a Spring Boot 2.7.18 WAR deployed on Tomcat 8.5 with JSP/JSTL views and RestTemplate-based backend integration.

## Application Architecture

```mermaid
flowchart TD
    Browser["Web Browser\nUser Interface"]

    subgraph Container["Docker Container - tomcat:8.5-jdk8"]
        subgraph Presentation["Presentation Layer - JSP / JSTL"]
            JSP["JSP Views\nhome.jsp, inventory.jsp\norders/list.jsp, orders/new.jsp\norders/pending.jsp, vendors.jsp"]
        end

        subgraph Controllers["Controller Layer - Spring MVC"]
            HC["HomeController\nGET /"]
            IC["InventoryController\nGET /inventory"]
            OC["OrderController\nGET /orders, POST /orders"]
            VC["VendorController\nGET /vendors"]
        end

        subgraph Services["Service Layer - RestTemplate"]
            BAS["BackendApiService\norders, pending orders"]
            IAS["InventoryApiService\ninventory, low-stock"]
            VAS["VendorApiService\nvendors"]
        end

        subgraph Config["Configuration"]
            AppCfg["AppConfig\nRestTemplate Bean"]
            AppYml["application.yml\nPort 8081, backend.api.url"]
        end
    end

    subgraph Backend["Backend Service - http://backend:8080/api"]
        BAPI["Backend REST API\n/orders /orders/pending\n/inventory /inventory/low-stock\n/vendors"]
    end

    Browser -->|"HTTP requests port 8081"| Controllers
    Controllers -->|"model + view name"| JSP
    JSP -->|"rendered HTML"| Browser
    HC --> BAS
    OC --> BAS
    IC --> IAS
    VC --> VAS
    BAS -->|"RestTemplate HTTP GET/POST"| BAPI
    IAS -->|"RestTemplate HTTP GET"| BAPI
    VAS -->|"RestTemplate HTTP GET"| BAPI
    AppCfg -.->|"provides"| BAS
    AppCfg -.->|"provides"| IAS
    AppCfg -.->|"provides"| VAS
    AppYml -.->|"configures"| AppCfg
```
