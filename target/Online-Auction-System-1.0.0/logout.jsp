<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Logout</title>
</head>
<body>
    <h2>Logging out...</h2>
    <p>Please wait while we log you out.</p>
    <script>
        window.location.href = "${pageContext.request.contextPath}/logout";
    </script>
</body>
</html>