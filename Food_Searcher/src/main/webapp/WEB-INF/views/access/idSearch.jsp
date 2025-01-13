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
	<form id="idSearchForm" action = "idSearch" method="POST">
	회원 이름 : <input type="text" id="memberName" name="memberName" value="${memberName}" placeholder="ID를 입력해주세요." required> <br>
	<input type="hidden" name="email" id ="email" value="${email }">
	<!-- CSRF 토큰 -->
	<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }">
	</form>
	
	<button id="btn_register" class="button" onclick="idSearch()">ID 찾기</button>
	
		<hr>

		<c:if test="${not empty memberVO }">
		<p>${memberVO.memberName }님의 ID는</p>
		<p>${memberVO.memberId }입니다.</p>
		
		<c:if test="${memberVO. memberStatus == 'inactive'}">

		<p id = "msg">
		현재 비활성화 상태입니다.
		활성화 후 로그인 가능합니다.
		</p>
		
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
			
			const csrfToken = document.querySelector('meta[name="_csrf"]').getAttribute('content');
		    const csrfHeader = document.querySelector('meta[name="_csrf_header"]').getAttribute('content');
			
			console.log(status);
			
			$.ajax({
			    type: 'POST',
			    url: '../access/statusUpdate',
			    data: { memberId: memberId,
			    	memberStatus: memberStatus},
			    beforeSend: function (xhr) {
		             xhr.setRequestHeader(csrfHeader, csrfToken);  // CSRF 토큰을 헤더에 설정
		            },
			    success: function(result) {
			    	console.log(result);
			      if (result == 1) {
			    	  alert("활성화되었습니다.");
			    	  window.location.href = "login";
			      } else {
			    	  alert("다시 시도해주세요.");
			      }
			    }
			  });
			
		}
		
		function idSearch(){
			document.getElementById("idSearchForm").submit();
		}
	</script>


</body>
</html>