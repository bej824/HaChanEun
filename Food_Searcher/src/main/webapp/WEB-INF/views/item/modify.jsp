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
<meta charset="UTF-8">
<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>
<title>Insert title here</title>
</head>
<body>
<%@ include file ="/WEB-INF/views/header.jsp" %>
	<!-- 게시글 -->
	<div id="area">
	
	<form action="modify" method="POST">
	<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }">
	<div>
		<h2>${itemVO.itemName }</h2>
		<p>상품명 입력</p>
		<input type="text" name="itemName" placeholder="상품명 입력"
				maxlength="30" value="${itemVO.itemName }" required>
		<div id="img">(썸네일)</div><br>
		<div>
		
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
	
		<div>
		<input type="submit" value="등록">	
		</div>
		
		
		</form>
	</div> <!-- area -->
</body>
</html>