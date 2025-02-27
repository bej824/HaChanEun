<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet"
	href="../resources/css/Base.css">
<style>
.buy {
	background-color: #f9f9f9; /* 배경색 설정 */
    border: 1px solid #ddd; /* 테두리 추가 */
    padding: 10px; /* 첨부 목록 내부에 여백 추가 */
}

.button {
	margin : 3px;
}

#itemContent{
	width:400px;
	height:100px;
}

#img {
	width:200px;
	height:200px;
	background-color: #f9f9f9; /* 배경색 설정 */
    border: 1px solid #ddd; /* 테두리 추가 */
    padding: 10px; /* 첨부 목록 내부에 여백 추가 */
</style>
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<script src="${pageContext.request.contextPath }/resources/js/images.js"></script>
<meta charset="UTF-8">
<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>
<title>Insert title here</title>
</head>
<body>
<%@ include file ="/WEB-INF/views/header.jsp" %>
	<!-- 게시글 -->
	<div id="area">
	
	<form id="modifyForm" action="modify" method="POST">
	<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }">
	<div>
		<h2>${itemVO.itemName }</h2>
		<p>상품명 입력</p>
		<input type="text" name="itemName" placeholder="상품명 입력"
				maxlength="30" value="${itemVO.itemName }" required>

		<div>
		
		<!-- 이미지 파일 영역 -->
	<div class="image-upload">
		<div class="image-view">
			<div class="image-list">
				<!-- 이미지 파일 처리 코드 -->
                <c:forEach var="attachVO" items="${idList}">
                    <c:if test="${attachVO.attachExtension eq 'jpg' or 
                                  attachVO.attachExtension eq 'jpeg' or 
                                  attachVO.attachExtension eq 'png' or 
                                  attachVO.attachExtension eq 'gif'}">
                        <div class="image_item">
                            <a href="../images/get?attachId=${attachVO.attachId }" target="_blank">
                                <img width="100px" height="100px" 
                                     src="../images/get?attachId=${attachVO.attachId }&attachExtension=${attachVO.attachExtension}"/>
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
		
		<p>상품 설명</p>
		<textarea rows="20" cols="80" name="itemContent" placeholder="내용 입력"
				maxlength="1000" required>${itemVO.itemContent }</textarea>	
		</div>
		
		<p>등록 일자 : <fmt:formatDate pattern="yyyy-MM-dd" value="${itemVO.itemDate }" />  |  현재 수량 : 
			<input type="text" name="itemAmount" placeholder="수량 변경"
			maxlength="100" value="${itemVO.itemAmount }" required></p>
		
				
		<p>가격 : <input type="text" name="itemPrice" placeholder="가격 입력"
				maxlength="30" value="${itemVO.itemPrice }" required> 원</p>
		
		<p>분류 :  <input type="text" name="itemTag" placeholder="태그 입력"
				maxlength="30" value="${itemVO.itemTag }" required> 원</p>
		
		
		<p>판매자 : ${itemVO.memberId } </p>
		
		<span>판매 상태 :
		<select>
			<option value="1">판매 중</option>
			<option value="2">판매 중단</option>
		</select>
		</span>
		
		<input type="hidden" name="itemId" value="${itemVO.itemId }">
		<input type="hidden" name="itemStatus" value="${itemVO.itemStatus }">
	</div>
		
		<!-- 기존 첨부 파일 리스트 데이터 구성 -->
	<c:forEach var="attachVO" items="${itemVO.attachList}" varStatus="status">
		<input type="hidden" class="input-attach-list" name="attachList[${status.index }].attachPath" value="${attachVO.attachPath }">
		<input type="hidden" class="input-attach-list" name="attachList[${status.index }].attachRealName" value="${attachVO.attachRealName }">
		<input type="hidden" class="input-attach-list" name="attachList[${status.index }].attachChgName" value="${attachVO.attachChgName }">
		<input type="hidden" class="input-attach-list" name="attachList[${status.index }].attachExtension" value="${attachVO.attachExtension }">
	</c:forEach>
	<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }">
		
		</form>
		
	
		
	<sec:authorize access="isAuthenticated() and principal.username == '${itemVO.memberId }'">
		<button id="change-upload" class="button">파일 변경</button>
	</sec:authorize>	
	<div class="button-container">
	<sec:authorize access="isAuthenticated() and principal.username == '${itemVO.memberId }'">
	<button id="modifyBoard" class="button">등록</button>
	</sec:authorize>
	</div>
	
	<div class="attachDTOImg-list">
	</div>
	
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
                        window.location.href = "../item/detail?itemId="+"${itemVO.itemId }";
                    },
                    error: function(xhr, status, error) {
                        alert('업로드 실패: ' + error);
                    }
                });
            });
        });
    </script>
    
	</div> <!-- area -->
</body>
</html>