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
    
    <!-- 에러 메시지 출력 -->
    <h2>${errorMsg }</h2>
    
    <!-- 로그아웃 메시지 출력 -->
    <h2>${logoutMsg }</h2>
    
    <!-- 로그인 폼 -->
    <form action="../auth/login" method="POST">
        <!-- 사용자명 입력 필드 -->
        ID : <input type="text" name="username" ><br> <br>
        <!-- 비밀번호 입력 필드 -->
        PW : <input type="password" name="password" ><br> <br>
        <!-- 로그인 버튼 -->
        <input type="submit" value="로그인">		
	    <!-- CSRF 토큰 -->
	    <input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }">
    </form>
    
    <a href="../access/registerEmail?select=idSearch" class="button">ID 찾기</a>
	<a href="../access/registerEmail?select=pwSearch" class="button">PW 찾기</a>
	
    <c:if test="${not empty alertMsg}">
       <script> alert("${alertMsg }"); </script>
    </c:if>

	<c:if test="${sessionScope.memberId != null}">
    	<script> window.location.href = "../home"; </script>
	</c:if>

</body>
</html>
