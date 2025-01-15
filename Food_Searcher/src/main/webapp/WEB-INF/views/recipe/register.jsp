<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<style type="text/css">
.button {
	background-color: #04AA6D;
	border: none;
	color: white;
	padding: 6px 12px;
	text-align: center;
	text-decoration: none;
	display: inline-block;
	font-size: 16px;
	margin: 4px 2px;
	cursor: pointer;
}

textarea {
	width: 700px;
	height: 280px;
	padding: 12px 20px;
	box-sizing: border-box;
	border: 2px solid #ccc;
	border-radius: 4px;
	background-color: #f8f8f8;
	font-size: 16px;
	resize: none;
}
</style>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<!-- css 파일 불러오기 -->
<link rel="stylesheet"
	href="${pageContext.request.contextPath }/resources/css/image.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath }/resources/css/attach.css">
<title>글 작성 페이지</title>
</head>
<body>
	<% session.getAttribute("memberId"); %>
	<%@ include file ="../header.jsp" %>
	<h2>글 작성 페이지</h2>
	<form id="registerForm" action="register" method="POST" enctype="multipart/form-data">
		<!-- input 태그의 name은 vo의 멤버 변수 이름과 동일하게 작성 -->
		<div>
			<p>제목 :</p>
			<input type="text" id="recipeTitle" name="recipeTitle" placeholder="제목 입력" maxlength="20" required>
		</div>
		<div>
			<p>작성자 :</p>
			<input type="text" name="memberId" value="<sec:authentication property="name" />" maxlength="10" required readonly>
		</div>
		<br>
		<div>
			<p>음식 :</p>
			<input type="text" id="recipeFood" name="recipeFood" placeholder="요리 이름 입력">
		</div>
		<div>
			<p>내용 :</p>
			<textarea rows="20" cols="120" id="recipeContent" name="recipeContent" placeholder="내용 입력" maxlength="300" required>
재료 : 

레시피 : </textarea>
		</div>
		<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }">
	</form>
	
		<div class="image-upload">
		<h2>이미지 파일 업로드</h2>
		<p>* 이미지 파일은 최대 3개까지 가능합니다.</p>
		<p>* 최대 용량은 10MB 입니다.</p>
		<div class="image-drop"></div>
		<h2>선택한 이미지 파일 :</h2>
		<div class="image-list"></div>
	</div>

	<hr>
	<div class="attach-upload">
		<h2>첨부 파일 업로드</h2>
		<p>* 첨부 파일은 최대 3개까지 가능합니다.</p>
		<p>* 최대 용량은 10MB 입니다.</p>
		<input type="file" id="attachInput" name="files" multiple="multiple"><br>
		<h2>선택한 첨부 파일 정보 :</h2>
		<div class="attach-list"></div>
	</div>

	<div class="attachDTOImg-list">
	</div>
	
	<div class="attachDTOFile-list">
	</div>

	<button id="registerBoard" class="button">등록</button>
	<button onclick="goBack()" class="button">뒤로가기</button>

	<script src="${pageContext.request.contextPath }/resources/js/image.js"></script>
	<script src="${pageContext.request.contextPath }/resources/js/attach.js"></script>

<script>
    // ajaxSend() : AJAX 요청이 전송되려고 할 때 실행할 함수를 지정
    // ajax 요청을 보낼 때마다 CSRF 토큰을 요청 헤더에 추가하는 코드
    $(document).ajaxSend(function(e, xhr, opt){
        var token = $("meta[name='_csrf']").attr("content");
        var header = $("meta[name='_csrf_header']").attr("content");

        xhr.setRequestHeader(header, token);
    });

    $(document).ready(function() {
        // regsiterForm 데이터 전송
        $('#registerBoard').click(function(e) {
            e.preventDefault();  // 기본 폼 제출 동작을 막음

            let title = $('#recipeTitle').val().trim(); // 문자열의 양 끝 공백 제거
            let content = $('#recipeContent').val().trim();

            if (title === '' || content === '') {
                alert("제목과 내용을 모두 입력해주세요.");
                return;
            }

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

            // attachDTOFile-list의 각 input 태그 접근
            $('.attachDTOFile-list input[name="attachVO"]').each(function(){
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
                    window.location.href = "../recipe/list";
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
	</script>
	
	<script type="text/javascript">
		function goBack() {
			window.history.back();
		}
	</script>
</body>
</html>