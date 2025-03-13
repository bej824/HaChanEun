<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>
<style>
.moveHistory {
	color:blue;
}
</style>
<meta charset="UTF-8">
<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>
<title>리뷰</title>
</head>

<body>

<h2>리뷰</h2>
<p>리뷰 작성은 <a href="../item/purchaseHistory" class="moveHistory">구매 내역</a>에서 가능합니다.</p>
<input type="hidden" id="itemId" value="${reviewVO.itemId }">

<p>${reviewVO.itemId }</p>
<p>${reviewVO.itemName }</p>

<p>${reviewVO.reviewId } </p>

<div id="asks">
	<div class="review_item"></div>
	<p>테스트</p>
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
	
	function getAllReview() {
		let itemId = $("#itemId").val();
		let url = '../product/review/list/' + itemId;
		
		 $.getJSON(url, function(data) {
		        console.log(data);
		        
		        var list = '';
		        
		        if (data.length == 0) {
		            list += '<div class="noReview">작성된 문의가 없습니다.</div>'
		        } else {
		            $(data).each(function() {
		                console.log(this);
		                
		                let reviewDate = new Date(this.reviewDate).toLocaleString();
		                let disabled = '';
		                if (memberId != this.memberId) {
		                	disabled = 'disabled';
		                	}
		                
		                list += '<div class="review_item" value="' + this.reviewId + '">'
		                	  + '<p>테스트</p>'
		                	  + '</div>';
		                });
		            $("#reviews").html(list);
		            
		        }
		        
		 });
	} // end getAllReview
	
}); // end document

</script>


</html>