<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 페이지</title>
</head>
<body>
<jsp:include page="../header.jsp" />
<h1>등급 : ${roleVO.roleName }</h1>
<form action="roleUpdate" method="post">
<input type="text" id="memberId" placeholder="운영자 등업 id" required> <br> <br>
</form>
<button class="button" onclick="update()">등급 업</button>

	<script type="text/javascript">
		function update() {
			let memberId = document.getElementById("memberId").value;
			let result = confirm(memberId + "님을 운영자 등록시키겠습니까?");
			if (result) {
			document.getElementById("roleUpdate").submit();
			} else {
				alert("취소되었습니다.");
			}
		}
	</script>

</body>
</html>