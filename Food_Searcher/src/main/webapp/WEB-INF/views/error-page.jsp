<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>에러 페이지</title>
</head>
<body>
	<%@ include file ="header.jsp" %>
    <h1>접근할수 없는 페이지입니다</h1>
    <button onclick="goBack()" class="button">이전 페이지로 이동</button>

    <script>
        function goBack() {
            window.history.back();
        }
    </script>
</body>
</html>
