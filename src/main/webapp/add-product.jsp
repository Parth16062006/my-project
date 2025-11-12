<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add New Product</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .error-message {
            color: #d32f2f;
            background-color: #ffebee;
            padding: 10px;
            border-radius: 4px;
            margin-bottom: 15px;
            border: 1px solid #ef5350;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        .form-group input,
        .form-group textarea {
            width: 100%;
            max-width: 500px;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
        }
        .form-group textarea {
            min-height: 100px;
            resize: vertical;
        }
        button[type="submit"] {
            padding: 10px 20px;
            background-color: #1976d2;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
        }
        button[type="submit"]:hover:not(:disabled) {
            background-color: #1565c0;
        }
        button[type="submit"]:disabled {
            background-color: #ccc;
            cursor: not-allowed;
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
                <a href="${pageContext.request.contextPath}/">Home</a>
                <a href="${pageContext.request.contextPath}/browse">Browse</a>
                <c:if test="${not empty sessionScope.userId}">
                    <a href="${pageContext.request.contextPath}/viewMyBids">My Bids</a>
                    <a href="${pageContext.request.contextPath}/logout">Logout</a>
                </c:if>
            </div>
        </nav>
    </header>

    <main style="max-width: 600px; margin: 50px auto; padding: 20px;">
        <h2>Add New Product for Auction</h2>
        
        <c:if test="${sessionScope.role != 'seller'}">
            <div class="error-message">
                Access denied. Seller role required. Please <a href="${pageContext.request.contextPath}/login.jsp">login as a seller</a>.
            </div>
        </c:if>
        
        <c:if test="${sessionScope.role == 'seller'}">
            <%-- Show error message if present --%>
            <c:if test="${not empty error}">
                <div class="error-message">
                    ${error}
                </div>
            </c:if>
            
            <form id="addProductForm" method="post" action="${pageContext.request.contextPath}/add-product">
                <div class="form-group">
                    <label for="name">Product Name:</label>
                    <input type="text" id="name" name="name" required>
                </div>
                
                <div class="form-group">
                    <label for="description">Description:</label>
                    <textarea id="description" name="description" rows="4" required></textarea>
                </div>
                
                <div class="form-group">
                    <label for="start_price">Starting Price ($):</label>
                    <input type="number" id="start_price" name="start_price" step="0.01" min="0.01" required>
                </div>
                
                <div>
                    <button type="submit" id="submitBtn">Submit for Approval</button>
                </div>
            </form>
        </c:if>
        
        <p style="margin-top: 20px;">
            <a href="${pageContext.request.contextPath}/browse">Back to Browse</a>
        </p>
    </main>

    <footer>
        <p>&copy; 2025 Online Auction System. All rights reserved.</p>
    </footer>

    <script>
        document.getElementById('addProductForm')?.addEventListener('submit', function(e) {
            const submitBtn = document.getElementById('submitBtn');
            if (submitBtn) {
                submitBtn.disabled = true;
                submitBtn.innerHTML = 'Submitting...';
            }
        });
    </script>
</body>
</html>