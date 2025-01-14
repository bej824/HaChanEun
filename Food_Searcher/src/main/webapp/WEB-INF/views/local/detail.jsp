<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<!-- jquery 라이브러리 import -->
<script src="https://code.jquery.com/jquery-3.7.1.js">
	
</script>
<style type="text/css">
.comment_item {
	margin-left: 30px; /* 대댓글은 부모 댓글보다 30px 들여쓰기 */
	margin-bottom: 10px;
}

.disabled {
	opacity: 0.6;
	cursor: not-allowed;
}

textarea {
	width: 700px;
	height: 280px;
	padding: 12px 20px;
	box-sizing: border-box;
	border: 2px solid #ccc;
	border-radius: 4px;
	background-color: rgb(240, 240, 240, 0);
	font-size: 16px;
	resize: none;
}
</style>
<meta charset="UTF-8">
<title>${LocalSpecialityVO.localTitle }</title>
</head>
<body>
	<%@ include file ="../header.jsp" %>
	<h2>글 보기</h2>
	<form id="updateForm" action="update" method="post">
	<div>
		<input type="hidden" id="Id" name="Id"
			value="${LocalSpecialityVO.localId }">
		<input type="hidden" id="localId" name="localId"
			value="${LocalSpecialityVO.localId }">
	</div>
	<div>
		<p>지역 : ${LocalSpecialityVO.localLocal } / ${LocalSpecialityVO.localDistrict }</p>
	</div>
	<div>
		<p>특산품 : ${LocalSpecialityVO.localTitle }</p>
	</div>
	<div>
    <sec:authorize access="hasRole('ROLE_ADMIN')">
        <textarea rows="20" cols="120" name="localContent">${LocalSpecialityVO.localContent }</textarea>
    </sec:authorize>
    <sec:authorize access="!hasRole('ROLE_ADMIN')">
        <textarea rows="20" cols="120" readonly>${LocalSpecialityVO.localContent }</textarea>
    </sec:authorize>
	</div>
	</form>
	
	<button onclick="index()" class="button">글 목록</button>
	<sec:authorize access="hasRole('ROLE_ADMIN')">
	<button onclick="update()" class="button">글 수정</button>
	<button id="deleteBoard" class="button" disabled>글 삭제</button>	
	</sec:authorize>
	
	<%@ include file ="reply.jsp" %>
	
	<script type="text/javascript">
	
	function update() {
		let result = confirm("수정하시겠습니까?");
		if (result) {
		document.getElementById("updateForm").submit();
		} else {
			alert("수정이 취소되었습니다.");
		}
	} // end update()
	
		
	function index() {
		let localLocal = '${localLocal }'
		let localDistrict = '${localDistrict }'
		window.location.href='map?localLocal=${localLocal }&localDistrict=${localDistrict }';
	}
	
	</script>

</body>
</html>