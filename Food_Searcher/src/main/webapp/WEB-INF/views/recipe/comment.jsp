<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h1>대댓글</h1>
	<form action="comment" method="POST">
		<div>
			<p>게시글 번호 : ${replyVO.boardId }</p>
			<input type="hidden" name="recipeId" value="${replyVO.replyId }" readonly>
			<p>유저 ID : ${replyVO.memberId }</p>
			<p>댓글 : ${replyVO.replyContent }</p>
		</div>
		<div>
			<input type="submit" value="등록">
		</div>
	</form>
</body>
</html>