<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<style type="text/css">
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

    .image-list {
        display: flex;
        flex-wrap: wrap; /* 이미지가 가로로 나오고, 공간이 부족할 경우 줄 바꿈 */
    }
    .image_item {
        margin: 5px; /* 이미지 간 간격 */
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
<title>${recipeVO.recipeTitle }</title>
</head>
<body>
	<%@ include file ="../header.jsp" %>
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
			<input type="hidden" name="memberId" value="${recipeVO.memberId}">
			
		</div>
		<div>
			<p>음식 : </p>
			<input type="text" name="recipeFood" value="${recipeVO.recipeFood }" required>
		</div>
		<div>
			<input type="file" name="file" multiple="multiple">
		</div>
		<div>
			<p>내용 : </p>
			<textarea rows="20" cols="120" name="recipeContent" placeholder="내용 입력" 
maxlength="300" required>${recipeVO.recipeContent }</textarea>
		</div>
		<div>
			<input type="submit" value="등록" class="button">
			<button onclick="goBack()" class="button">뒤로가기</button>
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
	
		<button id="change-upload">파일 변경</button>
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
                                  attachVO.attachExtension eq 'gif' or
                                  attachVO.attachExtension eq 'webp'}">
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
			<div class="image-drop"></div>
			<h2>선택한 이미지 파일 :</h2>
			<div class="image-list"></div>
		</div>
	</div>
	
	<!-- 첨부 파일 영역 -->
	<div class="attach-upload">
		<div class="attach-view">
			<h2>첨부 파일 리스트</h2>
			<div class="attach-list">
			<c:forEach var="attachVO" items="${idList}">
		 		<c:if test="${not (attachVO.attachExtension eq 'jpg' or 
			    			  attachVO.attachExtension eq 'jpeg' or 
			    			  attachVO.attachExtension eq 'png' or 
			    			  attachVO.attachExtension eq 'gif')}">
			    	<div class="attach_item">
			    	<p><a href="../attach/download?attachId=${attachVO.attachId }">${attachVO.attachRealName }.${attachVO.attachExtension }</a></p>
			    	</div>
			    </c:if>
			</c:forEach>		
			</div>
		</div>
		<div class="attach-modify" style="display : none;">
			<h2>첨부 파일 업로드</h2>
			<p>* 첨부 파일은 최대 3개까지 가능합니다.</p>
			<p>* 최대 용량은 10MB 입니다.</p>
			<input type="file" id="attachInput" name="files" multiple="multiple"><br>
			<h2>선택한 첨부 파일 정보 :</h2>
			<div class="attach-list"></div>
		</div>
	</div>
	
	<div class="attachDTOImg-list">
	</div>
	
	<div class="attachDTOFile-list">
	</div>

	<button id="modifyBoard">등록</button>

	<script src="${pageContext.request.contextPath }/resources/js/image.js"></script>
	<script	src="${pageContext.request.contextPath }/resources/js/attach.js"></script>
	
	<script type="text/javascript">
	
	$(document).ajaxSend(function(e, xhr, opt){
		var token = $("meta[name='_csrf']").attr("content");
		var header = $("meta[name='_csrf_header']").attr("content");
		
		xhr.setRequestHeader(header, token);
	});
	
	$(document).ready(function(){
	    // 이미지 변경 버튼 클릭 시
	    $('#change-upload').click(function(){
	    	if(!confirm('기존에 업로드 파일들은 삭제됩니다. 계속 하시겠습니까?')){
	    		return;
	    	}
	        $('.image-modify').show();
	        $('.image-view').hide();
	        $('.attach-modify').show();
	        $('.attach-view').hide();
	        $('.input-attach-list').remove(); // input-attach-list 삭제
	    });

		// modifyForm 데이터 전송
		$('#modifyBoard').click(function() {
			// form 객체 참조
			let modifyForm = $('#modifyForm');
			
			// attachVOImg-list의 각 input 태그 접근
			let i = 0;
			$('.attachDTOImg-list input[name="attachVO"]').each(function(){
				console.log(this);
				// JSON attachVO 데이터를 object 변경
				let attachVO = JSON.parse($(this).val());
				// attachPath input 생성
				let inputPath = $('<input>').attr('type', 'hidden')
						.attr('name', 'attachList[' + i + '].attachPath');
				inputPath.val(attachVO.attachPath);
				
				// attachRealName input 생성
				let inputRealName = $('<input>').attr('type', 'hidden')
						.attr('name', 'attachList[' + i + '].attachRealName');
				inputRealName.val(attachVO.attachRealName);
				
				// attachChgName input 생성
				let inputChgName = $('<input>').attr('type', 'hidden')
						.attr('name', 'attachList[' + i + '].attachChgName');
				inputChgName.val(attachVO.attachChgName);
				
				// attachExtension input 생성
				let inputExtension = $('<input>').attr('type', 'hidden')
						.attr('name', 'attachList[' + i + '].attachExtension');
				inputExtension.val(attachVO.attachExtension);
				
				// form에 태그 추가
				modifyForm.append(inputPath);
				modifyForm.append(inputRealName);
				modifyForm.append(inputChgName);
				modifyForm.append(inputExtension);
				
				i++;
			});
			
			// attachVOFile-list의 각 input 태그 접근
			$('.attachDTOFile-list input[name="attachVO"]').each(function(){
				console.log(this);
				// JSON attachVO 데이터를 object 변경
				let attachVO = JSON.parse($(this).val());
				// attachPath input 생성
				let inputPath = $('<input>').attr('type', 'hidden')
						.attr('name', 'attachList[' + i + '].attachPath');
				inputPath.val(attachVO.attachPath);
				
				// attachRealName input 생성
				let inputRealName = $('<input>').attr('type', 'hidden')
						.attr('name', 'attachList[' + i + '].attachRealName');
				inputRealName.val(attachVO.attachRealName);
				
				// attachChgName input 생성
				let inputChgName = $('<input>').attr('type', 'hidden')
						.attr('name', 'attachList[' + i + '].attachChgName');
				inputChgName.val(attachVO.attachChgName);
				
				// attachExtension input 생성
				let inputExtension = $('<input>').attr('type', 'hidden')
						.attr('name', 'attachList[' + i + '].attachExtension');
				inputExtension.val(attachVO.attachExtension);
				
				// form에 태그 추가
				modifyForm.append(inputPath);
				modifyForm.append(inputRealName);
				modifyForm.append(inputChgName);
				modifyForm.append(inputExtension);
				
				i++;
			});
			modifyForm.submit();
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