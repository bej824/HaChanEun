<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
	<%@ page import="java.io.*, java.util.*"%>
<%@ page import="javax.servlet.http.*, javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet"
	href="../resources/css/Detail.css">
	<link rel="stylesheet"
	href="../resources/css/Base.css">
	<link rel="stylesheet"
	href="../resources/css/Register.css">
<style>
</style>
<meta charset="UTF-8">
<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<title>등록</title>

</head>
<body>

<%@ include file="/WEB-INF/views/header.jsp"%>
<div id="area2">

<h2>글 작성 페이지</h2>
	<div class="registerDiv">
	<form id="registerForm" action="register" method="POST">
	<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }">
	
	<div>
	<input type="text" id="itemName" name="itemName" placeholder="음식 이름을 입력해주세요." maxlength="100" required>
	</div>
	
	<div>
	<input type="number" id="itemPrice" name="itemPrice" placeholder="가격을 입력해주세요." min="1" maxlength="9" required oninput="numberMaxLength(this); preventNegative(this);" >
	</div> 
	
	<div>
	<input type="number" id="itemAmount" name="itemAmount" placeholder="현재 수량을 입력해주세요." min="1" maxlength="9" required oninput="numberMaxLength(this);">
	</div>
	
	<div>
	
	<div class="foodDiv">
		<select name="mainCtg" id="mainCtg" class="selectCtg"></select>
		<input type="text" name="subCtg" id="subCtg" placeholder="세부 분류를 입력해주세요.">
	</div>
			<p>원산지 :
			<select name="origin" id="origin" >
				<option>국내산</option>
				<option>중국산</option>
				<option>미국산</option>
				<option>일본산</option>
				<option>호주산</option>
				<option>칠레산</option>
				<option>태국산</option>
				<option>인도산</option>
				<option>베트남산</option>
			</select></p>
	</div>
	
	<div>
	<textarea rows="20" cols="120" id="itemContent" name="itemContent" placeholder="내용을 입력하세요." maxlength="1500" required></textarea><br>
	</div>
	
	</form>

	<div class="image-upload">
		<div class="image-drop">
			<span>* 이미지를 이곳에 드래그 하세요.<br><br>
			* 최대 용량은 10MB 입니다.</span>
		</div>
		<div class="image-list">
			<span>이미지 미리보기입니다.</span>
		</div>
	</div>

	<div class="attachDTOImg-list">
	</div>
	
	<div class="attachDTOFile-list">
	</div>

	<div class="button-container">
		<button onclick="goBack()" class="button">뒤로가기</button>
		<sec:authorize access="isAuthenticated()">
		<button id="registerBoard" class="button">등록</button>
		</sec:authorize>
	</div>
</div>
</div>
	<script src="${pageContext.request.contextPath }/resources/js/images.js"></script>

	<script>
    // ajaxSend() : AJAX 요청이 전송되려고 할 때 실행할 함수를 지정
    // ajax 요청을 보낼 때마다 CSRF 토큰을 요청 헤더에 추가하는 코드
    $(document).ajaxSend(function(e, xhr, opt){
        let token = $("meta[name='_csrf']").attr("content");
        let header = $("meta[name='_csrf_header']").attr("content");

        xhr.setRequestHeader(header, token);
    });

    $(document).ready(function() {
    	let subCtgFlg = false;
    	
    	mainCtg();
    	
        // 차단할 확장자 정규식 (exe, sh, php, jsp, aspx, zip, alz)
        let blockedExtensions = /\.(exe|sh|php|jsp|aspx|zip|alz)$/i;

        // registerForm 데이터 전송
        $('#registerBoard').click(function(e) {
            e.preventDefault();  // 기본 폼 제출 동작을 막음
            
            if(subCtgFlg) {
            	alert("서브 카테고리를 입력해주세요.");
            	return;
            }

            // form 객체 참조
            let registerForm = $('#registerForm');

            // attachDTOImg-list의 첫 번째 input 태그 접근 (단일 이미지 처리)
            let imageInput = $('.attachDTOImg-list input[name="attachVO"]');
            
            // 이미지가 첨부되지 않았으면 폼 제출 안 함
            if (imageInput.length == 0 || !imageInput.val()) {
                alert("이미지를 첨부해 주세요.");
                return;  // 폼 제출을 막고 종료
            }

            // 폼 데이터 준비
            let formData = new FormData(registerForm[0]);  // FormData 객체 생성 (폼 요소를 전송할 수 있음)

            // attachPath, attachRealName, attachChgName, attachExtension을 hidden input으로 생성
            let attachVO = JSON.parse(imageInput.val());
            formData.append('attachList[0].attachPath', attachVO.attachPath);
            formData.append('attachList[0].attachRealName', attachVO.attachRealName);
            formData.append('attachList[0].attachChgName', attachVO.attachChgName);
            formData.append('attachList[0].attachExtension', attachVO.attachExtension);

            // 비동기 요청으로 폼 제출
            $.ajax({
                url: 'register',  // 폼의 action URL
                type: 'POST',                      // HTTP 메서드
                data: formData,                    // FormData 객체
                processData: false,                // 자동으로 데이터 처리하지 않음 (파일 업로드 등을 위해)
                contentType: false,                // Content-Type을 자동으로 설정하지 않음
                success: function(response) {
                    // 요청이 성공하면 처리할 코드 (예: 성공 메시지 표시)
                    console.log('폼 제출 성공');
                    alert("등록이 완료되었습니다.");
                    window.location.href = "../item/list";
                },
                error: function(xhr, status, error) {
                    // 요청 실패 시 처리할 코드 (예: 오류 메시지 표시)
                    alert('오류 발생: ' + error);
                }
            });
        });

        // 파일 전송 form validation
        $("#uploads").submit(function(event) {
            let fileInput = $("input[name='file']"); // File input 요소 참조
            let file = fileInput.prop('files')[0]; // file 객체 참조
            let fileName = fileInput.val();

            if (!file) { // file이 없는 경우
                alert("파일을 선택하세요.");
                event.preventDefault();
                return;
            }

            if (blockedExtensions.test(fileName)) { // 차단된 확장자인 경우
                alert("이 확장자의 파일은 첨부할 수 없습니다.");
                event.preventDefault();
                return;
            }

            let maxSize = 10 * 1024 * 1024; // 10 MB 
            if (file.size > maxSize) {
                alert("파일 크기가 너무 큽니다. 최대 크기는 10MB입니다.");
                event.preventDefault();
            }
        });

        $('#othersubCtg').hide();
        
        $('#mainCtg').change(function(){
            let mainCtg = $(this).val();
        });
        
        $('#subCtg').change(function(){
            let subCtg = $(this).val().trim();
            
            if(subCtg == null || subCtg == '') {
            	alert("서브 카테고리를 입력해주세요.");
            	subCtg = $(this).val('');
            	return;
            } else {
            	subCtg = true;
            }
            
        });
        
        function mainCtg() {
            let mainCtg = $('#mainCtg');
            
            mainCtg.empty();
            
		    $.ajax({
				type: 'GET',
		        url: '../ctg/ctgGet',
		        data: {},
		        success: function(result) {
		        	result.forEach(function(ctg) {
		        		
		        		let low = '<option>' + ctg.mainCtg + '</option>'
		        		
		        		if(ctg.mainCtg != '기타') {
			        	mainCtg.append(low);
		        		}
		            });
		        	
		        }
			})
        }
        
    });

		
		function goBack() {
			  const referrer = document.referrer;
			  if (referrer) {
			    window.location.href = referrer;  // 이전 페이지로 이동
			  } else {
			    alert("이전 페이지가 없습니다.");
			  }
			}
		
		 function numberMaxLength(e){ // 길이 제한 스크립트

		        if(e.value.length > e.maxLength){
		            e.value = e.value.slice(0, e.maxLength);
		        }
		 
		 }
		 
		 function preventNegative(element) { // 음수 제한 스크립트
			    if (element.value < 0) {
			        element.value = "";
			    }
			}
		 
		 
	</script>
<!-- area -->
</body>
</html>