<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
</head>
<body>
    <h2>Admin Dashboard - Pending Products</h2>
    
    <c:if test="${sessionScope.role != 'admin'}">
        <p style="color: red;">Access denied. Admin role required.</p>
        <p><a href="${pageContext.request.contextPath}/login.jsp">Login as admin</a></p>
    </c:if>
    
    <c:if test="${sessionScope.role == 'admin'}">
        <%-- Show success/error messages --%>
        <c:if test="${param.msg == 'approved'}">
            <p style="color: green;">Product approved successfully.</p>
        </c:if>
        <c:if test="${not empty param.error}">
            <p style="color: red;">Error: ${param.error}</p>
        </c:if>
        
        <c:if test="${not empty products}">
            <div class="products">
                <table border="1">
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Description</th>
                        <th>Start Price</th>
                        <th>Seller ID</th>
                        <th>Action</th>
                    </tr>
                    <c:forEach var="product" items="${products}">
                        <tr>
                            <td>${product._id}</td>
                            <td>${product.name}</td>
                            <td>${product.description}</td>
                            <td>$${product.basePrice}</td>
                            <td>${product.seller_id}</td>
                            <td>
                                <form method="post" action="${pageContext.request.contextPath}/admin">
                                    <input type="hidden" name="action" value="approve">
                                    <input type="hidden" name="id" value="${product._id}">
                                    <input type="submit" value="Approve">
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </table>
            </div>
        </c:if>
        
        <c:if test="${empty products}">
            <p>No pending products to approve.</p>
        </c:if>
    </c:if>
    
    <p>
        <a href="${pageContext.request.contextPath}/">Back to Home</a>
    </p>
</body>
</html>