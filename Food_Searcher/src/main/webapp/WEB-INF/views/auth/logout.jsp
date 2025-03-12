<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
</head>
<body>

    <form id="logout" action="../auth/logout" method="POST">
        <!-- CSRF 토큰 -->
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
    </form>
    <script>
    alert("로그아웃되었습니다.");
    document.getElementById('logout').submit();
    </script>

</body>
</html>