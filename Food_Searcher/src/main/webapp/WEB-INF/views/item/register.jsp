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
<style>
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

<h2>글 작성 페이지</h2>
	
	<form id="registerForm" action="register" method="POST">
	<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }">
	
	<div>
	<p>판매자 : <sec:authentication property="name" /></p>
	<p>음식 이름 : 
	<input type="text" id="itemName" name="itemName" placeholder="음식 입력"
	maxlength="200" required></p>
	</div>
	
	<div>
	<p>가격 :
	<input type="text" id="itemPrice" name="itemPrice" placeholder="가격 입력"
	maxlength="100" required></p>
	</div> 
	
	<div>
	<p>수량 :
	<input type="text" id="itemAmount" name="itemAmount" placeholder="현재 수량 입력"
	maxlength="1000" required></p>
	</div>
	
	<div>
	<p>태그 : 
	<input type="text" id="itemTag" name="itemTag" placeholder="태그 입력"
	maxlength="100" required></p>
	</div>
	
	<div>
	<p>상품 설명 : </p>
	<textarea rows="20" cols="120" id="itemContent" name="itemContent" placeholder="내용을 입력하세요." maxlength="1500" required></textarea><br>
	</div>
	
	</form>

	<div class="image-upload">
		<h2>이미지 파일 업로드</h2>
		<p>* 최대 용량은 10MB 입니다.</p>
		<div class="image-drop">이미지를 드래그 하세요.</div>
		<h2>선택한 이미지 파일 :</h2>
		<div class="image-list"></div>
	</div>

	<div class="attachDTOImg-list">
	</div>
	
	<div class="attachDTOFile-list">
	</div>

	<div class="button-container">
		<sec:authorize access="isAuthenticated()">
		<button id="registerBoard" class="button">등록</button>
		</sec:authorize>
		<button onclick="goBack()" class="button">뒤로가기</button>
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
        // regsiterForm 데이터 전송
        $('#registerBoard').click(function(e) {
            e.preventDefault();  // 기본 폼 제출 동작을 막음

            // form 객체 참조
            let registerForm = $('#registerForm');

            // 폼 데이터 준비
            let formData = new FormData(registerForm[0]);  // FormData 객체 생성 (폼 요소를 전송할 수 있음)
            let i = 0;

            // attachDTOImg-list의 각 input 태그 접근
            $('.attachDTOImg-list input[name="attachVO"]').each(function(){
                let attachVO = JSON.parse($(this).val());
                // attachPath, attachRealName, attachChgName, attachExtension을 hidden input으로 생성
                formData.append('attachList[' + i + '].attachPath', attachVO.attachPath);
                formData.append('attachList[' + i + '].attachRealName', attachVO.attachRealName);
                formData.append('attachList[' + i + '].attachChgName', attachVO.attachChgName);
                formData.append('attachList[' + i + '].attachExtension', attachVO.attachExtension);
                i++;
            });

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
    });
	</script>

	<script>
		$(document).ready(function() {
			// 차단할 확장자 정규식 (exe, sh, php, jsp, aspx, zip, alz)
			let blockedExtensions = /\.(exe|sh|php|jsp|aspx|zip|alz)$/i;

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
		});
		
		function goBack() {
			  const referrer = document.referrer;
			  if (referrer) {
			    window.location.href = referrer;  // 이전 페이지로 이동
			  } else {
			    alert("이전 페이지가 없습니다.");
			  }
			}
	</script>
<!-- area -->
</body>
</html>