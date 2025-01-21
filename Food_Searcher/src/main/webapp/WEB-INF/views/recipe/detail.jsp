<%@page import="com.food.searcher.domain.RecipeVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="com.food.searcher.domain.RecipeReplyVO" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<link rel="stylesheet"
	href="../resources/css/Detail.css">
<!-- jquery 라이브러리 import -->
<script src="https://code.jquery.com/jquery-3.7.1.js">
</script>
<style type="text/css">
.button, .btn_update, .btn_delete, .btn_comment, .btn_commentupdate, .btn_commentdelete {
  background-color: #04AA6D;
  border: none;
  color: white;
  padding: 4px 12px;
  text-align: center;
  text-decoration: none;
  display: inline-block;
  font-size: 16px;
  margin: 4px 2px;
  cursor: pointer;
}

.reply_item {
        margin-left: 1px; /* 대댓글은 부모 댓글보다 30px 들여쓰기 */
        margin-bottom: 10px;
    }

.disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

    .image-list {
        display: flex;
        flex-wrap: wrap; /* 이미지가 가로로 나오고, 공간이 부족할 경우 줄 바꿈 */
    }
    .image_item {
        margin: 5px; /* 이미지 간 간격 */
    }
    
	.container {
      display: flex;
      justify-content: center;  /* 수평 중앙 정렬 */
    }
    
    #up, #down:hover {
      cursor: pointer;  /* 마우스가 아이콘 위에 올려지면 손 모양으로 변경 */
    }

</style>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>
<!-- css 파일 불러오기 -->
<link rel="stylesheet"
	href="${pageContext.request.contextPath }/resources/css/image.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath }/resources/css/attach.css">
<title>${recipeVO.recipeTitle }</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body>
	<%@ include file ="../header.jsp" %>
	<%session.getAttribute("memberId"); %>
	<h2>글 보기</h2>
	<div>
		<p>글 번호 : ${recipeVO.recipeId }</p>
	</div>
	<div>
		<p>제목 : ${recipeVO.recipeTitle }</p>
	</div>
	<div>
		<p>작성자 : ${recipeVO.memberId }</p>
		<!-- boardDateCreated 데이터 포멧 변경 -->
		<fmt:formatDate value="${recipeVO.recipeDateCreated }"
					pattern="yyyy-MM-dd" var="recipeDateCreated"/>
		<p>작성일 : ${recipeDateCreated }</p>
		<p>음식 : ${recipeVO.recipeFood }</p>
	</div>
	<div>
		<textarea rows="20" cols="120" readonly>${recipeVO.recipeContent } </textarea>
	</div>
	 

	<form id="listForm" action="list" method="GET">
		<input type="hidden" name="pageNum" >
    	<input type="hidden" name="pageSize" >
    	<input type="hidden" name="type" >
    	<input type="hidden" name="keyword" >	
	</form>
	<form id="modifyForm" action="modify" method="GET">
		<input type="hidden" name="recipeId">
		<input type="hidden" name="pageNum" >
    	<input type="hidden" name="pageSize" >
    	<input type="hidden" name="type" >
    	<input type="hidden" name="keyword" >
	</form>
	<form id="deleteForm" action="delete" method="POST">
		<input type="hidden" name="recipeId" value="${recipeVO.recipeId}">
		<input type="hidden" name="pageNum" >
    	<input type="hidden" name="pageSize" >
    	<input type="hidden" name="type" >
    	<input type="hidden" name="keyword" >
    	<input type="hidden" name="memberId" value="${recipeVO.memberId}">
    	<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }">
	</form>
	
	<!-- 이미지 파일 영역 -->
	<div class="image-upload">
		<div class="image-view">
			<h3>이미지 파일 리스트</h3>
			<div class="image-list">
				<!-- 이미지 파일 처리 코드 -->
				<c:forEach var="attachVO" items="${idList}">
				    <c:if test="${attachVO.attachExtension eq 'jpg' or 
				    			  attachVO.attachExtension eq 'jpeg' or 
				    			  attachVO.attachExtension eq 'png' or 
				    			  attachVO.attachExtension eq 'gif'}">
				        <div class="image_item">
				        	<a href="../image/get?attachId=${attachVO.attachId }&attachExtension=${attachVO.attachExtension}" target="_blank">
					        <img width="100px" height="100px" 
					        src="../image/get?attachId=${attachVO.attachId }&attachExtension=${attachVO.attachExtension}" /></a>
				        </div>
				    </c:if>
				</c:forEach>
			</div>
		</div>
	</div>

    <a href="/searcher/recipe/list?recipeTitle=${pagination.keyword}&filterBy=${pagination.type}&pageNum=${pagination.pageNum}" class="button">글 목록</a>

    <c:set var="sessionMemberId" value="${sessionScope.memberId}" />
    <c:set var="recipeMemberId" value="${recipeVO.memberId}" />

    <sec:authorize access="isAuthenticated() and principal.username == '${recipeVO.memberId }'">
        <button onclick="location.href='modify?recipeId=${recipeVO.recipeId}'" class="button">글 수정</button>
        <button id="deleteBoard" class="button">글 삭제</button>
    </sec:authorize>
<form id="deleteForm" action="delete" method="POST" enctype="multipart/form-data">
    <!-- 레시피 ID hidden 필드 -->
    <input type="hidden" name="recipeId" value="${recipeVO.recipeId}">
   
</form>

<script>
	let deleteButton = document.getElementById("deleteBoard");

	if (deleteButton) {
		deleteButton.addEventListener("click", function(event) {
        // 삭제 확인 팝업
        if (confirm("삭제하시겠습니까?")) {
            // 폼을 제출하여 서버로 delete 요청을 보냄
            document.getElementById("deleteForm").submit();
        } else {
            // 취소 시 동작하지 않도록
            event.preventDefault();
        }
    });
	}
</script>

	<script type="text/javascript">
		$(document).ready(function(){
		$("#listBoard").click(function(){
			var listForm = $("#listForm"); // form 객체 참조
			
			// c:out을 이용한 현재 페이지 번호값 저장
			var pageNum = "<c:out value='${pagination.pageNum }' />";
			var pageSize = "<c:out value='${pagination.pageSize }' />"; 
			var type = "<c:out value='${pagination.type }' />";
			var keyword = "<c:out value='${pagination.keyword }' />";
			
			// 페이지 번호를 input name='pageNum' 값으로 적용
			listForm.find("input[name='pageNum']").val(pageNum);
			// 선택된 옵션 값을 input name='pageSize' 값으로 적용
			listForm.find("input[name='pageSize']").val(pageSize);
			// type 값을 적용
			listForm.find("input[name='type']").val(type);
			// keyword 값을 적용
			listForm.find("input[name='keyword']").val(keyword);
			listForm.submit(); // form 전송
		}); // end click()
	});

	</script>
	
	<%-- 추천 비추천 작업 예정 
	<button id="up" class="button">추천${recipeVO.like }</button>
	<button id="down" class="button">비추천${recipeVO.unlike }</button>
	--%>
	
	<sec:authorize access="isAnonymous()">
	<div class="container">
	<i class="glyphicon glyphicon-thumbs-up" style="font-size:26px;color:red;">좋아요${recipeVO.likesCount }&nbsp;</i>
	<i class="glyphicon glyphicon-thumbs-down" style="font-size:26px;color:blue;">싫어요${recipeVO.dislikesCount }</i>
	</div>
	</sec:authorize>
	<sec:authorize access="isAuthenticated()">
	<div class="container">
	<i id="upfill"class="bi bi-hand-thumbs-up-fill" style="font-size:26px;color:red; display: none;">좋아요${recipeVO.likesCount }&nbsp;</i>
	<i id="up" class="bi bi-hand-thumbs-up" style="font-size:26px;color:red;">좋아요${recipeVO.likesCount }&nbsp;</i>
	<i id="downfill" class="bi bi-hand-thumbs-down-fill" style="font-size:26px;color:blue; display: none;">싫어요${recipeVO.dislikesCount }</i>
	<i id="down" class="bi bi-hand-thumbs-down" style="font-size:26px;color:blue;">싫어요${recipeVO.dislikesCount }</i>
	
	</div>
	
	<script type="text/javascript">
	$(document).ready(function(){
		$('#up').click(function(){
			if ($('#up').is(':visible')) {
			$('#upfill').show(); // 아이콘 채우기 안되네...
            $('#up').hide();
			} else {
				$('#upfill').hide();
	            $('#up').show();
			}
			if("${likesVO.memberLike}" == ""){
			let boardId = $('#recipeId').val();
			console.log("recipeId : " + boardId);
			let memberId = $('#memberId').val();
			console.log("memberId : " + memberId);
			let memberAge = ${memberVO.memberAge};
			console.log("memberAge : " + memberAge);
			let memberGender = "${memberVO.memberGender}";
			console.log("memberGender : " + memberGender);
			let memberMBTI = "${memberVO.memberMBTI}";
			console.log("memberMBTI : " + memberMBTI);
			let memberConstellation = "${memberVO.memberConstellation}";
			console.log("memberConstellation : " + memberConstellation);
			
			let memberLike = 1;
			console.log(memberLike);
			
			let obj = {
					'recipeBoardId' : boardId,
					'memberId' : memberId,
					'memberAge' : memberAge,
					'memberGender' : memberGender,
					'memberMBTI' : memberMBTI,
					'memberConstellation' : memberConstellation,
					'memberLike' : memberLike
			}
			console.log(obj);
			if("<sec:authentication property="name" />" != "${likesVO.memberId}") {
			console.log()
			$.ajax({
				type : 'POST',
				url : '../likes',
				headers : { // 헤더 정보
					'Content-Type' : 'application/json' // json content-type 설정
				}, 
				data : JSON.stringify(obj),
				success : function(result) {
					console.log(result);
					if(result == 1) {
						alert('좋아요!');
						location.reload();
					}
				}
			});
			}
			} else if("${likesVO.memberLike}" == "1") {
				let boardId = $('#recipeId').val();
				console.log("recipeId : " + boardId);
				let memberId = $('#memberId').val();
				console.log("memberId : " + memberId);
				let memberAge = ${memberVO.memberAge};
				console.log("memberAge : " + memberAge);
				let memberGender = "${memberVO.memberGender}";
				console.log("memberGender : " + memberGender);
				let memberMBTI = "${memberVO.memberMBTI}";
				console.log("memberMBTI : " + memberMBTI);
				let memberConstellation = "${memberVO.memberConstellation}";
				console.log("memberConstellation : " + memberConstellation);
				let memberLike = 0;
				let previousMemberLike = 1;
				let obj = {
						'recipeBoardId' : boardId,
						'memberId' : memberId,
						'memberAge' : memberAge,
						'memberGender' : memberGender,
						'memberMBTI' : memberMBTI,
						'memberConstellation' : memberConstellation,
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
						console.log(result);
						if(result == 1) {
							alert('좋아요 취소');
							location.reload();
						}
					}
				});
			} else if("${likesVO.memberLike}" == "0") {
				let boardId = $('#recipeId').val();
				console.log("recipeId : " + boardId);
				let memberId = $('#memberId').val();
				console.log("memberId : " + memberId);
				let memberAge = ${memberVO.memberAge};
				console.log("memberAge : " + memberAge);
				let memberGender = "${memberVO.memberGender}";
				console.log("memberGender : " + memberGender);
				let memberMBTI = "${memberVO.memberMBTI}";
				console.log("memberMBTI : " + memberMBTI);
				let memberConstellation = "${memberVO.memberConstellation}";
				console.log("memberConstellation : " + memberConstellation);
				let memberLike = 1;
				let obj = {
						'recipeBoardId' : boardId,
						'memberId' : memberId,
						'memberAge' : memberAge,
						'memberGender' : memberGender,
						'memberMBTI' : memberMBTI,
						'memberConstellation' : memberConstellation,
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
						console.log(result);
						if(result == 1) {
							alert('좋아요!');
							location.reload();
						}
					}
				});
			}
		});
		
		
		$('#down').click(function(){
			if("${likesVO.memberLike}" == ""){
				let boardId = $('#recipeId').val();
				console.log("recipeId : " + boardId);
				let memberId = $('#memberId').val();
				console.log("memberId : " + memberId);
				let memberAge = ${memberVO.memberAge};
				console.log("memberAge : " + memberAge);
				let memberGender = "${memberVO.memberGender}";
				console.log("memberGender : " + memberGender);
				let memberMBTI = "${memberVO.memberMBTI}";
				console.log("memberMBTI : " + memberMBTI);
				let memberConstellation = "${memberVO.memberConstellation}";
				console.log("memberConstellation : " + memberConstellation);
				
				let memberLike = 2;
				console.log(memberLike);
				
				let obj = {
						'recipeBoardId' : boardId,
						'memberId' : memberId,
						'memberAge' : memberAge,
						'memberGender' : memberGender,
						'memberMBTI' : memberMBTI,
						'memberConstellation' : memberConstellation,
						'memberLike' : memberLike
				}
				console.log(obj);
				if("<sec:authentication property="name" />" != "${likesVO.memberId}") {
				console.log()
				$.ajax({
					type : 'POST',
					url : '../likes',
					headers : { // 헤더 정보
						'Content-Type' : 'application/json' // json content-type 설정
					}, 
					data : JSON.stringify(obj),
					success : function(result) {
						console.log(result);
						if(result == 1) {
							alert('싫어요!');
							location.reload();
						}
					}
				});
				}
			}  else if("${likesVO.memberLike}" == "2") {
				let boardId = $('#recipeId').val();
				console.log("recipeId : " + boardId);
				let memberId = $('#memberId').val();
				console.log("memberId : " + memberId);
				let memberAge = ${memberVO.memberAge};
				console.log("memberAge : " + memberAge);
				let memberGender = "${memberVO.memberGender}";
				console.log("memberGender : " + memberGender);
				let memberMBTI = "${memberVO.memberMBTI}";
				console.log("memberMBTI : " + memberMBTI);
				let memberConstellation = "${memberVO.memberConstellation}";
				console.log("memberConstellation : " + memberConstellation);
				let memberLike = 0;
				let previousMemberLike = 2;
				
				let obj = {
						'recipeBoardId' : boardId,
						'memberId' : memberId,
						'memberAge' : memberAge,
						'memberGender' : memberGender,
						'memberMBTI' : memberMBTI,
						'memberConstellation' : memberConstellation,
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
						console.log(result);
						if(result == 1) {
							alert('싫어요 취소');
							location.reload();
						}
					}
				});
			} else if("${likesVO.memberLike}" == "0") {
				let boardId = $('#recipeId').val();
				console.log("recipeId : " + boardId);
				let memberId = $('#memberId').val();
				console.log("memberId : " + memberId);
				let memberAge = ${memberVO.memberAge};
				console.log("memberAge : " + memberAge);
				let memberGender = "${memberVO.memberGender}";
				console.log("memberGender : " + memberGender);
				let memberMBTI = "${memberVO.memberMBTI}";
				console.log("memberMBTI : " + memberMBTI);
				let memberConstellation = "${memberVO.memberConstellation}";
				console.log("memberConstellation : " + memberConstellation);
				
				let memberLike = 2;
				console.log(memberLike);
				
				let obj = {
						'recipeBoardId' : boardId,
						'memberId' : memberId,
						'memberAge' : memberAge,
						'memberGender' : memberGender,
						'memberMBTI' : memberMBTI,
						'memberConstellation' : memberConstellation,
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
						console.log(result);
						if(result == 1) {
							alert('싫어요!');
							location.reload();
						}
					}
				});
			}
		});
	});
	</script>
	</sec:authorize>

	<%@ include file="reply.jsp"%>
	<input type="hidden" id="recipeId" value="${recipeVO.recipeId }">
	<div style="text-align: center;">
		<div id="replies"></div>
	</div>

</body>
</html>