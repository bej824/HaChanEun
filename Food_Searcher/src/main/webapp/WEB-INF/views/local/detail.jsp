<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet"
	href="../resources/css/Detail.css">
<link rel="stylesheet"
	href="../resources/css/Base.css">
<!-- jquery 라이브러리 import -->
<script src="https://code.jquery.com/jquery-3.7.1.js">
	
</script>
<style type="text/css">

 #area2 {
    max-width: 900px;
    margin: 20px auto;
    padding: 20px;
    background: #fff;
    border-radius: 12px;
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
}

.disabled {
	opacity: 0.6;
	cursor: not-allowed;
}

</style>
<meta charset="UTF-8">
<title>${localSpecialityVO.localTitle }</title>
</head>
<body>
	<%@ include file ="../header.jsp" %>
	<div id="area2">
	<h1>${localSpecialityVO.localTitle }</h1>
	<div>
		<input type="hidden" id="Id" name="Id"
			value="${localSpecialityVO.localId }">
		<input type="hidden" id="localId" name="localId"
			value="${localSpecialityVO.localId }">
	</div>
	<div>
		<p>지역 : ${localSpecialityVO.localLocal } / ${localSpecialityVO.localDistrict }</p>
	</div>
	<div>
        <textarea rows="20" cols="120" readonly>${localSpecialityVO.localContent }</textarea>
	</div>
	<a class="button" href="../item/list?&type=ITEM_CONTENT,ITEM_NAME&keyword=${localSpecialityVO.localDistrict },${localSpecialityVO.subCtg }">특산품 구매</a>
	</div>
	
	<script type="text/javascript">
	
	$(document).ready(function(){

	$('#btn_update').click(function(){
		window.location.href=
			'modify?localId=' + ${localSpecialityVO.localId };
	})
	
		
	$('#btn_index').click(function(){
		index();
	})
	
	function index() {
		let localLocal = '${localLocal }';
		let localDistrict = '${localDistrict }';
		let localTitle = '${localTitle}';
		let mainCtg = '${mainCtg}';
		
		if(localLocal != "" && localLocal != '${localSpecialityVO.localLocal }'){
			localLocal = "";
			localDistrict = "";
		}
		if(localDistrict != "" && localDistrict != '${localSpecialityVO.localDistrict }'){
			localDistrict = "";
		}
		
		window.location.href=
			'list?localLocal='+ localLocal +
			'&localDistrict=' + localDistrict +
			'&localTitle=' + localTitle +
			'&mainCtg=' + mainCtg;
	}
	
	})
	</script>

</body>
</html>