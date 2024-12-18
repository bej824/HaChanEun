<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<!-- jquery 라이브러리 import -->
<script src="https://code.jquery.com/jquery-3.7.1.js">
</script>
<style type="text/css">
.button, .btn_update, .btn_delete, .btn_comment {
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
	<%session.getAttribute("memberId"); %>
	<h2>글 보기</h2>
	<div>
		<p>글 번호 : ${LocalSpecialityVO.localId }</p>
	</div>
	<div>
		<p>제목 : ${LocalSpecialityVO.localTitle }</p>
	</div>
	<div>
		<p>지역 : ${LocalSpecialityVO.localLocal }</p>
		<p>상세 : ${LocalSpecialityVO.localDistrict }</p>
	</div>
	<div>
		<textarea rows="20" cols="120" readonly>${LocalSpecialityVO.localContent }</textarea>
	</div>
	
	<button onclick="location.href='map'" class="button">글 목록</button>
		<button class="button">글 수정</button>
		<button id="deleteBoard" class="button" disabled>글 삭제</button>
	<button class="button">글 수정</button>
	<button id="deleteBoard" class="button">글 삭제</button>
			<button class="button" disabled>글 수정</button>
			<button id="deleteBoard" class="button" disabled>글 삭제</button>
	
	<script type="text/javascript">
	
	</script>
</body>
</html>