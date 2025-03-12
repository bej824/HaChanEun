<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인 페이지</title>
</head>
<body>

    <%@ include file ="../header.jsp" %>
    <h1>로그인 페이지</h1>
    
    <!-- 로그인 폼 -->
    <form action="../auth/login" method="POST">
        <!-- 사용자명 입력 필드 -->
        ID : <input type="text" name="username" placeholder="아이디 입력"><br> <br>
        <!-- 비밀번호 입력 필드 -->
        PW : <input type="password" name="password" placeholder="비밀번호 입력"><br> <br>
        <!-- 로그인 버튼 -->
        <input type="submit" class="button" value="로그인">
	    <!-- CSRF 토큰 -->
	    <input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }">
    </form>
    
    <a href="../access/registerEmail?select=idSearch" class="button">ID 찾기</a>
	<a href="../access/registerEmail?select=pwSearch" class="button">PW 찾기</a>
	
	<c:if test="${not empty errorMsg }">
    	<script>alert('${errorMsg }');</script>
	</c:if>

</body>
</html>
