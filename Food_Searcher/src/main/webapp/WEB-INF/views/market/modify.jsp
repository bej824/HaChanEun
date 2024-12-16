<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>${marketVO.marketTitle }</title>
</head>
<body>
	<h2>글 수정 페이지</h2>
	<form action="modify" method="POST">

		<div>
			<p>제목 :</p>
			<input type="text" name="marketTitle" placeholder="제목 입력"
				maxlength="30" value="${marketVO.marketTitle }" required>
		</div>

		<div>
			<p>글 번호 :</p>
			<input type="text" name="marketId" value="${marketVO.marketId }"
				readonly>
		</div>

		<div>
			<p>지역 :</p>
			<input type="text" name="marketLocal" maxlength="50" required>
		</div>

		<div>
			<p>내용 :</p>
			<textarea rows="20" cols="120" name="marketContent"
				placeholder="내용 입력" maxlength="300" required>${marketVO.marketContent }</textarea>
		</div>

		<!-- 사진 파일 수정은 어떻게...? -->

		<div>
			<input type="submit" value="등록">
		</div>
	</form>
</body>
</html>