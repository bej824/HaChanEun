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
	<input type="hidden" name="email" id ="email" value="${email }">
	</form>
	
	<button id="btn_register" class="button" onclick="idSearch()">ID 찾기</button>
	
		<hr>

		<c:if test="${not empty memberVO }">
		<p>${memberVO.memberName }님의 ID는</p>
		<p>${memberVO.memberId }입니다.</p>
		
		<c:if test="${memberVO. memberStatus == 'inactive'}">

		<div id = "msg">
		현재 비활성화 상태입니다.
		활성화 후 로그인 가능합니다.
		</div>
		
		<button id = active onclick = "active()" class="button">활성화</button>

		</c:if>
		
		<c:if test="${memberVO. memberStatus == 'active'}">
		<a href="registerEmail?select=pwSearch" class="button">PW 찾기</a>		
		</c:if>
		</c:if>

		<c:if test="${empty memberVO }">
			<p>memberID 출력부분</p>
		</c:if>

	<script type="text/javascript">
	
		function active(){
			let memberId = '${memberVO.memberId }';
			let memberStatus = 'active';
			let msg = document.getElementById('msg');
			
			console.log(status);
			
			$.ajax({
			    type: 'POST',
			    url: '../access/statusUpdate',
			    data: { memberId: memberId,
			    	memberStatus: memberStatus},
			    success: function(result) {
			      if (result == '1') {
					msg.html('활성화되었습니다.');
			      } else {
			    	msg.html('다시 시도해주세요.');
			      }
			    }
			  });
			
		}
		
		function idSearch(){
			document.getElementById("ID").submit();
		}
	</script>


</body>
</html>