<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register</title>
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
        .success-message {
            color: #388e3c;
            background-color: #e8f5e9;
            padding: 10px;
            border-radius: 4px;
            margin-bottom: 15px;
            border: 1px solid #66bb6a;
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
        .form-group select {
            width: 100%;
            max-width: 300px;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
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
        .loading {
            display: inline-block;
            margin-left: 10px;
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
                <a href="${pageContext.request.contextPath}/login.jsp">Login</a>
            </div>
        </nav>
    </header>

    <main style="max-width: 500px; margin: 50px auto; padding: 20px;">
        <h2>Register</h2>
        
        <!-- Error Message -->
        <c:if test="${not empty error}">
            <div class="error-message" id="errorMessage">
                ${error}
            </div>
        </c:if>
        
        <!-- Success Message -->
        <c:if test="${not empty param.msg and param.msg == 'registered'}">
            <div class="success-message">
                Registration successful! You can now login.
            </div>
        </c:if>
        
        <form id="registerForm" action="${pageContext.request.contextPath}/register" method="post">
            <div class="form-group">
                <label for="username">Username:</label>
                <input type="text" id="username" name="username" 
                       value="${not empty username ? username : ''}" 
                       required minlength="3" 
                       placeholder="Minimum 3 characters">
            </div>
            
            <div class="form-group">
                <label for="password">Password:</label>
                <input type="password" id="password" name="password" 
                       required minlength="6" 
                       placeholder="Minimum 6 characters">
            </div>
            
            <div class="form-group">
                <label for="role">Role:</label>
                <select id="role" name="role">
                    <option value="user">Buyer</option>
                    <option value="seller">Seller</option>
                </select>
            </div>
            
            <button type="submit" id="submitBtn">
                Register
            </button>
        </form>
        
        <p style="margin-top: 20px;">
            Already have an account? <a href="${pageContext.request.contextPath}/login.jsp">Login here</a>
        </p>
    </main>

    <script>
        document.getElementById('registerForm').addEventListener('submit', function(e) {
            const submitBtn = document.getElementById('submitBtn');
            const errorMessage = document.getElementById('errorMessage');
            
            // Hide error message when submitting
            if (errorMessage) {
                errorMessage.style.display = 'none';
            }
            
            // Disable button and show loading state
            submitBtn.disabled = true;
            submitBtn.innerHTML = 'Registering...';
            
            // Form will submit normally
            // If there's an error, the page will reload with error message
        });
    </script>
</body>
</html>
