<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Place Bid</title>
</head>
<body>
    <h2>Place a Bid</h2>
    
    <c:if test="${empty sessionScope.userId}">
        <p style="color: red;">Please log in to place bids.</p>
        <p><a href="${pageContext.request.contextPath}/login.jsp">Login</a></p>
    </c:if>
    
    <c:if test="${not empty sessionScope.userId}">
        <%-- Show error message if present --%>
        <c:if test="${not empty param.error}">
            <p style="color: red;">
                <c:choose>
                    <c:when test="${param.error == 'invalid'}">Invalid bid amount</c:when>
                    <c:when test="${param.error == 'low_bid'}">Bid must be higher than current highest bid</c:when>
                    <c:otherwise>Error placing bid</c:otherwise>
                </c:choose>
            </p>
        </c:if>
        
        <form method="post" action="${pageContext.request.contextPath}/placeBid">
            <input type="hidden" name="product_id" value="${param.productId}">
            <div>
                <label for="amount">Your Bid Amount ($):</label><br>
                <input type="number" id="amount" name="amount" step="0.01" min="0.01" required>
            </div>
            <div>
                <input type="submit" value="Place Bid">
            </div>
        </form>
    </c:if>
    
    <p>
        <a href="${pageContext.request.contextPath}/browse">Back to Browse</a>
    </p>
</body>
</html>