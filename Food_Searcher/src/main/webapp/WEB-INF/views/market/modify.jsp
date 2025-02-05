<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="com.food.searcher.domain.MarketVO" %>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet"
	href="../resources/css/Detail.css">
	<link rel="stylesheet"
	href="../resources/css/Base.css">
<meta charset="UTF-8">
<title>${marketVO.marketTitle }</title>
</head>
<body>
<%@ include file ="/WEB-INF/views/header.jsp" %>
<div id="area">
	<h2>글 수정 페이지</h2>
	
	<form action="modify" method="POST">
		<!-- CSRF 토큰 -->
	    <input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }">
	
		<sec:authorize access="!hasRole('ROLE_ADMIN')">
			<script type="text/javascript">
				alert('관리자만 접근이 가능합니다.');
				window.history.back();
			</script>
		</sec:authorize>
		
		<div>
			<p>제목 :</p>
			<input type="text" name="marketTitle" placeholder="제목 입력"
				maxlength="30" value="${marketVO.marketTitle }" required>
		</div>
		
		<input type="hidden" name="marketId" value="${marketVO.marketId }">
		
		<div>
			<p>음식 : </p>
			<input type="text" id="marketFood" name="marketFood" placeholder="음식 이름 입력" maxlength="100" value="${marketVO.marketFood }" required>
		</div>
		
		<div>
			<p>가게 : </p>
			<input type="text" id="marketName" name="marketName" placeholder="가게 이름 입력" maxlength="100" value="${marketVO.marketName }" required>
		</div>

		 <div>
         <p>지역 : </p>
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
            

		<div>
			<p>내용 :</p>
			<textarea rows="20" cols="120" name="marketContent"
				placeholder="내용 입력" maxlength="300" required>${marketVO.marketContent }</textarea>
		</div>

		<div>
			<input type="submit" value="등록">
			
		</div>
	</form>
	</div>
</body>
</html>