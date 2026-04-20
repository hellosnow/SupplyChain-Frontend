# SupplyChain Frontend

Legacy Supply Chain Management System - Frontend Web UI

---

## 🚀 Quick Start

### Access the Frontend
```
http://localhost:8081
```

### Run with Docker
```bash
docker build -t supplychain-frontend .
docker run -p 8081:8081 \
  -e BACKEND_API_URL=http://backend:8080/api \
  supplychain-frontend
```

---

## 📄 Pages

- `/` - Dashboard
- `/orders` - Purchase Orders List
- `/orders/pending` - Pending Approvals
- `/orders/new` - Create New Order

---

## 🚨 Technical Debt Summary

This is an intentionally **legacy application** with the following technical debt:

### Prohibited Technologies
- ❌ **Java 8** → Should upgrade to **Java 17 LTS**
- ❌ **Spring Boot 2.7.18** → Should upgrade to **Spring Boot 3.x**
- ❌ **RestTemplate** → Should use **ServiceMesh SDK**
- ❌ **SLF4J logging** → Should use **InternalLogger**
- ❌ **JSP templates** → Could modernize to React/Angular

## 🐛 Tech Debt

### RestTemplate Usage
**Location:** `BackendApiService.java`
```java
// ❌ RestTemplate bypasses mesh
restTemplate.getForObject(url, PurchaseOrderDTO.class);
```

**Fix:** Use ServiceMesh SDK

---

For full documentation see Backend README.
