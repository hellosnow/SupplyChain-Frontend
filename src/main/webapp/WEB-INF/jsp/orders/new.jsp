<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Create Purchase Order - Supply Chain Management</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background-color: #f0f2f5; color: #333; }
        .header { background: linear-gradient(135deg, #1e3a8a 0%, #3b82f6 100%); color: white; padding: 20px 40px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        .header h1 { font-size: 24px; }
        .nav { background-color: #2c3e50; padding: 0; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        .nav ul { list-style: none; display: flex; }
        .nav a { display: block; color: white; text-decoration: none; padding: 15px 25px; transition: background-color 0.3s; }
        .nav a:hover { background-color: #34495e; }
        .container { max-width: 800px; margin: 30px auto; padding: 0 20px; }
        .content { background: white; border-radius: 8px; padding: 30px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
        .page-title { margin-bottom: 25px; padding-bottom: 15px; border-bottom: 2px solid #e0e0e0; }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; margin-bottom: 8px; font-weight: bold; color: #555; }
        .form-group input, .form-group textarea, .form-group select { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px; font-size: 14px; }
        .form-group textarea { resize: vertical; min-height: 100px; }
        .btn { display: inline-block; padding: 12px 24px; background-color: #3498db; color: white; text-decoration: none; border-radius: 4px; border: none; cursor: pointer; font-size: 14px; transition: background-color 0.3s; margin-right: 10px; }
        .btn:hover { background-color: #2980b9; }
        .btn-success { background-color: #27ae60; }
        .btn-success:hover { background-color: #229954; }
        .btn-secondary { background-color: #95a5a6; }
        .btn-secondary:hover { background-color: #7f8c8d; }
        .error { background-color: #f8d7da; color: #721c24; padding: 15px; border-radius: 4px; margin-bottom: 20px; border: 1px solid #f5c6cb; }
    </style>
</head>
<body>
    <div class="header">
        <h1>🏭 Supply Chain Management System</h1>
    </div>

    <nav class="nav">
        <ul>
            <li><a href="/">Dashboard</a></li>
            <li><a href="/orders" style="background-color: #3498db;">Purchase Orders</a></li>
            <li><a href="/orders/pending">Pending Approvals</a></li>
            <li><a href="/inventory">Inventory</a></li>
            <li><a href="/vendors">Vendors</a></li>
        </ul>
    </nav>

    <div class="container">
        <div class="content">
            <div class="page-title">
                <h2>➕ Create New Purchase Order</h2>
            </div>

            <c:if test="${not empty error}">
                <div class="error">⚠️ ${error}</div>
            </c:if>

            <form action="/orders" method="post">
                <div class="form-group">
                    <label for="orderNumber">Order Number *</label>
                    <input type="text" id="orderNumber" name="orderNumber"
                           placeholder="PO-2026-001" required
                           value="${order.orderNumber}">
                </div>

                <div class="form-group">
                    <label for="vendorId">Vendor *</label>
                    <select id="vendorId" name="vendorId" required>
                        <option value="">Select Vendor</option>
                        <option value="1">Acme Manufacturing Co.</option>
                        <option value="2">Global Supplies Ltd.</option>
                        <option value="3">Premium Parts Inc.</option>
                        <option value="4">Quality Materials Corp.</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="totalAmount">Total Amount ($) *</label>
                    <input type="number" id="totalAmount" name="totalAmount"
                           placeholder="15000.00" step="0.01" required
                           value="${order.totalAmount}">
                </div>

                <div class="form-group">
                    <label for="requestedBy">Requested By *</label>
                    <input type="text" id="requestedBy" name="requestedBy"
                           placeholder="john.doe" required
                           value="${order.requestedBy}">
                </div>

                <div class="form-group">
                    <label for="description">Description</label>
                    <textarea id="description" name="description"
                              placeholder="Office supplies for Q2 2026">${order.description}</textarea>
                </div>

                <div style="margin-top: 30px;">
                    <button type="submit" class="btn btn-success">Create Order</button>
                    <a href="/orders" class="btn btn-secondary">Cancel</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
