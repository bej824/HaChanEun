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
body {
	transform: none !important; 
    position: static !important;
    margin: 0 !important;
    top: auto !important;
    left: auto !important;
	margin: 20px;
	font-family: 'Noto Sans KR', sans-serif;
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

a, a:hover {
	color: black;
	text-decoration: none;
}

.myPage {
	color: black;
	font-size: 14px;
}

p {
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

    .button.selected {
        background-color: red;
        color: white;
    }

    .button:active {
        background-color: darkgreen;
    }

textarea[readonly] {
	width: 700px;
	height: 280px;
	padding: 12px 20px;
    background-color: #f2f2f2;
    resize: none;
}

textarea {
  width: 700px;
  height: 280px;
  padding: 12px 20px;
  box-sizing: border-box;
  border: 2px solid #ccc;
  border-radius: 4px;
  background-color: #f8f8f8;
  font-size: 16px;
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

#memberForm {
    box-sizing: border-box;
    text-align: right;
    padding-right: 100px;

    font-size: 14px;
    background-color: lightgray;
    white-space: nowrap;
    
    width: 100%;
    margin-left: 0;
    margin-right: 0;
    display: block;
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
	text-decoration: none;
	background-color : yellowgreen;
	text-align: center;
}

table {
	border-style: solid;
	border-radius: 4px;
	border-width: 1px;
	text-align: center;
}

.headerNavi {
    font-size: 30px;
    color: white;
    margin-right: 100px;
    margin-left: 100px;
    text-align: center; /* 부모에서 텍스트 중앙 정렬 */
}

.headerNavi a {
    display: inline-block;
    color: white;
    margin-right: 100px;
    margin-left: 100px;
    text-decoration: none; /* 기본 텍스트 꾸미기 제거 */
}

ul, ol {
  list-style: none; /* 마커를 제거 */
  padding : 1px;
  margin: 1px;
}

    .quick-scroll {
      position: fixed;
      bottom: 20px;
      right: 20px;
      display: flex;
      flex-direction: column;
      gap: 10px;
    }

    .quick-scroll button {
      background-color: green;
      color: white;
      border: none;
      padding: 10px 10px;
      font-size: 16px;
      cursor: pointer;
      border-radius: 5px;
      transition: background-color 0.3s ease;
    }

    .quick-scroll button:hover {
      background-color: #0056b3;
    }

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

<meta name="_csrf" content="${_csrf.token}">
<meta name="_csrf_header" content="${_csrf.headerName}">
<meta name="authenticatedUser" content="${authentication.name}">
</head>

<body>
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
    
    <!-- 네비게이션 바 -->
    <div class="navbar">
    	<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }">
    	
        <div id="front_img">
        <a href="/searcher/home">Home</a>
        </div>
        
    </div>
    
	<div id="list">
            <a class="headerNavi" href="/searcher/recipe/list" >레시피 공유</a>
            <a class="headerNavi" href="/searcher/local/list" >특산품</a>
            <a class="headerNavi" href="/searcher/item/list">상품</a>
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
