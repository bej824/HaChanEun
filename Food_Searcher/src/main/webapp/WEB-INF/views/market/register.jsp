<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.*, java.util.*"%>
<%@ page import="javax.servlet.http.*, javax.servlet.*"%>
<%@ page
	import="org.apache.commons.fileupload.*, org.apache.commons.fileupload.disk.*, org.apache.commons.fileupload.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet"
	href="../resources/css/Detail.css">
	<link rel="stylesheet"
	href="../resources/css/Base.css">

<style>a
.image-drop {
    width: 200px;
    height: 200px;
    border: 2px dashed grey; /* 점선 테두리 */
    margin-bottom: 20px; /* 하단 여백 */
    text-align: center; /* 텍스트 가운데 정렬 */
    line-height: 200px; /* 높이와 동일한 라인 높이 */
    font-size: 16px; /* 폰트 크기 */
    color: grey; /* 텍스트 색상 */
}

/* 업로드된 이미지를 출력하는 영역에 대한 스타일 */
.image-list {
    margin-top: 20px; /* 상단 여백 */
    background-color: #f9f9f9; /* 배경색 */
    border: 1px solid #ddd; /* 실선 테두리 */
    padding: 5px; /* 안쪽 여백 */
    margin-bottom: 20px; /* 하단 여백 */
    height: 120px; /* 높이 */
    width: 500px; /* 너비 */
}

/* 업로드된 이미지에 대한 스타일 */
.image_item {
    margin-left: 10px; /* 왼쪽 여백 */
    position: relative; /* 상대적 위치 지정 */
    display: inline-block; /* 인라인 블록으로 표시 */
    margin: 4px; /* 여백 */
}

</style>

<meta charset="UTF-8">
<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<title>Insert title here</title>

</head>
<body>
<%@ include file="/WEB-INF/views/header.jsp"%>
<div id="area">

		<sec:authorize access="hasRole('ROLE_MEMBER')">
			<script type="text/javascript">
				alert('관리자만 접근이 가능합니다.');
				window.history.back();
			</script>
		</sec:authorize>
		
		<sec:authorize access="isAnonymous()">
			<script type="text/javascript">
				alert('로그인이 필요합니다.');
				window.history.back();
			</script>
		</sec:authorize>
		
	<h2>글 작성 페이지</h2>
	
	<form id="registerForm" action="register" method="POST">
	<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }">
	
		<div>
			<p>제목 :</p>
			<input type="text" id="makretTitle" name="marketTitle" placeholder="제목 입력"
				maxlength="20" required>
		</div>
		
		<div>
			<p>음식 : </p>
			<input type="text" id="marketFood" name="marketFood" placeholder="음식 이름 입력" maxlength="100" required>
		</div>
		
		<div>
			<p>가게 : </p>
			<input type="text" id="marketName" name="marketName" placeholder="가게 이름 입력" maxlength="100" required>
		</div>
		
		<sec:authentication property="principal" var="principal"/>

		<div>
			<p>지역 :</p>
			<select name="marketLocal">
				<option value="종로">종로</option>
				<option value="서대문구">서대문구</option>
				<option value="도봉구">도봉구</option>
				<option value="양천구">양천구</option>
				<option value="성동구">성동구</option>
				<option value="노원구">노원구</option>
				<option value="중구">중구</option>
				<option value="중랑구">중랑구</option>
				<option value="용산구">용산구</option>
				<option value="광진구">광진구</option>
				<option value="마포구">마포구</option>
				<option value="관악구">관악구</option>
				<option value="금천구">금천구</option>
				<option value="강서구">강서구</option>
				<option value="강동구">강동구</option>
				<option value="은평구">은평구</option>
				<option value="성북구">성북구</option>
				<option value="동대문구">동대문구</option>
				<option value="강북구">강북구</option>
				<option value="강남구">강남구</option>
				<option value="영등포구">영등포구</option>




			</select>
		</div>
</form>		

		<!-- https://news.seoul.go.kr/economy/archives/66052 -->

		<br>
		<div>
			<div class="image-upload">
				<h2>이미지 파일 업로드</h2>
				<p>* 이미지 파일은 최대 3개까지 가능합니다.</p>
				<p>* 최대 용량은 10MB 입니다.</p>
				<div class="image-drop"></div>
				<h2>선택한 이미지 파일 :</h2>
				<div class="image-list"></div>
			</div>
			
			<div class="attachVOImg-list">
			</div>

			<br>
			<p>내용 :</p>
			<textarea rows="20" cols="120" name="marketContent"
				placeholder="내용 입력" maxlength="300" required></textarea>
			<br> <button id="registerMarket"> 등록 </button>
		</div>
	<script>
	
	$(document).ajaxSend(function(e, xhr, opt){
		console.log("ajaxSend");
		
		var token = $("meta[name='_csrf']").attr("content");
		var header = $("meta[name='_csrf_header']").attr("content");

		xhr.setRequestHeader(header, token);
	});
	
	$(document).ready(function(){
		// 파일 객체를 배열로 전달받아 검증하는 함수
		function validateImages(files){
			var maxSize = 10 * 1024 * 1024; // 10 MB 
			var allowedExtensions = /(\.jpg|\.jpeg|\.png|\.gif)$/i; 
			// 허용된 확장자 정규식 (jpg, jpeg, png, gif)
			
			if(files.length > 3) { // 파일 개수 제한
				alert("파일은 최대 3개만 가능합니다.");
				return false;
			}
			
			for(var i = 0; i < files.length; i++) {
				console.log(files[i]);
				var fileName = files[i].name; // 파일 이름
				var fileSize = files[i].size; // 파일 크기
				
				// 파일 크기가 설정 크기보다 크면
				if (fileSize > maxSize) {
					alert("파일의 최대 크기는 10MB입니다.");
					return false;
				}
				
				// regExp.exec(string) : 지정된 문자열에서 정규식을 사용하여 일치 항목 확인
				// 지정된 문자열이 없는 경우 true를 리턴
		        if(!allowedExtensions.exec(fileName)) {
		            alert("이 파일은 업로드할 수 없습니다. jpg, jpeg, png, gif파일만 가능합니다."); // 알림 표시
		            return false;
		        }
			}
			
			return true; // 모든 조건을 만족하면 true 리턴
		} // end validateImage()
	
		// 파일을 끌어다 놓을 때(drag&drop)
		// 브라우저가 파일을 자동으로 열어주는 기능을 막음
		$('.image-drop').on('dragenter dragover', function(event){
			event.preventDefault();
			console.log('drag 테스트');
		}); 
		
		$('.image-drop').on('drop', function(event){
			event.preventDefault();
			console.log('drop 테스트');
			
			$('.attachVOImg-list').empty();
		
			// 드래그한 파일 정보를 갖고 있는 객체
			var files = event.originalEvent.dataTransfer.files;
			var attachList = $('.image-list');
			console.log("파일 정보 : " + files);
			
			if(!validateImages(files)) { 
				return;
			}
			
			attachList.empty();
			
			// Ajax를 이용하여 서버로 파일을 업로드
			// multipart/form-data 타입으로 파일을 업로드하는 객체
			var formData = new FormData();

			for(var i = 0; i < files.length; i++) {
				formData.append("files", files[i]); 
			}
			
			
			$.ajax({
				type : 'post', 
				url : '../images/uploadImg', 
				data : formData,
				processData : false,
				contentType : false,
				success : function(data) {
					console.log(data);
					var list = '';
					$(data).each(function(){
						// this : 컬렉션의 각 인덱스 데이터를 의미
						console.log(this);
					  	var marketAttachVO = this; // attachDTO 저장
					  	// encodeURIComponent() : 문자열에 포함된 특수 기호를 UTF-8로 
					  	// 인코딩하여 이스케이프시퀀스로 변경하는 함수 
						var attachPath = encodeURIComponent(this.attachPath);
						
						// input 태그 생성 
						// - type = hidden
						// - name = attachDTO
						// - data-chgName = attachtDTO.attachChgName
						var input = $('<input>').attr('type', 'hidden')
							.attr('name', 'marketAttachVO')
							.attr('data-chgName', marketAttachVO.attachChgName);
						
						// attachDTO를 JSON 데이터로 변경
						// - object 형태는 데이터 인식 불가능
						input.val(JSON.stringify(marketAttachVO));
						console.log("marketAttachVO");
						
			       		// div에 input 태그 추가
			        	$('.attachVOImg-list').append(input);
					  	
					    // display() 메서드에서 이미지 호출을 위한 문자열 구성
					    list += '<div class="image_item" data-chgName="'+ this.attachChgName +'">'
					    	+ '<pre>'
					    	+ '<input type="hidden" id="attachPath" value="'+ this.attachPath +'">'
					    	+ '<input type="hidden" id="attachChgName" value="'+ marketAttachVO.attachChgName +'">'
					    	+ '<input type="hidden" id="attachExtension" value="'+ marketAttachVO.attachExtension +'">'
					        + '<a href="../images/display?attachPath=' + attachPath + '&attachChgName='
					        + marketAttachVO.attachChgName + "&attachExtension=" + marketAttachVO.attachExtension
					        + '" target="_blank">'
					        + '<img width="100px" height="100px" src="../images/display?attachPath=' 
					        + attachPath + '&attachChgName='
					        + 't_' + marketAttachVO.attachChgName 
					        + "&attachExtension=" + marketAttachVO.attachExtension
					        + '" />'
					        + '</a>'
					        + '<button class="image_delete" >x</button>'
					        + '</pre>'
					        + '</div>';
					}); // end each()

					// list 문자열 image-list div 태그에 적용
					$('.image-list').html(list);
				} // end success
			
			}); // end $.ajax()
			
		}); // end image-drop()
		
	});
	
	$(document).ready(function() {
		// regsiterForm 데이터 전송
		$('#registerMarket').click(function() {
			var title = $('#marketTitle').val().trim(); // 문자열의 양 끝 공백 제거
            var content = $('#marketContent').val().trim();
            var food = $('#marketFood').val().trim();
            var name = $('#marketName').val().trim();
            
            var registerForm = $('#registerForm');
            
      	    // attachVOImg-list의 각 input 태그 접근
			var i = 0;
			$('.attachVOImg-list input[name="marketAttachVO"]').each(function(){
				console.log(this);
				// JSON attachDTO 데이터를 object 변경
				var marketAttachVO = JSON.parse($(this).val());
				// attachPath input 생성
				var inputPath = $('<input>').attr('type', 'hidden')
						.attr('name', 'marketAttachList[' + i + '].attachPath');
				inputPath.val(marketAttachVO.attachPath);
				
				// attachRealName input 생성
				var inputRealName = $('<input>').attr('type', 'hidden')
						.attr('name', 'marketAttachList[' + i + '].attachRealName');
				inputRealName.val(marketAttachVO.attachRealName);
				
				// attachChgName input 생성
				var inputChgName = $('<input>').attr('type', 'hidden')
						.attr('name', 'marketAttachList[' + i + '].attachChgName');
				inputChgName.val(marketAttachVO.attachChgName);
				
				// attachExtension input 생성
				var inputExtension = $('<input>').attr('type', 'hidden')
						.attr('name', 'marketAttachList[' + i + '].attachExtension');
				inputExtension.val(marketAttachVO.attachExtension);
				
				// form에 태그 추가
				registerForm.append(inputPath);
				registerForm.append(inputRealName);
				registerForm.append(inputChgName);
				registerForm.append(inputExtension);
				
				i++;
			});
			registerForm.submit();
		 });
	    
	});
      	    
	</script>
	
	</div>
</body>
</html>
