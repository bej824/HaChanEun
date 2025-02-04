<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	
	<div>
	<p id="likeCount"></p> <button id="btn_like">좋아요</button> <button id="btn_dislike">싫어요</button> <p id="dislikeCount"><p>
	</div>
	
	<sec:authorize access="isAuthenticated()">
	<script> selectMemberLike(); </script>
	</sec:authorize>
	
	<script type="text/javascript">
	
	$(document).ready(function(){
		let localId = '${LocalSpecialityVO.localId }';
		let like = document.getElementById("like");
		let dislike = document.getElementById("dislike");
		
		let likeCount = document.getElementById("likeCount");
		let dislikeCount = document.getElementById("dislikeCount");
		
		let memberLike = 0;
		
		$('#btn_like').click(function(){
			if('${principal.name}' == '') {
				alert("로그인 후 이용 가능합니다.");
			} else {
			memberLike = 1;
			console.log(memberLike);				
			}
		})
		
		$('#btn_dislike').click(function(){
			if('${principal.name}' == '') {
				alert("로그인 후 이용 가능합니다.");
			} else {
			memberLike = 2;
			console.log(memberLike);				
			}
		})
		
		function selectMemberLike() {
			$.ajax({
				type : 'POST',
				url : 'memberLike',
				data : {localId : localId},
				success : function(result) {
					memberLike = result;
				}
			})
		}
		
		function createCount(memberLike) {
			let localId = "${localSpecialityVO.localId }";
			
			$.ajax({
				type : 'POST',
				url : 'likeUpdate',
				data : {localId : localId,
					memberLike : memberLike},
				success : function(result) {
					
				}
			})
		}
		
		function updateCount(memberLike) {
			let localId = "${localSpecialityVO.localId }";
			
			$.ajax({
				type : 'POST',
				url : 'likeUpdate',
				data : {localId : localId,
					memberLike : memberLike},
				success : function(result) {
					
				}
			})
			
		}
		
	})
	
	</script>

</body>
</html>