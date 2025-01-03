<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page session="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>헤더</title>
<style>
body {
	margin: 0;
	font-family: Arial, sans-serif;
}

.navbar {
	display: flex;
	justify-content: space-between;
	align-items: center;
	background-color: #04AA6D;
	padding: 10px 20px;
	color: white;
}

.logo a {
	font-size: 20px;
	font-weight: bold;
	text-decoration: none;
	color: #ffffff;
}

.logo a:hover {
	color: #007BFF;
}

.navbar ul {
	list-style: none;
	margin: 0;
	padding: 0;
	display: flex;
}

.navbar ul li {
	margin: 0 15px;
}

.navbar ul li a {
	text-decoration: none;
	color: white;
	font-size: 16px;
	transition: color 0.3s;
}

.navbar ul li a:hover {
	color: #ff9800;
}

.navbar .login {
	font-size: 14px;
}

.navbar .login a {
	color: #ffffff;
	text-decoration: none;
	margin-left: 15px;
}

.navbar .login a:hover {
	text-decoration: underline;
}

.navbar .myPage {
	font-size: 14px;
}

.navbar .myPage a {
	color: #ffffff;
	text-decoration: none;
	margin-left: 15px;
}

.navbar .myPage a:hover {
	text-decoration: underline;
}

.button {
	background-color: #04AA6D;
	border: none;
	color: white;
	padding: 6px 12px;
	text-align: center;
	text-decoration: none;
	display: inline-block;
	font-size: 16px;
	margin: 4px 2px;
	cursor: pointer;
}

textarea[readonly] {
    background-color: #f2f2f2;
}

</style>
</head>

<body>
    <!-- 네비게이션 바 -->
    <div class="navbar">
    <%HttpSession session = request.getSession();%>
    
        <div class="logo">
        	<a href="/searcher/home">Home</a>
        </div>
        <ul>
            <li><a href="/searcher/recipe/list">레시피 공유</a></li>
            <li><a href="/searcher/market/list">전통시장</a></li>
            <li><a href="/searcher/local/map">특산품</a></li>
        </ul>
          	
   <%if(session.getAttribute("memberId") != null){ %>
        <div class="myPage">
		<a><%=session.getAttribute("memberId") %>님 환영합니다.</a>
        <a href="/searcher/logout">로그아웃</a>
        <a href="/searcher/access/memberPage">마이페이지</a>
        </div>
   <%} else { %>
    	<div class="login">
        <a href="/searcher/access/login">로그인</a>
        <a href="/searcher/access/registerEmail">회원가입</a>
        </div>
    <%} %>
    
    </div>

</body>
</html>
