<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<style type="text/css">
textarea {
  width: 700px;
  height: 280px;
  padding: 12px 20px;
  box-sizing: border-box;
  border: 2px solid #ccc;
  border-radius: 4px;
  background-color: #f8f8f8;
  font-size: 16px;
  resize: none;
}
</style>
<meta charset="UTF-8">
<title>${recipeVO.recipeTitle }</title>
</head>
<body>
	<%@ include file ="../header.jsp" %>
	<h2>글 수정 페이지</h2>
	<form action="modify" method="POST">
		<div>
			<p>번호 : ${recipeVO.recipeId }</p>
			<input type="hidden" name="recipeId" value="${recipeVO.recipeId }" readonly>
		</div>
		<div>
			<p>제목 : </p>
			<input type="text" name="recipeTitle" placeholder="제목 입력" 
maxlength="20" value="${recipeVO.recipeTitle }" required>
		</div>
		<div>
			<p>작성자 : ${recipeVO.memberId}</p>
			<input type="hidden" name="memberId" value="${recipeVO.memberId}">
			
		</div>
		<div>
			<p>음식 : </p>
			<input type="text" name="recipeFood" value="${recipeVO.recipeFood }" required>
		</div>
		<div>
			<p>내용 : </p>
			<textarea rows="20" cols="120" name="recipeContent" placeholder="내용 입력" 
maxlength="300" required>${recipeVO.recipeContent }</textarea>
		</div>
		<div>
			<input type="submit" value="등록" class="button">
			<button onclick="goBack()" class="button">뒤로가기</button>
		</div>
		
<script>
function goBack() {
  const referrer = document.referrer;
  if (referrer) {
    window.location.href = referrer;  // 이전 페이지로 이동
  } else {
    alert("이전 페이지가 없습니다.");
  }
}
</script>
	</form>
</body>
</html>