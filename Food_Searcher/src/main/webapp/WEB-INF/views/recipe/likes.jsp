<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<style type="text/css">
	.container {
      display: flex;
      justify-content: center;  /* 수평 중앙 정렬 */
    }
    
    #up, #down, #upfill, #downfill, #noup, #nodown:hover {
      cursor: pointer;  /* 마우스가 아이콘 위에 올려지면 손 모양으로 변경 */
    }
</style>
<meta charset="UTF-8">
<title>좋아요 영역</title>
</head>
<body>
	<sec:authorize access="isAnonymous()">
	<div class="container">
	<i id="noup" class="bi bi-hand-thumbs-up" style="font-size:26px;color:red;">좋아요${recipeVO.likesCount }&nbsp;&nbsp;</i>
	<i id="nodown" class="bi bi-hand-thumbs-down" style="font-size:26px;color:blue;">싫어요${recipeVO.dislikesCount }</i>
	</div>
	</sec:authorize>
	<sec:authorize access="isAuthenticated()">
	<div class="container">
	<c:if test="${likesVO.memberLike eq 1}" >
	<i id="upfill"class="bi bi-hand-thumbs-up-fill" style="font-size:26px;color:red;">좋아요${recipeVO.likesCount }&nbsp;&nbsp;</i>
	</c:if>
	<c:if test="${likesVO.memberLike eq 0 or likesVO.memberLike eq 2 or likesVO.memberLike eq null}" >
	<i id="up" class="bi bi-hand-thumbs-up" style="font-size:26px;color:red;">좋아요${recipeVO.likesCount }&nbsp;&nbsp;</i>
	</c:if>
	<c:if test="${likesVO.memberLike eq 2}" >
	<i id="downfill" class="bi bi-hand-thumbs-down-fill" style="font-size:26px;color:blue;">싫어요${recipeVO.dislikesCount }</i>
	</c:if>
	<c:if test="${likesVO.memberLike eq 0 or likesVO.memberLike eq 1 or likesVO.memberLike eq null}" >
	<i id="down" class="bi bi-hand-thumbs-down" style="font-size:26px;color:blue;">싫어요${recipeVO.dislikesCount }</i>
	</c:if>
	
	</div>
	
	<script type="text/javascript">
	$(document).ready(function(){
		$('#up').click(function(){
			let boardId = $('#recipeId').val();
			let memberId = $('#memberId').val();
			
			if("${likesVO.memberLike}" == ""){			
			let memberLike = 1;
			let obj = {
					'recipeId' : boardId,
					'memberId' : memberId,
					'memberLike' : memberLike
			}
			if("<sec:authentication property="name" />" != "${likesVO.memberId}") {
			$.ajax({
				type : 'POST',
				url : '../likes',
				headers : { // 헤더 정보
					'Content-Type' : 'application/json' // json content-type 설정
				}, 
				data : JSON.stringify(obj),
				success : function(result) {
					if(result == 1) {
						alert('좋아요!');
						location.reload();
					}
				}
			});
			}
			} else if("${likesVO.memberLike}" == "0") {
				let memberLike = 1;
				let obj = {
						'recipeId' : boardId,
						'memberId' : memberId,
						'memberLike' : memberLike
				}
				
				$.ajax({
					type : 'PUT',
					url : '../likes/' + boardId,
					headers : { // 헤더 정보
						'Content-Type' : 'application/json' // json content-type 설정
					}, 
					data : JSON.stringify(obj),
					success : function(result) {
						if(result == 1) {
							alert('좋아요!');
							location.reload();
						}
					}
				});
			} else if("${likesVO.memberLike}" == "2") {
				let memberLike = 1;
				let previousMemberLike = 2;
				let obj = {
						'recipeId' : boardId,
						'memberId' : memberId,
						'memberLike' : memberLike,
						'previousMemberLike' : previousMemberLike
				}
				$.ajax({
					type : 'PUT',
					url : '../likes/' + boardId,
					headers : { // 헤더 정보
						'Content-Type' : 'application/json' // json content-type 설정
					}, 
					data : JSON.stringify(obj),
					success : function(result) {
						if(result == 1) {
							alert('좋아요! 변경');
							location.reload();
						}
					}
				});
			}
		});
		
		$('#upfill').click(function(){
			let boardId = $('#recipeId').val();
			let memberId = $('#memberId').val();
			
			 if("${likesVO.memberLike}" == "1") {
					let memberLike = 0;
					let previousMemberLike = 1;
					let obj = {
							'recipeId' : boardId,
							'memberId' : memberId,
							'memberLike' : memberLike,
							'previousMemberLike' : previousMemberLike
					}
					
					$.ajax({
						type : 'PUT',
						url : '../likes/' + boardId,
						headers : { // 헤더 정보
							'Content-Type' : 'application/json' // json content-type 설정
						}, 
						data : JSON.stringify(obj),
						success : function(result) {
							if(result == 1) {
								alert('좋아요 취소');
								location.reload();
							}
						}
					});
				}
		});
		
		
		$('#down').click(function(){
			let boardId = $('#recipeId').val();
			let memberId = $('#memberId').val();
			
			if("${likesVO.memberLike}" == ""){
				let memberLike = 2;
				
				let obj = {
						'recipeId' : boardId,
						'memberId' : memberId,
						'memberLike' : memberLike
				}
				if("<sec:authentication property="name" />" != "${likesVO.memberId}") {
				$.ajax({
					type : 'POST',
					url : '../likes',
					headers : { // 헤더 정보
						'Content-Type' : 'application/json' // json content-type 설정
					}, 
					data : JSON.stringify(obj),
					success : function(result) {
						if(result == 1) {
							alert('싫어요!');
							location.reload();
						}
					}
				});
				}
			} else if("${likesVO.memberLike}" == "0") {
				let memberLike = 2;
				
				let obj = {
						'recipeId' : boardId,
						'memberId' : memberId,
						'memberLike' : memberLike
				}
				
				$.ajax({
					type : 'PUT',
					url : '../likes/' + boardId,
					headers : { // 헤더 정보
						'Content-Type' : 'application/json' // json content-type 설정
					}, 
					data : JSON.stringify(obj),
					success : function(result) {
						if(result == 1) {
							alert('싫어요!');
							location.reload();
						}
					}
				});
			} else if("${likesVO.memberLike}" == "1") {
				let memberLike = 2;
				let previousMemberLike = 1;
				let obj = {
						'recipeId' : boardId,
						'memberId' : memberId,
						'memberLike' : memberLike,
						'previousMemberLike' : previousMemberLike
				}
				$.ajax({
					type : 'PUT',
					url : '../likes/' + boardId,
					headers : { // 헤더 정보
						'Content-Type' : 'application/json' // json content-type 설정
					}, 
					data : JSON.stringify(obj),
					success : function(result) {
						if(result == 1) {
							alert('싫어요! 변경');
							location.reload();
						}
					}
				});
			}
		});
		
		$('#downfill').click(function(){
			let boardId = $('#recipeId').val();
			let memberId = $('#memberId').val();
			 if("${likesVO.memberLike}" == "2") {
					let memberLike = 0;
					let previousMemberLike = 2;
					
					let obj = {
							'recipeId' : boardId,
							'memberId' : memberId,
							'memberLike' : memberLike,
							'previousMemberLike' : previousMemberLike
					}
					
					$.ajax({
						type : 'PUT',
						url : '../likes/' + boardId,
						headers : { // 헤더 정보
							'Content-Type' : 'application/json' // json content-type 설정
						}, 
						data : JSON.stringify(obj),
						success : function(result) {
							if(result == 1) {
								alert('싫어요 취소');
								location.reload();
							}
						}
					});
				} 
		});
	});
	</script>
	</sec:authorize>
</body>
</html>