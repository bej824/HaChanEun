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
	transform: none !important; 
    position: static !important;
    margin: 0 !important;
    top: auto !important;
    left: auto !important;
	margin: 20px;
	font-family: Arial, sans-serif;
}

.logo a {
	font-size: 20px;
	font-weight: bold;
	text-decoration: none;
	color: #ffffff;
}

.logo a:hover {
	color: #007BFF;
	text-decoration: none;
}

.navbar {
	margin: 20px auto;
	margin-right: 100px;
	margin-left: 100px;
	height: 200px;
	display: flex;
	justify-content: space-between; /* 자식 요소들을 양 맨 끝에 배치*/
	align-items: center;
	background-color: #04AA6D;
	padding: 10px 20px;
	color: white;
	border-radius: 8px;
	
}

.navbar ul {
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

.login {
	color: black;
	font-size: 14px;
}

.login a, a:hover {
	color: black;
	text-decoration: none;
}

.myPage {
	color: black;
	font-size: 14px;
}

.myPage p {
	color: black;
}

.myPage a {
	text-decoration: none;
	text-align: center;
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
	width: 700px;
	height: 280px;
	padding: 12px 20px;
    background-color: #f2f2f2;
    resize: none;
}

#front_img{
	width: 100%;
	height: 100%;
	font-size:26px;
	color: #ffffff;
	display:flex;
	justify-content: center;
}

#front_img a {
	
	color: black; /* 링크, 방문된 링크, hover 상태, active 상태 모두 검은색 */
    text-decoration: none; /* 모든 상태에서 밑줄 없애기 */
    transform: none !important; 
    position: static !important;
    margin: 0 !important;
    top: auto !important;
    left: auto !important;
}

#memberForm{
	box-sizing: border-box;
	width: 150px;
	height: 150px;
	border-radius: 8px;
	border: 1px solid #ccc;
	text-align:center;
	line-height: 2.1;
	font-size: 14px;
	color: #ffffff;
}

#memberForm a {
	text-decoration: none;
}

#boardArea {
 	box-sizing: border-box;
	width: 150px;
    height: 100vh;
    font-family: "나눔고딕";
    line-height: 2.1;
    border-radius: 8px;
    border: 1px solid #dcdcdc;
    text-decoration: none;
 	float: left;
 	margin-right: 100px;
	margin-left: 100px;
}


#list {
	font-size : 16px;
	text-decoration: none;
}

#list ul, a {
	list-style: none;
	margin: 5px;
	padding:5px;
	border: 0;
	font-size: 100%;
	font: inherit;
	vertical-align: baseline;
    /* user agent 초기화 */
    
	font-size:16px;
	text-decoration:none;
}

li {
	text-align: none;
	text-decoration: none;
}


</style>
<meta name="_csrf" content="${_csrf.token}">
<meta name="_csrf_header" content="${_csrf.headerName}">
<meta name="authenticatedUser" content="${authentication.name}">
</head>

<body>
    <!-- 네비게이션 바 -->
    <div class="navbar">
    
        <div id="front_img">
        <a href="/searcher/home">Home</a>
        </div>
    
    </div>
    
   
    
    <div id="boardArea">
    
     <div id="memberForm">
    	<sec:authorize access="isAuthenticated()">
        	<div class="myPage">
			<p><sec:authentication property="name" />님 환영합니다.</p>
			<br>
        	<a href="/searcher/auth/login">로그아웃</a> <br>
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
		<sec:authorize access="hasRole('ROLE_ADMIN')">
		<a href="/searcher/access/admin">운영자</a>
		</sec:authorize>
    	</div>
    
	<div id="list">
        <ul>
            <li><a href="/searcher/recipe/list" >레시피 공유</a></li>
            <li><a href="/searcher/market/list" >전통시장</a></li>
            <li><a href="/searcher/local/map" >특산품</a></li>
        </ul>
    </div>
	</div>

</body>
</html>
