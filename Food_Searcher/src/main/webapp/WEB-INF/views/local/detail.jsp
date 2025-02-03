<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet"
	href="../resources/css/Detail.css">
		<link rel="stylesheet"
	href="../resources/css/Base.css">
<!-- jquery 라이브러리 import -->
<script src="https://code.jquery.com/jquery-3.7.1.js">
	
</script>
<style type="text/css">


.disabled {
	opacity: 0.6;
	cursor: not-allowed;
}

</style>
<meta charset="UTF-8">
<title>${localSpecialityVO.localTitle }</title>
</head>
<body>
	<%@ include file ="../header.jsp" %>
	<div id="area">
	<h2>글 보기</h2>
	<form id="updateForm" action="update" method="post">
	<div>
		<input type="hidden" id="Id" name="Id"
			value="${localSpecialityVO.localId }">
		<input type="hidden" id="localId" name="localId"
			value="${localSpecialityVO.localId }">
	</div>
	<div>
		<p>지역 : ${localSpecialityVO.localLocal } / ${localSpecialityVO.localDistrict }</p>
	</div>
	<div>
		<p>특산품 : ${localSpecialityVO.localTitle }</p>
	</div>
	<div>
    <sec:authorize access="hasRole('ROLE_ADMIN')">
        <textarea rows="20" cols="120" name="localContent">${localSpecialityVO.localContent }</textarea>
    </sec:authorize>
    <sec:authorize access="!hasRole('ROLE_ADMIN')">
        <textarea rows="20" cols="120" readonly>${localSpecialityVO.localContent }</textarea>
    </sec:authorize>
	</div>
	<!-- CSRF 토큰 -->
	<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }">
	</form>
	
	<button id="btn_index" class="button">글 목록</button> <br>
	<sec:authorize access="hasRole('ROLE_ADMIN')">
	<button id="btn_update" class="button">글 수정</button> <br>
	<button id="deleteBoard" class="button" disabled>글 삭제</button> <br>	
	</sec:authorize>
	
	<button class="button">레시피 확인하기</button> <br>
	<button class="button">맛집 확인하기</button> <br>
	<%@ include file ="reply.jsp" %>
	
	</div>
	
	<script type="text/javascript">
	
	$(document).ready(function(){
		
		console.log('${localLocal}', '${localDistrict}', '${localTitle}');
		console.log('${localSpecialityVO.localLocal }', '${localSpecialityVO.localDistrict }', '${localSpecialityVO.localTitle }');
			
	$('#btn_update').click(function(){
		let result = confirm("수정하시겠습니까?");
		if (result) {
		document.getElementById("updateForm").submit();
		} else {
			alert("수정이 취소되었습니다.");
		}
	})
	
		
	$('#btn_index').click(function(){
		let localLocal = '${localLocal }';
		let localDistrict = '${localDistrict }';
		let localTitle = '${localTitle}';
		
		if(localLocal != "" && localLocal != '${localSpecialityVO.localLocal }'){
			localLocal = "";
			localDistrict = "";
		}
		if(localDistrict != "" && localDistrict != '${localSpecialityVO.localDistrict }'){
			localDistrict = "";
		}
		if(localTitle != "" && localTitle != '${localSpecialityVO.localTitle }'){
			localTitle = "";
		}
		
		window.location.href='map?localLocal='+ localLocal +'&localDistrict=' + localDistrict + '&localTitle=' + localTitle;
	})
	
	})
	</script>

</body>
</html>