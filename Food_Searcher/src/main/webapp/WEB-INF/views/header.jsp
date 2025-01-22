<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<title>헤더</title>
<style>
body {
	margin: 20px;
	font-family: Arial, sans-serif;
}

.navbar {
	margin: 20px auto;
	margin-right: 100px;
	margin-left: 100px;
	height: 200px;
	display: flex;
	justify-content: space-between;
	align-items: center;
	background-color: #04AA6D;
	padding: 10px 20px;
	color: white;
	border-radius: 8px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
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
	font-size: 16px;
}

.navbar .login a {
	color: #ffffff;
	text-decoration: none;
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

#memberForm{
	box-sizing: border-box;
	border-radius: 8px;
	left:20px;
	top:20px;
	border: 1px solid #ccc;
	width: 180px;
	height: 180px;
	text-align:center;
	font-size: 20px;
	line-height: 2.1;
}

#front_img{
	font-size:26px;
	color: #ffffff;
	text-decoration: none;
}

#boardArea {
	width: 150px;
    height: 500px;
    font-size: 20px;
    font-family: "나눔고딕";
    line-height: 2.1;
    border-radius: 8px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    border: 1px solid #dcdcdc;
    text-decoration: none;
 	float: left;
 	box-sizing: border-box;
 	margin-right: 100px;
	margin-left: 100px;
}

#list a {
	font-size:16px;
	text-decoration: none;
}

#list a:hover{
	font-size:20px;
	font-weight:bold;
}

</style>
<meta name="_csrf" content="${_csrf.token}">
<meta name="_csrf_header" content="${_csrf.headerName}">
<meta name="authenticatedUser" content="${authentication.name}">
</head>

<body>
    <!-- 네비게이션 바 -->
    <div class="navbar">
    
        <div id="memberForm">
    	<sec:authorize access="isAuthenticated()">
        	<div class="myPage">
			<a><sec:authentication property="name" />님 환영합니다.</a>
        	<a href="/searcher/auth/login">로그아웃</a>
        	<a href="/searcher/access/memberPage">마이페이지</a>
        	</div>
        </sec:authorize>
        
   		<sec:authorize access="!isAuthenticated()">
    		<div class="login">
        	<a href="/searcher/auth/login">로그인</a>
        	<br>
        	<a href="/searcher/access/registerEmail?select=register">회원가입</a>
        	</div>
    	</sec:authorize>
    	</div>
        
        <div id="front_img">
        <a href="/searcher/home">Home</a>
        </div>
    
    </div>
    
    <div id="boardArea">
	<div id="list">
        <ul>
            <li><a href="/searcher/recipe/list"> 레시피 공유</a></li>
            <li><a href="/searcher/market/list"> 전통시장</a></li>
            <li><a href="/searcher/local/map"> 특산품</a></li>
        </ul>
    </div>
	</div>

</body>
</html>
