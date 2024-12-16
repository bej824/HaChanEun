<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>전통시장</title>
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
</head>
<body>
	<!-- 게시글 -->
	<h2>글 보기</h2>
	<div>
		<p>글 번호 : ${MarketVO.marketId }</p>
	</div>
	<div>
		<p>제목 :</p>
		<p>${MarketVO.marketTitle }</p>
	</div>
	<button onclick="location.href='list'">글 목록</button>
	<button onclick="location.href='modify?marketId=${marketVO.marketId }'">글
		수정</button>
	<button id="deleteMarket">글 삭제</button>
	<form id="deleteForm" action="delete" method="POST">
		<input type="hidden" name="marketId" value="${marketVO.marketId }">
	</form>

	<script type="text/javascript">
		$(document).ready(function() {
			$('#deleteMarket').click(function() {
				if (confirm('삭제하시겠습니까?')) {
					$('#deleteForm').submit(); // form 데이터 전송
				}
			});
		}); // end document
	</script>


</body>
</html>