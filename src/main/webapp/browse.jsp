<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Browse Auctions</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <header>
        <nav>
            <div class="nav-brand">
                <a href="${pageContext.request.contextPath}/">Online Auction</a>
            </div>
            <div class="nav-links">
                <a href="${pageContext.request.contextPath}/">Home</a>
                <c:if test="${not empty sessionScope.userId}">
                    <a href="${pageContext.request.contextPath}/viewMyBids">My Bids</a>
                    <a href="${pageContext.request.contextPath}/logout">Logout</a>
                </c:if>
                <c:if test="${empty sessionScope.userId}">
                    <a href="${pageContext.request.contextPath}/login.jsp">Login</a>
                    <a href="${pageContext.request.contextPath}/register.jsp">Register</a>
                </c:if>
            </div>
        </nav>
    </header>

    <main>
        <h2>Browse Auctions</h2>
        
        <c:if test="${not empty error}">
            <div style="color: #d32f2f; background-color: #ffebee; padding: 10px; border-radius: 4px; margin-bottom: 15px; border: 1px solid #ef5350;">
                ${error}
            </div>
        </c:if>
        
        <c:if test="${not empty products}">
            <div class="products">
                <table border="1" style="width: 100%; border-collapse: collapse;">
                    <thead>
                        <tr style="background-color: #f5f5f5;">
                            <th style="padding: 10px; text-align: left;">Name</th>
                            <th style="padding: 10px; text-align: left;">Description</th>
                            <th style="padding: 10px; text-align: right;">Current Price</th>
                            <th style="padding: 10px; text-align: center;">Status</th>
                            <th style="padding: 10px; text-align: center;">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="product" items="${products}">
                            <tr>
                                <td style="padding: 10px;">${product.name}</td>
                                <td style="padding: 10px;">${product.description}</td>
                                <td style="padding: 10px; text-align: right;">$${product.currentPrice}</td>
                                <td style="padding: 10px; text-align: center;">${product.status}</td>
                                <td style="padding: 10px; text-align: center;">
                                    <c:if test="${not empty sessionScope.userId}">
                                        <form action="${pageContext.request.contextPath}/placeBid" method="post" style="display: inline;">
                                            <input type="hidden" name="product_id" value="${product._id}" />
                                            <input type="number" step="0.01" name="amount" placeholder="Your bid" min="${product.currentPrice + 0.01}" required style="width: 120px; padding: 5px;" />
                                            <button type="submit" style="padding: 5px 10px; margin-left: 5px;">Place Bid</button>
                                        </form>
                                    </c:if>
                                    <c:if test="${empty sessionScope.userId}">
                                        <a href="${pageContext.request.contextPath}/login.jsp">Login to bid</a>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:if>
        <c:if test="${empty products}">
            <p>No active auctions currently. Check back later or <a href="${pageContext.request.contextPath}/add-product">add a product</a> if you're a seller.</p>
        </c:if>
    </main>

    <footer>
        <p>&copy; 2025 Online Auction System. All rights reserved.</p>
    </footer>
</body>
</html>
