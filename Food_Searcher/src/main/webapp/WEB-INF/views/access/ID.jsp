<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page import="com.food.searcher.domain.MemberVO" %>
<!DOCTYPE html>
<html>
<head>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<%@ include file ="../header.jsp" %>
		<h1>ID 찾기</h1>
	<form id="ID" action = "ID" method="POST">
	회원 이름 : <input type="text" id="memberName" name="memberName" value="${memberName}" placeholder="ID를 입력해주세요." required> <br>
	<input type="hidden" id="memberId">
	<div id="confirmMsg" class="message" style="color: red;"></div>
	<input type="hidden" name="email" id ="email" value="${email }">
	</form>
	
	<button id="btn_register" class="button" onclick="idSearch()">인증</button>
	
		<hr>

		<c:if test="${not empty memberVO }">
		<script>
        let memberId = "${memberVO.memberId}";  // memberVO.memberId 값을 JavaScript 변수에 저장
    </script>
		<p>${memberVO.memberName }님의 ID는</p>
		<p>${memberVO.memberId }입니다.</p>
		</c:if>

		<c:if test="${empty memberVO }">
			<p>memberID 출력부분</p>
		</c:if>

	<script type="text/javascript">
		
		function idSearch(){
			document.getElementById("ID").submit();
		}
	</script>


</body>
</html>