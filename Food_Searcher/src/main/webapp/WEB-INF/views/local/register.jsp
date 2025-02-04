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
<title>특산품 등록</title>
</head>
<body>
	<%@ include file ="../header.jsp" %>
	<div id="area">
	<h1>신규 특산품 등록</h1>
	
	지역 : <select name="localLocal" id="localLocal">
		<option value="">전체</option>
		<option value="경기도">경기도</option>
		<option value="강원도">강원도</option>
		<option value="충청북도">충청북도</option>
		<option value="충청남도">충청남도</option>
		<option value="전라북도">전라북도</option>
		<option value="전라남도">전라남도</option>
		<option value="경상북도">경상북도</option>
		<option value="경상남도">경상남도</option>
		<option value="제주도">제주도</option>
	</select>
	&nbsp; / &nbsp;&nbsp;
	<select name="localDistrict" id="localDistrict">
	<option value="">전체</option>
	</select>
	
	<input type="text" name="otherLocalDistrict" id="otherLocalDistrict"
	placeholder="지역 이름을 입력해주세요.">
	
	<div>
		<p>특산품 : <input type="text" name="localTitle" id="localTitle" placeholder="특산품 이름을 입력해주세요."></p>
	</div>
	<div>
        <textarea rows="20" cols="120" name="localContent" id="localContent"></textarea>
	</div>
	
	<button id="insert" class="button">글 작성</button>
	</div>
	
	<script type="text/javascript">
	
	$(document).ajaxSend(function(e, xhr, opt){
		var token = $("meta[name='_csrf']").attr("content");
		var header = $("meta[name='_csrf_header']").attr("content");

		xhr.setRequestHeader(header, token);
	});
	
	$(document).ready(function(){
		$('#otherLocalDistrict').hide();
		
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
		})
		
		function districtList(localLocal) {
			
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
					let districtOption =
						'<option value="' + districtList + '">' + 
					    	districtList + '</option>';
					    	localDistrict_selectOption.append(districtOption);
					});
					
					if(localLocal != ""){
					localDistrict_selectOption.append('<option value="기타">기타</option>');
					}
					
				}
			})
		}
		
		function specialityInsert(localLocal, localDistrict, localTitle, localContent){
			
			$.ajax({
				type : 'POST',
				url : 'register',
				data : {localLocal : localLocal,
						localDistrict : localDistrict,
						localTitle : localTitle,
						localContent : localContent
				},
				success : function(result) {
					if(result == 1) {
						alert("게시글이 등록되었습니다.");
						window.location.href = 'map';
					} else {
						alert("다시 시도해주세요.");
					}
					
				}
			})
		}
		
	});
	
	
	</script>

</body>
</html>