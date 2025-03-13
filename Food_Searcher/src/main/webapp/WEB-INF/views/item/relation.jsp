<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<style type="text/css">
.item-container {
        display: flex;
        flex-wrap: wrap;  /* 아이템들이 여러 줄로 자동 배치되게 */
        gap: 20px;        /* 아이템 간의 간격 */
        
    }
</style>
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
	<hr>
	<p>${itemVO.itemName } 연관 상품</p>
	<div class="item-container">
	<c:if test="${pageMaker.isPrev() }">
			<li class="pagination_button"><a href="detail?itemId=${itemVO.itemId}&pageNum=${pageMaker.pagination.pageNum - 1}"
				class="button">이전</a></li>
		</c:if>
		<c:forEach var="itemList" items="${itemList}">
			<div class="item" onclick="window.location.href='detail?itemId=${itemList.itemId}&keyword=${param.keyword}&type=${param.type}&pageNum=${param.pageNum == num ? '1' : param.pageNum}'">
				<input type="hidden" value="${itemList.itemStatus }" >
				<c:forEach var="attachAll" items="${attachAll}">
					<c:if test="${itemList.itemId eq attachAll.itemId}">
						<div class="image_item">
						        <img width="200px" height="120px" 
						        src="../images/get?attachId=${attachAll.attachId }&attachExtension=${attachAll.attachExtension}" />
						</div>
					</c:if>
				</c:forEach>
					<p>상품명 : ${itemList.itemName }</p>
					<p>가격 : <fmt:formatNumber value="${itemList.itemPrice}" pattern="###,###,###"/>원</p>
					
			</div>
		</c:forEach>
		<c:if test="${pageMaker.isNext() }">
			<li class="pagination_button"><a href="detail?itemId=${itemVO.itemId}&pageNum=${pageMaker.pagination.pageNum + 1}"
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