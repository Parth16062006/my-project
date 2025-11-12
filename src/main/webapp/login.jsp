<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
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
        .form-group input {
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
                <a href="${pageContext.request.contextPath}/register.jsp">Register</a>
            </div>
        </nav>
    </header>

    <main style="max-width: 500px; margin: 50px auto; padding: 20px;">
        <h2>Login</h2>
        
        <!-- Error Message -->
        <c:if test="${not empty param.error}">
            <div class="error-message">
                <c:choose>
                    <c:when test="${param.error == 'missing'}">
                        Please enter both username and password.
                    </c:when>
                    <c:when test="${param.error == 'invalid'}">
                        Invalid username or password. Please try again.
                    </c:when>
                    <c:when test="${param.error == 'auth'}">
                        Please login to access this page.
                    </c:when>
                    <c:when test="${param.error == 'session_expired'}">
                        Your session has expired. Please login again.
                    </c:when>
                    <c:otherwise>
                        Login failed. Please try again.
                    </c:otherwise>
                </c:choose>
            </div>
        </c:if>
        
        <!-- Success Message -->
        <c:if test="${not empty param.msg}">
            <div class="success-message">
                <c:choose>
                    <c:when test="${param.msg == 'registered'}">
                        Registration successful! Please login with your credentials.
                    </c:when>
                    <c:otherwise>
                        ${param.msg}
                    </c:otherwise>
                </c:choose>
            </div>
        </c:if>
        
        <form id="loginForm" action="${pageContext.request.contextPath}/login" method="post">
            <div class="form-group">
                <label for="username">Username:</label>
                <input type="text" id="username" name="username" required autofocus>
            </div>
            
            <div class="form-group">
                <label for="password">Password:</label>
                <input type="password" id="password" name="password" required>
            </div>
            
            <button type="submit" id="submitBtn">
                Login
            </button>
        </form>
        
        <p style="margin-top: 20px;">
            Don't have an account? <a href="${pageContext.request.contextPath}/register.jsp">Register here</a>
        </p>
    </main>

    <script>
        document.getElementById('loginForm').addEventListener('submit', function(e) {
            const submitBtn = document.getElementById('submitBtn');
            submitBtn.disabled = true;
            submitBtn.innerHTML = 'Logging in...';
        });
    </script>
</body>
</html>
