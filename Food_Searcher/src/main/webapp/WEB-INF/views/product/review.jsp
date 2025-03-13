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

</body>
<script type="text/javascript">
$(document).ajaxSend(function(e, xhr, opt){
	
	var token = $("meta[name='_csrf']").attr("content");
	var header = $("meta[name='_csrf_header']").attr("content");

	xhr.setRequestHeader(header, token);
});	 

</script>


</html>