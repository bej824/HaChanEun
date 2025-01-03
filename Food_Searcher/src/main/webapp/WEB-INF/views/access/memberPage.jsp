<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 개인 정보</title>
</head>
<body>

	<%@ include file ="../header.jsp" %>
	<h1>Member Page</h1>

	<form id="updateForm" action="update" method="post">
		<p>아이디 : ${vo.memberId }</p>
		<input type="hidden" name="memberId" value="${vo.memberId }">

		<p>이름 : ${vo.memberName }</p>

		<p>
			성별 :
			<c:if test="${vo.memberGender == 'male'}">
		남성 
		</c:if>
			<c:if test="${vo.memberGender == 'female'}">
		여성 
		</c:if>
		</p>
		<p>나이 : ${vo.memberAge }</p>

		<p>별자리 : ${vo.memberConstellation }</p>

		<p>
			MBTI : <select name="memberMBTI" id="mbti">
				<!-- MBTI 유형 옵션 -->
				<option value=" "
					<c:if test="${vo.memberMBTI == ' '}">selected</c:if>> </option>
				<option value="ISTJ"
					<c:if test="${vo.memberMBTI == 'ISTJ'}">selected</c:if>>ISTJ</option>
				<option value="ISFJ"
					<c:if test="${vo.memberMBTI == 'ISFJ'}">selected</c:if>>ISFJ</option>
				<option value="INFJ"
					<c:if test="${vo.memberMBTI == 'INFJ'}">selected</c:if>>INFJ</option>
				<option value="INTJ"
					<c:if test="${vo.memberMBTI == 'INTJ'}">selected</c:if>>INTJ</option>
				<option value="ISTP"
					<c:if test="${vo.memberMBTI == 'ISTP'}">selected</c:if>>ISTP</option>
				<option value="ISFP"
					<c:if test="${vo.memberMBTI == 'ISFP'}">selected</c:if>>ISFP</option>
				<option value="INFP"
					<c:if test="${vo.memberMBTI == 'INFP'}">selected</c:if>>INFP</option>
				<option value="INTP"
					<c:if test="${vo.memberMBTI == 'INTP'}">selected</c:if>>INTP</option>
				<option value="ESTP"
					<c:if test="${vo.memberMBTI == 'ESTP'}">selected</c:if>>ESTP</option>
				<option value="ESFP"
					<c:if test="${vo.memberMBTI == 'ESFP'}">selected</c:if>>ESFP</option>
				<option value="ENFP"
					<c:if test="${vo.memberMBTI == 'ENFP'}">selected</c:if>>ENFP</option>
				<option value="ENTP"
					<c:if test="${vo.memberMBTI == 'ENTP'}">selected</c:if>>ENTP</option>
				<option value="ESTJ"
					<c:if test="${vo.memberMBTI == 'ESTJ'}">selected</c:if>>ESTJ</option>
				<option value="ESFJ"
					<c:if test="${vo.memberMBTI == 'ESFJ'}">selected</c:if>>ESFJ</option>
				<option value="ENFJ"
					<c:if test="${vo.memberMBTI == 'ENFJ'}">selected</c:if>>ENFJ</option>
				<option value="ENTJ"
					<c:if test="${vo.memberMBTI == 'ENTJ'}">selected</c:if>>ENTJ</option>
			</select>
		</p>

		<p> 이메일 : ${vo.email }</p>
			<input type="hidden" name="email" value="${vo.email }" readonly="readonly">

		<p>이메일 광고 수신 동의</p>
		<c:if test="${vo.emailAgree == 'yes'}">
			<input type="radio" name="emailAgree" value="yes" checked="checked">예
		<input type="radio" name="emailAgree" value="no">아니오
	</c:if>
		<c:if test="${vo.emailAgree == 'no'}">
			<input type="radio" name="emailAgree" value="yes">예
		<input type="radio" name="emailAgree" value="no" checked="checked">아니오
	</c:if>
	</form>

	<form id=deleteForm action="delete" method="post">
		<input type="hidden" name="memberId" value="${vo.memberId }">
	</form>
	
	<br>

	<button onclick="update()" class="button">수정하기</button>
	<button onclick="deleteMember()" class="button">회원탈퇴</button>
	
	<br>
	<a href="/searcher/access/admin">운영자</a>

	<script type="text/javascript">
		function update() {
			let result = confirm("수정하시겠습니까?");
			if (result) {
			document.getElementById("updateForm").submit();
			} else {
				alert("수정이 취소되었습니다.");
			}
		}
	</script>

	<script type="text/javascript">
		function deleteMember() {
			let result = confirm("회원 탈퇴하시겠습니까?");
			if (result) {
				document.getElementById("deleteForm").submit();
				alert("이용해주셔서 감사합니다.");
				} else {
					alert("취소되었습니다.");
				}
		}
	</script>


</body>
</html>