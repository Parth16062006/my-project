<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Bids</title>
</head>
<body>
    <h2>My Bid History</h2>
    
    <c:if test="${empty sessionScope.userId}">
        <p style="color: red;">Please log in to view your bids.</p>
        <p><a href="${pageContext.request.contextPath}/login.jsp">Login</a></p>
    </c:if>
    
    <c:if test="${not empty sessionScope.userId}">
        <c:if test="${not empty bids}">
                <div class="bids">
                    <table border="1">
                        <tr>
                            <th>Product ID</th>
                            <th>Amount</th>
                            <th>Date</th>
                        </tr>
                        <c:forEach var="bid" items="${bids}">
                            <tr>
                                <td>${bid.product_id}</td>
                                <td>$${bid.bidAmount}</td>
                                <td>${bid.bidTime}</td>
                            </tr>
                        </c:forEach>
                    </table>
                </div>
            </c:if>
        
        <c:if test="${empty bids}">
            <p>You haven't placed any bids yet.</p>
        </c:if>
    </c:if>
    
    <p>
        <a href="${pageContext.request.contextPath}/browse">Back to Browse</a>
    </p>
</body>
</html>