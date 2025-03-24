<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<%@ include file ="layout/head.jsp" %>
<title>하찬은</title>
<style>
</style>

<link rel="stylesheet" type="text/css"
href="${pageContext.request.contextPath}/resources/css/Base.css">

<link rel="stylesheet" type="text/css"
href="${pageContext.request.contextPath}/resources/css/Detail.css">
<link rel="stylesheet" type="text/css"
href="${pageContext.request.contextPath}/resources/css/Reply.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath }/resources/css/image.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath }/resources/css/attach.css">
	<link rel="stylesheet"
	href="${pageContext.request.contextPath }/resources/css/Header.css">

<meta name="_csrf" content="${_csrf.token}">
<meta name="_csrf_header" content="${_csrf.headerName}">
<meta name="authenticatedUser" content="${authentication.name}">
</head>

<body>
<!-- 네비게이션 바 -->
    <div id="memberForm">
     	<sec:authorize access="hasRole('ROLE_MEMBER') && !hasRole('ROLE_SELLER')">
        <a href="/searcher/seller/authenticate" 
    	style="display: inline-block; margin-left: 100px; float: left;">판매자등록</a>
        </sec:authorize>
		<sec:authorize access="isAuthenticated() && hasRole('ROLE_ADMIN')">
		<a href="/searcher/admin/adminPage"><sec:authentication property="name" />님 환영합니다.</a>
		</sec:authorize>
		<sec:authorize access="isAuthenticated() && !hasRole('ROLE_ADMIN')">
			<a><sec:authentication property="name" />님</a> &nbsp;
		</sec:authorize>
    	<sec:authorize access="hasRole('ROLE_MEMBER') && !hasRole('ROLE_SELLER')">
        	<a href="/searcher/auth/logout">로그아웃</a> &nbsp;
        	<a href="/searcher/access/memberPage">마이페이지</a> &nbsp;
        </sec:authorize>
        <sec:authorize access="hasRole('ROLE_SELLER')">
        	<a href="/searcher/auth/logout">로그아웃</a> &nbsp;
        	<a href="/searcher/access/memberPage">마이페이지</a> &nbsp;
        	<a href="/searcher/seller/management">관리페이지</a>
        </sec:authorize>
        
   		<sec:authorize access="!isAuthenticated()">
        	<a href="/searcher/auth/login">로그인</a> &nbsp;
        	<a href="/searcher/access/registerEmail?select=register">회원가입</a>
    	</sec:authorize>
    </div>
<!-- 헤더 -->
<div class="navbar">
    <!-- 로고 -->
    <div class="logo">
        <a href="/searcher/home" class="Hachaneun">Hachaneun</a>
    </div>

    <!-- 네비게이션 메뉴 -->
    <div class="nav-menu">
        <a href="/searcher/recipe/list">레시피 공유</a>
        <a href="/searcher/local/list">특산품</a>
        <a href="/searcher/item/list">구매하기</a>
    </div>
</div>
	
	<script type="text/javascript">
		$(document).ajaxSend(function(e, xhr, opt){
			
			var token = $("meta[name='_csrf']").attr("content");
			var header = $("meta[name='_csrf_header']").attr("content");
	
			xhr.setRequestHeader(header, token);
		});	 
	</script>

</body>
</html>
