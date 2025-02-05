<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet"
	href="../resources/css/Detail.css">
<link rel="stylesheet"
	href="../resources/css/Base.css">
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%@ include file ="../header.jsp" %>
	<div id="area">
	<h1>특산품 정보 수정하기</h1>
	
	지역 : <select name="localLocal" id="localLocal">
		<option value="">전체</option>
		<option value="경기도" <c:if test="${localSpecialityVO.localLocal == '경기도'}">selected</c:if>>경기도</option>
		<option value="강원도" <c:if test="${localSpecialityVO.localLocal == '강원도'}">selected</c:if>>강원도</option>
		<option value="충청북도" <c:if test="${localSpecialityVO.localLocal == '충청북도'}">selected</c:if>>충청북도</option>
		<option value="충청남도" <c:if test="${localSpecialityVO.localLocal == '충청남도'}">selected</c:if>>충청남도</option>
		<option value="전라북도" <c:if test="${localSpecialityVO.localLocal == '전라북도'}">selected</c:if>>전라북도</option>
		<option value="전라남도" <c:if test="${localSpecialityVO.localLocal == '전라남도'}">selected</c:if>>전라남도</option>
		<option value="경상북도" <c:if test="${localSpecialityVO.localLocal == '경상북도'}">selected</c:if>>경상북도</option>
		<option value="경상남도" <c:if test="${localSpecialityVO.localLocal == '경상남도'}">selected</c:if>>경상남도</option>
		<option value="제주도" <c:if test="${localSpecialityVO.localLocal == '제주도'}">selected</c:if>>제주도</option>
	</select>
	&nbsp; / &nbsp;&nbsp;
	<select name="localDistrict" id="localDistrict">
	<option value="">전체</option>
	</select>
	
	<input type="text" name="otherLocalDistrict" id="otherLocalDistrict" value="${localSpecialityVO.localDistrict }"
	placeholder="지역 이름을 입력해주세요.">
	
	<div>
		<p>특산품 : <input type="text" name="localTitle" id="localTitle" value="${localSpecialityVO.localTitle }"
		placeholder="특산품 이름을 입력해주세요."></p>
	</div>
	<div>
        <textarea rows="20" cols="120" name="localContent" id="localContent">${localSpecialityVO.localContent }</textarea>
	</div>
	
	<button id="btn_update" class="button">수정</button>
	</div>
	
	<script type="text/javascript">
	
	$(document).ajaxSend(function(e, xhr, opt){
		var token = $("meta[name='_csrf']").attr("content");
		var header = $("meta[name='_csrf_header']").attr("content");

		xhr.setRequestHeader(header, token);
	});
	
	$(document).ready(function(){
		$('#otherLocalDistrict').hide();
		districtList("${localSpecialityVO.localLocal}");
		
		// localLocal만 선택되었을 때
		$('#localLocal').change(function(){
			let localLocal = $(this).val();
			districtList(localLocal);
		});
		
		// localDistrict의 value가 '기타'일 때
		$('#localDistrict').change(function(){
			let localDistrict = $(this).val();
			
			if(localDistrict == '기타'){
				$('#otherLocalDistrict').show();
				$('#otherLocalDistrict').val('');
			} else {
				$('#otherLocalDistrict').hide();
			}
		});
		
		$('#insert').click(function(){
			let localLocal = $('#localLocal').val();
		    let localDistrict = $('#localDistrict').val();
			let localTitle = $('#localTitle').val();
			let localContent = $('#localContent').val();
			
			if(localDistrict == '기타'){
				localDistrict = $('#otherLocalDistrict').val();
			}
			
			if(localLocal == '' || localDistrict == '') {
				alert("특산품이 생산되는 지역을 선택해주세요.");
			} else if(localContent == ''){
				alert("특산품 설명을 입력해주세요.");
			}
			
			specialityInsert(localLocal, localDistrict, localTitle, localContent);
		});
		
		$('#btn_update').click(function(){
			let localId = ${localSpecialityVO.localId };
			let localLocal = $('#localLocal').val();
		    let localDistrict = $('#localDistrict').val();
			let localTitle = $('#localTitle').val();
			let localContent = $('#localContent').val();
			let replyCount = ${localSpecialityVO.replyCount };
			
			let result = confirm("수정하시겠습니까?");
			if(result) {
			$.ajax({
				type : 'POST',
				url : 'update',
				data : {localId : localId,
						localLocal : localLocal,
						localDistrict : localDistrict,
						localTitle : localTitle,
						localContent : localContent,
						replyCount : replyCount
				},
				success : function(result) {
					if(result == 1) {
						alert("게시글이 수정되었습니다.");
						window.location.href = 'detail?localId=' + localId;
					} else {
						alert("다시 시도해주세요.");
					}
					
				}
			})
				
			} else {
				alert("수정이 취소되었습니다.");
			}
			
			
		});
		
		function districtList(localLocal) {
			let indexLocalDistrict = "${localSpecialityVO.localDistrict }";
			console.log(indexLocalDistrict);
			let localDistrict_selectOption = $("#localDistrict");
			
			$.ajax({
				type : 'GET',
				url : 'listDistrict',
				data : {localLocal : localLocal},
				success : function(result) {
				
					let selectOption = $("#localDistrict" );
					localDistrict_selectOption.empty();
					localDistrict_selectOption.append('<option value="">' + 
						    	'전체</option>');
					result.forEach(function(districtList){
					console.log(districtList);
					let districtOption =
						'<option value="' + districtList + '">' + 
					    districtList + '</option>';
					localDistrict_selectOption.append(districtOption);
					console.log(districtOption);
					});
					
					if(localLocal != ""){
					localDistrict_selectOption.append('<option value="기타">기타</option>');
					}
					
				// 선택된 값을 세팅
            	if(indexLocalDistrict){ // indexLocalDistrict가 있다면 선택하고 공백으로 초기화
            		localDistrict_selectOption.val(indexLocalDistrict);
            		indexLocalDistrict = '';
            	}
				
				}
			})
			
			
		}
		
		
	})
	</script>

</body>
</html>