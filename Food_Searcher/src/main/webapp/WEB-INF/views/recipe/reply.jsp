<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<style>
/* 댓글창을 감싸는 replyBox 스타일 */
.replyBox {
	width: 100%;
	max-width: 600px; /* 댓글 창의 최대 너비 */
	margin: 20px auto; /* 화면 중앙에 배치 */
	padding: 15px 20px; /* 패딩을 조정해서 더 컴팩트하게 */
	border: 1px solid #ddd; /* 테두리 */
	border-radius: 10px; /* 둥근 테두리 */
	box-sizing: border-box; /* 패딩을 포함한 크기 계산 */
}

/* 댓글 입력란 스타일 (왼쪽 정렬) */
.replyBox input[type="text"] {
	width: 70%;
	padding: 10px;
	font-size: 14px;
	border: 1px solid #ccc;
	border-radius: 5px;
	background-color: #fff;
	margin-top: 5px; /* 댓글 입력란과 제목 간의 간격을 줄임 */
	outline: none;
	box-sizing: border-box; /* padding 포함 */
	text-align: left; /* 왼쪽 정렬 */
}

/* 댓글 리스트 스타일 */
.replyBox .reply-list {
	margin-top: 20px;
	padding: 0;
	list-style: none;
}

.replyMemberId {
	font-size: 14px;
	color: #505050;
}

.timeButton {
	text-align: right;
}

.comment {
	width: 70%;
	max-width: 500px; /* 댓글 창의 최대 너비 */
	padding: 15px 20px; /* 패딩을 조정해서 더 컴팩트하게 */
	box-sizing: border-box; /* 패딩을 포함한 크기 계산 */
}

.btn_update, .btn_delete, .comment_update, .comment_delete, .comment_add, .btn_comment {
	background-color: #04AA6D;
	border: none;
	color: white;
	padding: 6px 12px;
	text-align: center;
	text-decoration: none;
	display: inline-block;
	margin: 4px 2px;
	cursor: pointer;
	float: right;
}

.btn_update:disabled, .btn_delete:disabled, .comment_update:disabled, .comment_delete:disabled, .comment_add:disabled {
    display: none;
}


.btn_add {
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
	float: right;
}
</style>

<meta charset="UTF-8">
<title>댓글 헤더</title>
</head>
<body>
	<div class="replyBox">
		<div id="replies"></div>

	</div>

</body>
</html>