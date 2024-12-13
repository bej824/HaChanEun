<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>${recipeVO.recipeTitle }</title>
</head>
<body>
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
			<input type="submit" value="등록">
		</div>
	</form>
</body>
</html>