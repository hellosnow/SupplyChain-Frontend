<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Inventory - Supply Chain Management</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background-color: #f0f2f5; color: #333; }
        .header { background: linear-gradient(135deg, #1e3a8a 0%, #3b82f6 100%); color: white; padding: 20px 40px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        .header h1 { font-size: 24px; }
        .nav { background-color: #2c3e50; padding: 0; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        .nav ul { list-style: none; display: flex; }
        .nav a { display: block; color: white; text-decoration: none; padding: 15px 25px; transition: background-color 0.3s; }
        .nav a:hover { background-color: #34495e; }
        .container { max-width: 1200px; margin: 30px auto; padding: 0 20px; }
        .content { background: white; border-radius: 8px; padding: 30px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
        .page-title { margin-bottom: 25px; padding-bottom: 15px; border-bottom: 2px solid #e0e0e0; }
        .alert-warning { background-color: #fff3cd; color: #856404; padding: 15px; border-radius: 4px; margin-bottom: 20px; border: 1px solid #ffeaa7; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th { background-color: #34495e; color: white; padding: 12px; text-align: left; font-weight: normal; }
        td { padding: 12px; border-bottom: 1px solid #e0e0e0; }
        tr:hover { background-color: #f8f9fa; }
        .stock-low { color: #e74c3c; font-weight: bold; }
        .stock-ok { color: #27ae60; }
        .empty-state { text-align: center; padding: 60px 20px; color: #666; }
        .empty-state-icon { font-size: 64px; margin-bottom: 20px; }
    </style>
</head>
<body>
    <div class="header">
        <h1>🏭 Supply Chain Management System</h1>
    </div>

    <nav class="nav">
        <ul>
            <li><a href="/">Dashboard</a></li>
            <li><a href="/orders">Purchase Orders</a></li>
            <li><a href="/orders/pending">Pending Approvals</a></li>
            <li><a href="/inventory" style="background-color: #3498db;">Inventory</a></li>
            <li><a href="/vendors">Vendors</a></li>
        </ul>
    </nav>

    <div class="container">
        <div class="content">
            <div class="page-title">
                <h2>📦 Inventory Management</h2>
            </div>

            <c:if test="${not empty lowStockItems && lowStockItems.size() > 0}">
                <div class="alert-warning">
                    ⚠️ <strong>${lowStockItems.size()} items are below safety stock levels</strong> - Immediate reordering recommended
                </div>
            </c:if>

            <c:if test="${not empty error}">
                <div class="error">⚠️ ${error}</div>
            </c:if>

            <c:choose>
                <c:when test="${not empty inventoryItems}">
                    <table>
                        <thead>
                            <tr>
                                <th>SKU</th>
                                <th>Product Name</th>
                                <th>Quantity</th>
                                <th>Safety Stock</th>
                                <th>Status</th>
                                <th>Warehouse</th>
                                <th>Batch</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${inventoryItems}" var="item">
                                <tr>
                                    <td><strong>${item.sku}</strong></td>
                                    <td>${item.productName}</td>
                                    <td class="${item.lowStock ? 'stock-low' : 'stock-ok'}">${item.quantity}</td>
                                    <td>${item.safetyStock}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${item.lowStock}">
                                                <span class="stock-low">⚠️ LOW STOCK</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="stock-ok">✓ OK</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${item.warehouseLocation}</td>
                                    <td>${item.batchNumber}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <div class="empty-state-icon">📦</div>
                        <h3>No Inventory Data</h3>
                        <p>Connect to backend to view inventory data.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>
