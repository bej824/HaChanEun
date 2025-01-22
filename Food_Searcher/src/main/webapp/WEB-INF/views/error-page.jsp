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

    <script>
            window.history.back();
            setTimeout(function(){
                window.location.href = "../home"; // 리다이렉트할 URL
            }, 50);
    </script>
</body>
</html>
