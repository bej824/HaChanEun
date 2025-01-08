<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비밀번호 수정 헤더</title>
</head>
<body>
	<form id="pwUpdateForm" action="pwUpdate" method="POST">
	
	<c:if test="${session.memberId == null}">
	<p>아이디</p>
	<input type="text" name="memberId" id="memberId" placeholder="아이디 입력"
			required>
	</c:if>
	<c:if test="${session.memberId != null}">
	<input type="hidden" name="memberId" id="memberId" value="${session.memberId }">
	</c:if>
	
	<br>
	
	<p>새로운 비밀번호</p>
		<input type=password name="password" id="password"
			placeholder="비밀번호 입력" required> <br>

	<p>비밀번호 재입력</p>
		<input type=password name="password2" id="password2"
			placeholder="비밀번호 입력" required> <br>
	</form>
	
	<button class="button" name="update" onclick="update()">비밀번호 수정</button>
	
	<script type="text/javascript">
	
	function update() {
	 const password = document.getElementById("password").value;
	 const password2 = document.getElementById("password2").value;
	 
	// 비밀번호와 비밀번호 재입력이 일치하는지 확인
    if (password !== password2) {
      alert("비밀번호와 비밀번호 확인이 일치하지 않습니다.");
      return;
    } else {
		document.getElementById("pwUpdateForm").submit();
    }
	
	}
	
	</script>
	
</body>
</html>