<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Supply Chain Management System</title>
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
            margin-bottom: 5px;
        }

        .header .subtitle {
            font-size: 14px;
            opacity: 0.9;
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

        .nav a.active {
            background-color: #3498db;
        }

        .container {
            max-width: 1200px;
            margin: 30px auto;
            padding: 0 20px;
        }

        .dashboard {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .card {
            background: white;
            border-radius: 8px;
            padding: 25px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            transition: transform 0.2s, box-shadow 0.2s;
        }

        .card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }

        .card-title {
            font-size: 14px;
            color: #666;
            margin-bottom: 10px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .card-value {
            font-size: 36px;
            font-weight: bold;
            color: #1e3a8a;
        }

        .card-icon {
            font-size: 48px;
            opacity: 0.2;
            float: right;
        }

        .content {
            background: white;
            border-radius: 8px;
            padding: 30px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
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

        .footer {
            text-align: center;
            padding: 20px;
            color: #666;
            font-size: 12px;
            margin-top: 40px;
        }

        .tech-debt-badge {
            display: inline-block;
            background-color: #e74c3c;
            color: white;
            padding: 2px 8px;
            border-radius: 3px;
            font-size: 10px;
            margin-left: 10px;
            vertical-align: middle;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>🏭 Supply Chain Management System</h1>
        <div class="subtitle">Enterprise Resource Planning</div>
    </div>

    <nav class="nav">
        <ul>
            <li><a href="/" class="active">Dashboard</a></li>
            <li><a href="/orders">Purchase Orders</a></li>
            <li><a href="/orders/pending">Pending Approvals</a></li>
            <li><a href="/inventory">Inventory</a></li>
            <li><a href="/vendors">Vendors</a></li>
        </ul>
    </nav>

    <div class="container">
        <div class="dashboard">
            <div class="card">
                <div class="card-icon">📋</div>
                <div class="card-title">Pending Approvals</div>
                <div class="card-value">${pendingOrdersCount}</div>
            </div>

            <div class="card">
                <div class="card-icon">⚠️</div>
                <div class="card-title">Low Stock Alerts</div>
                <div class="card-value">${lowStockItemsCount}</div>
            </div>

            <div class="card">
                <div class="card-icon">📦</div>
                <div class="card-title">Active Vendors</div>
                <div class="card-value">${activeVendorsCount}</div>
            </div>

            <div class="card">
                <div class="card-icon">🕐</div>
                <div class="card-title">Today's Activity</div>
                <div class="card-value">${todayOrdersCount}</div>
            </div>
        </div>

        <div class="content">
            <h2>Welcome to Supply Chain Manager</h2>
            <p style="margin: 20px 0; line-height: 1.6;">
                Streamline your procurement and inventory management with our integrated platform.
                Manage purchase orders, track inventory levels, and monitor vendor performance all in one place.
            </p>

            <h3 style="margin-top: 30px; color: #1e3a8a;">Key Features</h3>
            <ul style="margin: 20px 0; line-height: 2;">
                <li>📋 Purchase Order Management with multi-level approval workflow</li>
                <li>📦 Real-time Inventory Tracking across multiple warehouses</li>
                <li>🏢 Vendor Performance Monitoring and rating system</li>
                <li>📊 Comprehensive Reporting and Analytics</li>
                <li>🔔 Automated Alerts for low stock and pending approvals</li>
            </ul>

            <div style="margin-top: 30px;">
                <a href="/orders" class="btn">View Purchase Orders</a>
                <a href="/orders/new" class="btn btn-success">Create New Order</a>
            </div>
        </div>
    </div>

    <div class="footer">
        &copy; 2024 Supply Chain Management System | Legacy Application for Modernization Demo
    </div>
</body>
</html>
