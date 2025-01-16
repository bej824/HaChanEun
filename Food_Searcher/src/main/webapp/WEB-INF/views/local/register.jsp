<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>특산품 등록</title>
</head>
<body>
	<%@ include file ="../header.jsp" %>
	
	<h1>신규 특산품 등록</h1>
	
	<form id="specialityForm" action="${select }" method="post">
	
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
	
	<input type="text" name="otherLocalDistrict" id="otherLocalDistrict" style="display: none;"
	placeholder="지역 이름을 입력해주세요.">
	
	<div>
		<p>특산품 : <input type="text" name="localTitle" id="localTitle" placeholder="특산품 이름을 입력해주세요."></p>
	</div>
	<div>
        <textarea rows="20" cols="120" name="localContent"></textarea>
	</div>
	
	<!-- CSRF 토큰 -->
	<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }">
	</form>
	
	<button onclick="insert()" class="button">글 작성</button>
	
	<!-- 
	<sec:authorize access="!hasRole('ROLE_ADMIN')">
		<script>
			alert('접근 권한이 없습니다.');
			window.history.back();
		</script>
	</sec:authorize>
	 -->
	
	<script type="text/javascript">
	
	$(document).ready(function(){
		
		// localLocal만 선택되었을 때
		$('#localLocal').change(function(){
			let localLocal = $(this).val();
			districtList(localLocal);
		});
		
		// localDistrict의 value가 '기타'일 때
		$('#localDistrict').change(function(){
			let localDistrict = document.getElementById('localDistrict').value;
				console.log(localDistrict);
			if(localDistrict == '기타'){
				document.getElementById('otherLocalDistrict').style.display = '';
				
			}
		});
		
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
		
	});
	
	
	</script>

</body>
</html>