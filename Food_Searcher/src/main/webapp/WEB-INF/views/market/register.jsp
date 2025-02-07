<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.*, java.util.*"%>
<%@ page import="javax.servlet.http.*, javax.servlet.*"%>
<%@ page
	import="org.apache.commons.fileupload.*, org.apache.commons.fileupload.disk.*, org.apache.commons.fileupload.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet"
	href="../resources/css/Detail.css">
	<link rel="stylesheet"
	href="../resources/css/Base.css">

<style>
.image-drop {
    width: 200px;
    height: 200px;
    border: 2px dashed grey; /* 점선 테두리 */
    margin-bottom: 20px; /* 하단 여백 */
    text-align: center; /* 텍스트 가운데 정렬 */
    line-height: 200px; /* 높이와 동일한 라인 높이 */
    font-size: 16px; /* 폰트 크기 */
    color: grey; /* 텍스트 색상 */
}

/* 업로드된 이미지를 출력하는 영역에 대한 스타일 */
.image-list {
    margin-top: 20px; /* 상단 여백 */
    background-color: #f9f9f9; /* 배경색 */
    border: 1px solid #ddd; /* 실선 테두리 */
    padding: 5px; /* 안쪽 여백 */
    margin-bottom: 20px; /* 하단 여백 */
    height: 120px; /* 높이 */
    width: 500px; /* 너비 */
}

/* 업로드된 이미지에 대한 스타일 */
.image_item {
    margin-left: 10px; /* 왼쪽 여백 */
    position: relative; /* 상대적 위치 지정 */
    display: inline-block; /* 인라인 블록으로 표시 */
    margin: 4px; /* 여백 */
}

</style>

<meta charset="UTF-8">
<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<title>Insert title here</title>

</head>
<body>
<%@ include file="/WEB-INF/views/header.jsp"%>
<div id="area">

		<sec:authorize access="isAnonymous()">
			<script type="text/javascript">
				alert('로그인이 필요합니다.');
				window.history.back();
			</script>
		</sec:authorize>
		
	<h2>글 작성 페이지</h2>
	
	<form id="registerForm" action="register" method="POST">
	<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }">
	
		<div>
			<p>제목 :</p>
			<input type="text" id="makretTitle" name="marketTitle" placeholder="제목 입력"
				maxlength="20" required>
		</div>
		
		<div>
			<p>음식 : </p>
			<input type="text" id="marketFood" name="marketFood" placeholder="음식 이름 입력" maxlength="100" required>
		</div>
		
		<div>
			<p>가게 : </p>
			<input type="text" id="marketName" name="marketName" placeholder="가게 이름 입력" maxlength="100" required>
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
</form>		

		<!-- https://news.seoul.go.kr/economy/archives/66052 -->

		<br>

			<br>
			<p>내용 :</p>
			<textarea rows="20" cols="120" name="marketContent"
				placeholder="내용 입력" maxlength="300" required></textarea>
			<br> <button id="registerMarket"> 등록 </button>
		</div>
	<script>
	
	$(document).ajaxSend(function(e, xhr, opt){
		console.log("ajaxSend");
		
		var token = $("meta[name='_csrf']").attr("content");
		var header = $("meta[name='_csrf_header']").attr("content");

		xhr.setRequestHeader(header, token);
	});
	

	</script>

</body>
</html>
