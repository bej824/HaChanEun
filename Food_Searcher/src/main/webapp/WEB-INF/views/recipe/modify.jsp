<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<style type="text/css">
 textarea.ingredient {
    width: 700px;
	height: 65px;
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
	href="../resources/css/Base.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath }/resources/css/image.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath }/resources/css/attach.css">
<title>${recipeVO.recipeTitle }</title>
</head>
<body>
	<%@ include file ="../header.jsp" %>
	<div id="area">
	<h2>글 수정 페이지</h2>
	<form id="modifyForm" action="modify" method="POST" enctype="multipart/form-data">
		<input type="hidden" name="pageNum" value="${pagination.pageNum}">
		<input type="hidden" name="pageSize" value="${pagination.pageSize}">
		<input type="hidden" name="type" value="${pagination.type}">
		<input type="hidden" name="keyword" value="${pagination.keyword}">
		<div>
			<p>번호 : ${recipeVO.recipeId }</p>
			<input type="hidden" name="recipeId" value="${recipeVO.recipeId }" readonly>
		</div>
		<div>
			<p>제목 : </p>
			<input type="text" name="recipeTitle" placeholder="제목 입력" 
maxlength="20" value="${recipeVO.recipeTitle }" required>
		</div>
		<div>
			<p>작성자 : ${recipeVO.memberId}</p>
		</div>
		<div>
			<p>음식 : </p>
			<input type="text" name="recipeFood" value="${recipeVO.recipeFood }" maxlength="10" required>
		</div>
		<div>
			<p>카테고리 : </p>
			<select name="category">
				<option>${recipeVO.category }</option>
		        <option>한식</option>
		        <option>중식</option>
		        <option>일식</option>
		        <option>양식</option>
		        <option>음료</option>
		        <option>디저트</option>
		        <option>간편식</option>
		        <option>아시아 음식</option>
		    </select>
		</div>
		<div>
			<p>재료</p>
			<textarea rows="2" cols="120" id="ingredient" name="ingredient" class="ingredient" placeholder="재료 입력" maxlength="50" required>${recipeVO.ingredient }</textarea>
		</div>
		<div>
			<p>레시피 : </p>
			<textarea rows="20" cols="120" name="recipeContent" placeholder="내용 입력" 
maxlength="400" required>${recipeVO.recipeContent }</textarea>
		</div>

	<!-- 기존 첨부 파일 리스트 데이터 구성 -->
	<c:forEach var="attachVO" items="${recipeVO.attachList}" varStatus="status">
		<input type="hidden" class="input-attach-list" name="attachList[${status.index }].attachPath" value="${attachVO.attachPath }">
		<input type="hidden" class="input-attach-list" name="attachList[${status.index }].attachRealName" value="${attachVO.attachRealName }">
		<input type="hidden" class="input-attach-list" name="attachList[${status.index }].attachChgName" value="${attachVO.attachChgName }">
		<input type="hidden" class="input-attach-list" name="attachList[${status.index }].attachExtension" value="${attachVO.attachExtension }">
	</c:forEach>
	<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }">
	</form>
	
	<sec:authorize access="isAuthenticated() and principal.username == '${recipeVO.memberId }'">
		<button id="change-upload" class="button">파일 변경</button>
		</sec:authorize>
	<!-- 이미지 파일 영역 -->
	<div class="image-upload">
		<div class="image-view">
			<h2>이미지 파일 리스트</h2>
			<div class="image-list">
				<!-- 이미지 파일 처리 코드 -->
                <c:forEach var="attachVO" items="${idList}">
                    <c:if test="${attachVO.attachExtension eq 'jpg' or 
                                  attachVO.attachExtension eq 'jpeg' or 
                                  attachVO.attachExtension eq 'png' or 
                                  attachVO.attachExtension eq 'gif'}">
                        <div class="image_item">
                            <a href="../image/get?attachId=${attachVO.attachId }" target="_blank">
                                <img width="100px" height="100px" 
                                     src="../image/get?attachId=${attachVO.attachId }&attachExtension=${attachVO.attachExtension}"/>
                            </a>
                        </div>
                    </c:if>
                </c:forEach>
			</div>
		</div>
		<div class="image-modify" style="display : none;">
			<h2>이미지 파일 업로드</h2>
			<p>* 이미지 파일은 최대 3개까지 가능합니다.</p>
			<p>* 최대 용량은 10MB 입니다.</p>
			<div class="image-drop">이미지를 드래그 하세요.</div>
			<h2>선택한 이미지 파일 :</h2>
			<div class="image-list"></div>
		</div>
	</div>
	
	<div class="attachDTOImg-list">
	</div>

	<div class="button-container">
	<sec:authorize access="isAuthenticated() and principal.username == '${recipeVO.memberId }'">
	<button id="modifyBoard" class="button">등록</button>
	</sec:authorize>
	<button onclick="goBack()" class="button">뒤로가기</button>
	</div>
	</div>

	<script src="${pageContext.request.contextPath }/resources/js/image.js"></script>
	<script	src="${pageContext.request.contextPath }/resources/js/attach.js"></script>
	
    <script type="text/javascript">
        $(document).ajaxSend(function(e, xhr, opt) {
            var token = $("meta[name='_csrf']").attr("content");
            var header = $("meta[name='_csrf_header']").attr("content");

            xhr.setRequestHeader(header, token);
        });
        let isUploadChanged = false; // 버튼이 클릭되었는지 여부를 추적하는 변수

        $(document).ready(function() {
            // 이미지 변경 버튼 클릭 시
            $('#change-upload').click(function() {
                if (!confirm('기존에 업로드 파일들은 삭제됩니다. 계속 하시겠습니까?')) {
                    return;
                }
                isUploadChanged = true; // 버튼 클릭 시, 삭제 작업이 허용됨
                $('.image-modify').show();
                $('.image-view').hide();
                $('.input-attach-list').remove(); // input-attach-list 삭제
            });

            // 수정 버튼 클릭 시 폼 데이터 전송
            $('#modifyBoard').click(function() {
                let modifyForm = $('#modifyForm');
                let formData = new FormData(modifyForm[0]);
                let i = 0;

                if (isUploadChanged) {
                // attachDTOImg-list의 각 input 태그 접근
                $('.attachDTOImg-list input[name="attachVO"]').each(function() {
                    let attachVO = JSON.parse($(this).val());
                    formData.append('attachList[' + i + '].attachPath', attachVO.attachPath);
                    formData.append('attachList[' + i + '].attachRealName', attachVO.attachRealName);
                    formData.append('attachList[' + i + '].attachChgName', attachVO.attachChgName);
                    formData.append('attachList[' + i + '].attachExtension', attachVO.attachExtension);
                    i++;
                });
                } else {
                	
                }

                // 비동기적으로 폼 전송
                $.ajax({
                    url: 'modify', // 서버 URL
                    type: 'POST',
                    data: formData,
                    processData: false,  // jQuery가 데이터 처리하지 않도록 설정
                    contentType: false,  // jQuery가 Content-Type을 설정하지 않도록 설정
                    success: function(response) {
                        alert('업로드 성공!');
                        window.location.href = "../recipe/detail?recipeId="+"${recipeVO.recipeId }";
                    },
                    error: function(xhr, status, error) {
                        alert('업로드 실패: ' + error);
                    }
                });
            });
        });
    </script>
		
	<script>
		function goBack() {
		  const referrer = document.referrer;
		  if (referrer) {
		    window.location.href = referrer;  // 이전 페이지로 이동
		  } else {
		    alert("이전 페이지가 없습니다.");
		  }
		}
	</script>	
</body>
</html>