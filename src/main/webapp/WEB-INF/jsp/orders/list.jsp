<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Purchase Orders - Supply Chain Management</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: Arial, sans-serif;
            background-color: #f0f2f5;
            color: #333;
        }

        .header {
            background: linear-gradient(135deg, #1e3a8a 0%, #3b82f6 100%);
            color: white;
            padding: 20px 40px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .header h1 {
            font-size: 24px;
        }

        .nav {
            background-color: #2c3e50;
            padding: 0;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .nav ul {
            list-style: none;
            display: flex;
        }

        .nav li {
            margin: 0;
        }

        .nav a {
            display: block;
            color: white;
            text-decoration: none;
            padding: 15px 25px;
            transition: background-color 0.3s;
        }

        .nav a:hover {
            background-color: #34495e;
        }

        .container {
            max-width: 1200px;
            margin: 30px auto;
            padding: 0 20px;
        }

        .content {
            background: white;
            border-radius: 8px;
            padding: 30px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .page-title {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 2px solid #e0e0e0;
        }

        .btn {
            display: inline-block;
            padding: 10px 20px;
            background-color: #3498db;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            border: none;
            cursor: pointer;
            font-size: 14px;
            transition: background-color 0.3s;
        }

        .btn:hover {
            background-color: #2980b9;
        }

        .btn-success {
            background-color: #27ae60;
        }

        .btn-success:hover {
            background-color: #229954;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th {
            background-color: #34495e;
            color: white;
            padding: 12px;
            text-align: left;
            font-weight: normal;
        }

        td {
            padding: 12px;
            border-bottom: 1px solid #e0e0e0;
        }

        tr:hover {
            background-color: #f8f9fa;
        }

        .status-badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: bold;
        }

        .status-pending {
            background-color: #fff3cd;
            color: #856404;
        }

        .status-approved {
            background-color: #d4edda;
            color: #155724;
        }

        .status-rejected {
            background-color: #f8d7da;
            color: #721c24;
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #666;
        }

        .empty-state-icon {
            font-size: 64px;
            margin-bottom: 20px;
        }

        .error {
            background-color: #f8d7da;
            color: #721c24;
            padding: 15px;
            border-radius: 4px;
            margin-bottom: 20px;
            border: 1px solid #f5c6cb;
        }
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
                <h2>📋 Purchase Orders</h2>
                <a href="/orders/new" class="btn btn-success">+ Create New Order</a>
            </div>

            <c:if test="${not empty error}">
                <div class="error">
                    ⚠️ ${error}
                </div>
            </c:if>

            <c:choose>
                <c:when test="${not empty orders}">
                    <table>
                        <thead>
                            <tr>
                                <th>Order Number</th>
                                <th>Vendor ID</th>
                                <th>Amount</th>
                                <th>Status</th>
                                <th>Requested By</th>
                                <th>Created At</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${orders}" var="order">
                                <tr>
                                    <td><strong>${order.orderNumber}</strong></td>
                                    <td>${order.vendorId}</td>
                                    <td>$${order.totalAmount}</td>
                                    <td>
                                        <span class="status-badge status-${order.status.toLowerCase()}">
                                            ${order.status}
                                        </span>
                                    </td>
                                    <td>${order.requestedBy}</td>
                                    <td>${order.createdAt}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <div class="empty-state-icon">📦</div>
                        <h3>No Orders Found</h3>
                        <p>Create your first purchase order to get started.</p>
                        <br>
                        <a href="/orders/new" class="btn btn-success">+ Create New Order</a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>
