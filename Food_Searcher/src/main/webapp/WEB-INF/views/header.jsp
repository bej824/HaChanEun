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

#list .headerNavi {
	width : 100px; /* header 버튼에 할당된 길이 */
	list-style: none;
	padding:5px;
	border: 0;
	font-size: 100%;
	font: inherit;
	vertical-align: baseline;
    /* user agent 초기화 */
    
	font-size:16px;
	text-decoration:none;
	
	display: flex;
    justify-content: center; /* 수평 중앙 정렬 */
    text-align: center;      /* 텍스트 중앙 정렬 */
}

table {
	border-style: solid;
	border-radius: 4px;
	border-width: 1px;
	text-align: center;
}

li {
	text-align: none;
	text-decoration: none;
	display:inline-block;
	
}

ul, ol {
  list-style: none; /* 마커를 제거 */
  padding : 1px;
  margin: 1px;
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
    <!-- 네비게이션 바 -->
    <div class="navbar">
    	<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }">
    	
        <div id="front_img">
        <a href="/searcher/home">Home</a>
        </div>
    </div>
    
    <div id="boardArea">
    
     <div id="memberForm">
		<sec:authorize access="isAuthenticated() && hasRole('ROLE_ADMIN')">
		<a href="/searcher/admin/adminPage"><sec:authentication property="name" />님 환영합니다.</a>
		</sec:authorize>
		<sec:authorize access="isAuthenticated() && !hasRole('ROLE_ADMIN')">
			<p><sec:authentication property="name" />님 환영합니다.</p>
		</sec:authorize>
		<div class="myPage">
    	<sec:authorize access="hasRole('ROLE_MEMBER')">
        	<a href="/searcher/auth/login">로그아웃</a> <br>
        	<a href="/searcher/access/memberPage">마이페이지</a>
        	<a href="/searcher/seller/sellerManagement">관리페이지</a>
        </sec:authorize>
        <sec:authorize access="hasRole('ROLE_SELLER')">
        	<a href="/searcher/auth/login">로그아웃</a> <br>
        	<a href="/searcher/seller/sellerManagement">관리페이지</a>
        </sec:authorize>
        
   		<sec:authorize access="!isAuthenticated()">
        	<a href="/searcher/auth/login">로그인</a>
        	<a href="/searcher/access/registerEmail?select=register">회원가입</a>
    	</sec:authorize>
		</div>
    	</div>
    
	<div id="list">
        <ul>
            <li><a class="headerNavi" href="/searcher/recipe/list" >레시피 공유</a></li>
            <li><a class="headerNavi" href="/searcher/market/list" >전통시장</a></li>
            <li><a class="headerNavi" href="/searcher/local/list" >특산품</a></li>
            <li><a class="headerNavi" href="/searcher/item/list">상품</a></li>
        </ul>
    </div>
	</div>
	
	<script type="text/javascript">
		$(document).ajaxSend(function(e, xhr, opt){
			console.log("ajaxSend");
			
			var token = $("meta[name='_csrf']").attr("content");
			var header = $("meta[name='_csrf_header']").attr("content");
	
			xhr.setRequestHeader(header, token);
		});	 
	</script>

</body>
</html>
