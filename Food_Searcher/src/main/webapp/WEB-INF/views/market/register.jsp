<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.*, java.util.*"%>
<%@ page import="javax.servlet.http.*, javax.servlet.*"%>
<%@ page
	import="org.apache.commons.fileupload.*, org.apache.commons.fileupload.disk.*, org.apache.commons.fileupload.servlet.*"%>
<!DOCTYPE html>
<html>
<head>

<style type="text/css">
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


</style>
<link rel="stylesheet"
	href="../resources/css/Base.css">
<meta charset="UTF-8">
<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<title>Insert title here</title>

</head>
<body>
<%@ include file="/WEB-INF/views/header.jsp"%>
		<div id="container">
	    <div id="homeArea">
		<sec:authorize access="hasRole('ROLE_MEMBER')">
			<script type="text/javascript">
				alert('관리자만 접근이 가능합니다.');
				window.history.back();
			</script>
		</sec:authorize>
		
		<sec:authorize access="isAnonymous()">
			<script type="text/javascript">
				alert('로그인이 필요합니다.');
				window.history.back();
			</script>
		</sec:authorize>
		
	<h2>글 작성 페이지</h2>
	
	<form action="register" method="POST">
	<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }">

		<div>
			<p>제목 :</p>
			<input type="text" id="makretTitle" name="marketTitle" placeholder="제목 입력"
				maxlength="20" required>
		</div>
		
		<sec:authentication property="principal" var="principal"/>

		<div>
			<p>지역 :</p>
			<select name="marketLocal">
				<option value="종로">종로</option>
				<option value="서대문구">서대문구</option>
				<option value="도봉구">도봉구</option>
				<option value="양천구">양천구</option>
				<option value="성동구">성동구</option>
				<option value="노원구">노원구</option>
				<option value="중구">중구</option>
				<option value="중랑구">중랑구</option>
				<option value="용산구">용산구</option>
				<option value="광진구">광진구</option>
				<option value="마포구">마포구</option>
				<option value="관악구">관악구</option>
				<option value="금천구">금천구</option>
				<option value="강서구">강서구</option>
				<option value="강동구">강동구</option>
				<option value="은평구">은평구</option>
				<option value="성북구">성북구</option>
				<option value="동대문구">동대문구</option>
				<option value="강북구">강북구</option>
				<option value="강남구">강남구</option>
				<option value="영등포구">영등포구</option>




			</select>
		</div>

		<!-- https://news.seoul.go.kr/economy/archives/66052 -->

		<br>

		<div>

			<p>내용 :</p>
			<div class="addImage" id="imageShow">
				<!-- 이미지 띄울 공간 -->
			</div>
			<input type="file" accept="image/*" onchange="loadFile(this)">

			<br>
			<textarea rows="20" cols="120" name="marketContent"
				placeholder="내용 입력" maxlength="300" required></textarea>
			<br> <input type="submit" value="등록">

		
		</div>


	</form>
	</div>
	<%@ include file="/WEB-INF/views/boardArea.jsp" %>
	</div>
</body>
</html>
