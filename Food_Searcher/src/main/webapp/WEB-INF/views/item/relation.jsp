<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<title>Insert title here</title>
  <style>
    .quick-scroll {
      position: fixed;
      bottom: 20px;
      right: 20px;
      display: flex;
      flex-direction: column;
      gap: 10px;
    }

    .quick-scroll button {
      background-color: green;
      color: white;
      border: none;
      padding: 10px 10px;
      font-size: 16px;
      cursor: pointer;
      border-radius: 5px;
      transition: background-color 0.3s ease;
    }

    .quick-scroll button:hover {
      background-color: #0056b3;
    }
  </style>
</head>
<body>
	<p>연관 상품(item/detail 에 들어갈 예정)</p>
	<div class="item-container">
	<c:if test="${pageMaker.isPrev() }">
			<li class="pagination_button"><a href="${pageMaker.pagination.pageNum - 1}"
				class="button">이전</a></li>
		</c:if>
		<c:forEach var="itemVO" items="${itemList}">
			<div class="item" onclick="window.location.href='detail?itemId=${itemVO.itemId}&keyword=${param.keyword}&type=${param.type}&pageNum=${param.pageNum == num ? '1' : param.pageNum}'">
				<input type="hidden" value="${itemVO.itemStatus }" >
				<c:forEach var="attachVO" items="${attachVO}">
					<c:if test="${itemVO.itemId eq attachVO.itemId}">
						<div class="image_item">
						        <img width="200px" height="120px" 
						        src="../images/get?attachId=${attachVO.attachId }&attachExtension=${attachVO.attachExtension}" />
						</div>
					</c:if>
				</c:forEach>
					<p>상품명 : ${itemVO.itemName }</p>
					<p>상품번호 : ${itemVO.itemId }</p>
					<p>분류 : ${itemVO.itemTag }</p>
					<p>가격 : <fmt:formatNumber value="${itemVO.itemPrice}" pattern="###,###,###"/>원
							&nbsp;&nbsp;&nbsp; 상태 : ${itemVO.itemStatus }</p>
					
			</div>
		</c:forEach>
		<c:if test="${pageMaker.isNext() }">
			<li class="pagination_button"><a href="${pageMaker.pagination.pageNum + 1}"
				class="button">다음</a></li>
		</c:if>
	</div>
	
	<!-- 스크롤 버튼 -->
	<div class="quick-scroll">
	   <button id="scrollTop" class="quick-scroll__top">▲</button>
	   <button id="scrollBottom" class="quick-scroll__bottom">▼</button>
	</div>
	<script>
	  $(document).ready(function() {
	    // 페이지 상단으로 스크롤
	    $('#scrollTop').on('click', function() {
	      $('html, body').animate({ scrollTop: 0 }, 'smooth');
	    });
	
	    // 페이지 하단으로 스크롤
	    $('#scrollBottom').on('click', function() {
	      $('html, body').animate({ scrollTop: $(document).height() }, 'smooth');
	    });
	  });
	</script>
</body>
</html>