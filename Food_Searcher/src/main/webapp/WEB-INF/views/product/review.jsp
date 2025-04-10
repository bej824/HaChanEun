<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html>
<head>
<style>
.moveHistory {
	color:blue;
	text-decoration: underline;
}

.moveHistory:hover {
    color: #96C7ED	;
}

</style>
<meta charset="UTF-8">
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>
<meta name="authenticatedUser" content="${authentication.name}">
<title>리뷰</title>
</head>

<body>
<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }">

<h2>리뷰</h2>
<p>리뷰 작성은 <a href="../item/purchaseHistory" class="moveHistory">구매 내역</a>에서 가능합니다.</p>


<div class="reviewBox">
	<div id="reviews">
		<div class="review_item"></div>
			<input type="hidden" id="itemId" name="itemId">
			<input type="hidden" id="memberId" value=<sec:authentication property="name" /> >
	</div>
</div>

</body>
<script type="text/javascript">
$(document).ajaxSend(function(e, xhr, opt){
	
	var token = $("meta[name='_csrf']").attr("content");
	var header = $("meta[name='_csrf_header']").attr("content");

	xhr.setRequestHeader(header, token);
});	 

$(document).ready(function() {
	getAllReview();
		// 수정 모달
	$(document).on("click", ".btn_reviewUpdate", function(){
		$(".reviewModal").attr("style", "display:block;");
		let reviewId = $(this).closest('.review_item').find('#reviewId').val();
		let reviewContent = $(this).closest('.review_item').find(".reviewContent").text();

		 $("#modal_revCon").val(reviewContent);
		 $("#modalReviewId").val(reviewId);
		 
		});
		
		// 수정 버튼을 클릭하면 선택된 댓글 수정
	$(".review_modify_btn").on("click", function(){
		let reviewId = $("#modalReviewId").val();
		let reviewContent = $("#modal_revCon").val();
		let reviewLove = $('input[name="reviewLove"]:checked').val();
			
		let obj = {
				'reviewId' : reviewId,
				'reviewContent' : reviewContent,
				'reviewLove' : reviewLove
		}
		
			// ajax 요청
			$.ajax({
				type : 'Post', 
				url : '../product/review-update',

				data : obj,
				success : function(result) {
					if(result == 1) {
						alert('리뷰가 수정되었습니다.');
						location.reload();
						 $(".replyModal").attr("style", "display:none;");
					} else {
						alert('리뷰 수정 실패');
					}
				}
				});
		}); // end modal_modify_btn	
	
	$(".review_modify_cancle").click(function(){	
	  	$(".reviewModal").attr("style", "display:none;");
	});
		
	$('#reviews').on('click', '.btn_reviewDelete', function(){
		let reviewId = $(this).closest('.review_item').find('#reviewId').val();
		let deleteConfirm = confirm('정말로 삭제하시겠습니까?');
		
		if(deleteConfirm) {
		
		$.ajax({
			type : 'DELETE', 
			url : '../product/review-delete/' + reviewId,
			headers : {
				'Content-Type' : 'application/json'
			},
			success : function(result) {
				if(result == 1) {
					alert('리뷰 삭제 성공!');
					getAllReview();
					location.reload(true);
				} else {
					alert('리뷰 삭제 실패')
					}
				}
			});
			
		}
	}); // end btn_delete
		
	function getAllReview() {
		let itemId = $("#itemId").val();
		let url = '../product/review/list/' + itemId;
		let memberId = $('#memberId').val();
		
		 $.getJSON(url, function(data) {
		        var list = '';
		        
		        if (data.length == 0) {
		            list += '<div class="noReview">작성된 리뷰가 없습니다.</div>'
		        } else {
		            $(data).each(function() {
		                let reviewDate = new Date(this.reviewDate).toLocaleString();
		                let disabled = '';
		                if (memberId != this.memberId) {
		                	disabled = 'disabled';
		                }
		                
		                list += '<div class="review_item"' + this.reviewId + '>'
		                	  + '<div class="userInfo">'
		                	  
		                      + '<p class="reviewLove">' + this.reviewLove + '점</p>' + '<br>'
		                      + '<input type="hidden" id="reviewId" value="' + this.reviewId + '">'
		                      + '<span class="memberId">' + this.memberId + '&nbsp</span>'
		                      + '<span class="reviewDate">' + reviewDate + '&nbsp</span>'

		                      + '<button class="btn_reviewUpdate"' + disabled + '> 수정 </button>'
		                      + '<button class="btn_reviewDelete"' + disabled + '> 삭제 </button>'
		                      + '</div>' // end userInfo	
		                      + '<div class="reviewContent">' + this.reviewContent + '</div>'
		                	  + '</div>';
		                });
		            $("#reviews").html(list);
		            
		        }
		        
		 });
	} // end getAllReview
	
	
	
}); // end document

</script>

<div class="reviewModal">

 <div class="reviewModalContent">
  <input type="hidden" id="modalReviewId">  
  <div>
   <textarea id="modal_revCon" name="modal_revCon"></textarea>
  	 <div>
	<p>이 상품을 추천하시나요?</p>
	<input type="radio" name="reviewLove" value="1" /><label>1점</label>
	<input type="radio" name="reviewLove" value="2" /><label>2점</label>
	<input type="radio" name="reviewLove" value="3" /><label>3점</label>
	<input type="radio" name="reviewLove" value="4" /><label>4점</label>
	<input type="radio" name="reviewLove" value="5" /><label>5점</label>
	</div>
  </div>
 
  
  <div>
   <button type="button" class="review_modify_btn">수정</button>
   <button type="button" class="review_modify_cancle">취소</button>
  </div>
  
 </div>

 <div class="modalBackground"></div>
 
</div> <!-- modal -->

</html>