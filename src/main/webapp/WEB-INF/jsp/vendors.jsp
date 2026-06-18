<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Vendors - Supply Chain Management</title>
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
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th { background-color: #34495e; color: white; padding: 12px; text-align: left; font-weight: normal; }
        td { padding: 12px; border-bottom: 1px solid #e0e0e0; }
        tr:hover { background-color: #f8f9fa; }
        .status-badge { display: inline-block; padding: 4px 12px; border-radius: 12px; font-size: 12px; font-weight: bold; }
        .status-active { background-color: #d4edda; color: #155724; }
        .status-inactive { background-color: #f8d7da; color: #721c24; }
        .score { font-weight: bold; }
        .score-high { color: #27ae60; }
        .score-medium { color: #f39c12; }
        .score-low { color: #e74c3c; }
        .empty-state { text-align: center; padding: 60px 20px; color: #666; }
        .empty-state-icon { font-size: 64px; margin-bottom: 20px; }
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
            <li><a href="/orders">Purchase Orders</a></li>
            <li><a href="/orders/pending">Pending Approvals</a></li>
            <li><a href="/inventory">Inventory</a></li>
            <li><a href="/vendors" style="background-color: #3498db;">Vendors</a></li>
        </ul>
    </nav>

    <div class="container">
        <div class="content">
            <div class="page-title">
                <h2>🏢 Vendor Management</h2>
            </div>

            <c:if test="${not empty error}">
                <div class="error">⚠️ ${error}</div>
            </c:if>

            <c:choose>
                <c:when test="${not empty vendors}">
                    <table>
                        <thead>
                            <tr>
                                <th>Vendor Code</th>
                                <th>Company Name</th>
                                <th>Contact</th>
                                <th>Email</th>
                                <th>Performance Score</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${vendors}" var="vendor">
                                <tr>
                                    <td><strong>${vendor.vendorCode}</strong></td>
                                    <td>${vendor.name}</td>
                                    <td>${vendor.contactPerson}</td>
                                    <td>${vendor.email}</td>
                                    <td>
                                        <span class="score ${vendor.performanceScore >= 90 ? 'score-high' : (vendor.performanceScore >= 75 ? 'score-medium' : 'score-low')}">
                                            ${vendor.performanceScore}%
                                        </span>
                                    </td>
                                    <td>
                                        <span class="status-badge status-${vendor.status.toLowerCase()}">
                                            ${vendor.status}
                                        </span>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <div class="empty-state-icon">🏢</div>
                        <h3>No Vendors Found</h3>
                        <p>Connect to backend to view vendor data.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>
