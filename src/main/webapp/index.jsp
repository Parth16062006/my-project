<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Online Auction System</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .success-message {
            color: #388e3c;
            background-color: #e8f5e9;
            padding: 15px;
            border-radius: 4px;
            margin: 20px auto;
            max-width: 600px;
            border: 1px solid #66bb6a;
        }
        .error-message {
            color: #d32f2f;
            background-color: #ffebee;
            padding: 15px;
            border-radius: 4px;
            margin: 20px auto;
            max-width: 600px;
            border: 1px solid #ef5350;
        }
        .user-info {
            color: #1976d2;
            margin: 10px 0;
        }
    </style>
</head>
<body>
    <header>
        <nav>
            <div class="nav-brand">
                <a href="${pageContext.request.contextPath}/">Online Auction</a>
            </div>
            <div class="nav-links">
                <c:if test="${not empty sessionScope.userId}">
                    <span class="user-info">Welcome, ${sessionScope.username}!</span>
                    <a href="${pageContext.request.contextPath}/browse">Browse</a>
                    <c:if test="${sessionScope.role == 'seller'}">
                        <a href="${pageContext.request.contextPath}/add-product">Add Product</a>
                    </c:if>
                    <c:if test="${sessionScope.role == 'admin'}">
                        <a href="${pageContext.request.contextPath}/admin">Admin</a>
                    </c:if>
                    <a href="${pageContext.request.contextPath}/viewMyBids">My Bids</a>
                    <a href="${pageContext.request.contextPath}/logout">Logout</a>
                </c:if>
                <c:if test="${empty sessionScope.userId}">
                    <a href="${pageContext.request.contextPath}/browse">Browse</a>
                    <a href="${pageContext.request.contextPath}/login.jsp">Login</a>
                    <a href="${pageContext.request.contextPath}/register.jsp">Register</a>
                </c:if>
            </div>
        </nav>
    </header>

    <main>
        <!-- Success Message -->
        <c:if test="${not empty param.msg}">
            <div class="success-message">
                <c:choose>
                    <c:when test="${param.msg == 'registered'}">
                        Registration successful! Welcome to Online Auction System.
                    </c:when>
                    <c:when test="${param.msg == 'product_submitted'}">
                        Product submitted successfully! It will be reviewed by an admin.
                    </c:when>
                    <c:otherwise>
                        ${param.msg}
                    </c:otherwise>
                </c:choose>
            </div>
        </c:if>
        
        <!-- Error Message -->
        <c:if test="${not empty param.error}">
            <div class="error-message">
                <c:choose>
                    <c:when test="${param.error == 'invalid'}">
                        Invalid request. Please try again.
                    </c:when>
                    <c:when test="${param.error == 'product_unavailable'}">
                        Product is no longer available for bidding.
                    </c:when>
                    <c:when test="${param.error == 'low_bid'}">
                        Your bid must be higher than the current highest bid.
                    </c:when>
                    <c:when test="${param.error == 'bid_failed'}">
                        Failed to place bid. Please try again.
                    </c:when>
                    <c:otherwise>
                        An error occurred. Please try again.
                    </c:otherwise>
                </c:choose>
            </div>
        </c:if>
        
        <section class="hero">
            <h1>Welcome to Online Auction</h1>
            <p>Discover unique items and place your bids!</p>
            <div class="cta-buttons">
                <a href="${pageContext.request.contextPath}/browse" class="btn btn-primary">Browse Auctions</a>
                <c:if test="${empty sessionScope.userId}">
                    <a href="${pageContext.request.contextPath}/register.jsp" class="btn btn-secondary">Start Selling</a>
                </c:if>
                <c:if test="${not empty sessionScope.userId && sessionScope.role == 'seller'}">
                    <a href="${pageContext.request.contextPath}/add-product" class="btn btn-secondary">Add Product</a>
                </c:if>
            </div>
        </section>

        <section class="featured-items">
            <h2>Featured Auctions</h2>
            <p>Browse our active auctions and place your bids!</p>
            <a href="${pageContext.request.contextPath}/browse" class="btn btn-primary">View All Auctions</a>
        </section>
    </main>

    <footer>
        <p>&copy; 2025 Online Auction System. All rights reserved.</p>
    </footer>
</body>
</html>