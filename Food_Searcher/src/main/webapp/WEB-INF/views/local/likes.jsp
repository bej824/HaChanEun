<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	
	<p id="likeCount"></p>
	<button id="like">좋아요</button>
	<button id="dislike">싫어요</button>
	<p id="dislikeCount"><p>
	
	<script type="text/javascript">
	
	$(document).ready(function(){
		let localId = '${LocalSpecialityVO.localId }';
		let like = document.getElementById("like");
		let dislike = document.getElementById("dislike");
		
		let likeCount = document.getElementById("likeCount");
		let dislikeCount = document.getElementById("dislikeCount");
		
		let likeDislike = 0;
		
		$('#like').change(function(){
			
		})
		
		$('#dislike').change(function(){
			
		})
		
		function updateCount() {
			
			
		}
		
	})
	
	</script>

</body>
</html>