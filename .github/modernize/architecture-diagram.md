# Architecture Diagram

This diagram illustrates the current architecture of the SupplyChain Frontend application, a legacy Spring Boot web application packaged as a WAR file deployed on Apache Tomcat.

## Application Architecture

```mermaid
flowchart TD
    Browser["Web Browser\nUser Interface"]

    subgraph Container["Docker Container - Tomcat 8.5 / JDK 8"]
        subgraph Presentation["Presentation Layer"]
            JSP["JSP Views\nJSTL / WEB-INF/jsp"]
            subgraph Controllers["Spring MVC Controllers"]
                HC["HomeController\nGET /"]
                IC["InventoryController\nGET /inventory"]
                VC["VendorController\nGET /vendors"]
                OC["OrderController\nGET /orders"]
            end
        end

        subgraph Business["Service Layer"]
            BAS["BackendApiService\nOrders REST Client"]
            IAS["InventoryApiService\nInventory REST Client"]
            VAS["VendorApiService\nVendor REST Client"]
        end

        subgraph Config["Configuration"]
            AC["AppConfig\nRestTemplate Bean"]
            YAML["application.yml\nPort 8081 / JSP config"]
        end
    end

    subgraph Backend["Backend Service - port 8080"]
        API["Backend REST API\nhttp://backend:8080/api"]
        subgraph Endpoints["REST Endpoints"]
            E1["/api/orders"]
            E2["/api/inventory"]
            E3["/api/vendors"]
        end
    end

    subgraph Build["Build - Maven / Spring Boot 2.7.18"]
        POM["pom.xml\nJava 8 / WAR packaging"]
    end

    Browser -->|"HTTP requests port 8081"| Controllers
    Controllers -->|"Model and View"| JSP
    JSP -->|"HTML response"| Browser
    HC --> BAS
    HC --> IAS
    HC --> VAS
    IC --> IAS
    VC --> VAS
    OC --> BAS
    BAS -->|"RestTemplate HTTP"| E1
    IAS -->|"RestTemplate HTTP"| E2
    VAS -->|"RestTemplate HTTP"| E3
    E1 & E2 & E3 --> API
    AC -->|"provides"| BAS
    AC -->|"provides"| IAS
    AC -->|"provides"| VAS
```
