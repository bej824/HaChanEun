<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<style>
.item-container {
        display: flex;
        flex-wrap: wrap;  /* 아이템들이 여러 줄로 자동 배치되게 */
        gap: 20px;        /* 아이템 간의 간격 */
        
    }

#area{
	flex-wrap: wrap; /* 넘치면 자동으로 줄 바꿈 */
    gap: 20px; /* 아이템 사이 여백 추가 */
}

.item {
	margin-top: 20px; /* 첨부 목록 위에 여백 추가 */
    background-color: #f9f9f9; /* 배경색 설정 */
    border: 1px solid #ddd; /* 테두리 추가 */
    padding: 10px; /* 첨부 목록 내부에 여백 추가 */
    margin-bottom: 20px; /* 첨부 목록 아래에 여백 추가 */
    height: 300px; /* 첨부 목록의 고정 높이 설정 */
    width: 250px;     /* 각 아이템의 너비 */
    box-sizing: border-box;
}

li {
	display:inline-block;
}

</style>

<link rel="stylesheet"
	href="../resources/css/Base.css">
<link rel="stylesheet"
	href="../resources/css/Detail.css">
	
<meta charset="UTF-8">
<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<title>상품 리스트</title>
</head>
<body>
<%@ include file="/WEB-INF/views/header.jsp"%>
<div id="area">

<h1>상품 리스트</h1>

<div class="testDiv">
<sec:authorize access="hasRole('ROLE_MEMBER')">
<a id="cartLink" href="../cart/list/<sec:authentication property="name" />">장바구니로 이동</a>
</sec:authorize>
<br>
</div>

<a href="../product/reviewRegister?itemId=47">리뷰 작성 테스트</a>

	<form id="searchForm" method="get" action="list">
			<input type="hidden" name="pageNum">
			<select name="type">
				<option value="ITEM_NAME">상품명</option>
				<option value="MAIN_CTG">메인 태그</option>
				<option value="SUB_CTG">서브 태그</option>
			</select>
			<input type="text" name="keyword">
			<button class="button"> 검색 </button><br>
	</form>
<hr>
		<div class="item-container">
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
					<p>가격 : <fmt:formatNumber value="${itemVO.itemPrice}" pattern="###,###,###"/>원</p>
					<input type="hidden" value="${itemVO.itemTag }">
					<input type="hidden" value="${itemVO.itemId }">
			</div>
			</c:forEach>
		</div>
	<input type="hidden" id="memberId" value=<sec:authentication property="name" />>
	<input type="hidden" value="${itemVO.itemStatus }" >
	
	<form id="listForm" action="list" method="get">
	    	<input type="hidden" name="pageNum" >
	    	<input type="hidden" name="type" >
			<input type="hidden" name="keyword">
	    </form>
	
	<ul>
		<!-- 이전 버튼 생성을 위한 조건문 -->
		<c:if test="${pageMaker.isPrev() }">
			<li class="pagination_button"><a href="${pageMaker.startNum - 1}"
				class="button">이전</a></li>
		</c:if>

		<!-- 반복문으로 시작 번호부터 끝 번호까지 생성 -->
		<c:forEach begin="${pageMaker.startNum }" end="${pageMaker.endNum }"
			var="num">
			<li class="pagination_button ${param.pageNum == num ? 'selected' : ''}"
               onclick="changeColor(this, ${num}); return isNumber(${num})"></li>
               <a href="list?keyword=${param.keyword}&type=${param.type}&pageNum=${num}" class="button">${num}</a>
		</c:forEach>

		<!-- 다음 버튼 생성을 위한 조건문 -->
		<c:if test="${pageMaker.isNext() }">
			<li class="pagination_button"><a href="${pageMaker.endNum + 1}"
				class="button">다음</a></li>
		</c:if>
	</ul>
	
	<input type="hidden" id="newbutton">

	
<script type="text/javascript">
	// pagination_button을 클릭하면 페이지 이동
	$(".pagination_button a").on("click", function(e){
		let listForm = $("#listForm"); // form 객체 참조
		e.preventDefault(); // a 태그 이벤트 방지
	
		let pageNum = $(this).attr("href"); // a태그의 href 값 저장
		// 현재 페이지 사이즈값 저장
		let type = "<c:out value='${pageMaker.pagination.type }' />";
		let keyword = "<c:out value='${pageMaker.pagination.keyword }' />";
		 
		// 페이지 번호를 input name='pageNum' 값으로 적용
		listForm.find("input[name='pageNum']").val(pageNum);
		// type 값을 적용
		listForm.find("input[name='type']").val(type);
		// keyword 값을 적용
		listForm.find("input[name='keyword']").val(keyword);
		
		// ⭐ 모든 버튼에서 'selected' 클래스를 제거 후 현재 버튼에 추가
        $(".pagination_button").removeClass("selected");
        $(this).parent().addClass("selected");

        // URL을 새로 업데이트
        const url = new URL(window.location.href);
        url.searchParams.set("pageNum", pageNum);
        url.searchParams.set("type", type);
        url.searchParams.set("keyword", keyword);
        window.history.pushState({}, '', url); 
		
		listForm.submit(); // form 전송
	}); // end on()
	
	$("#searchForm button").on("click", function(e){
		let searchForm = $("#searchForm");
		e.preventDefault(); // a 태그 이벤트 방지
		
		let keywordVal = searchForm.find("input[name='keyword']").val();  // 사용자가 입력한 키워드 저장
		console.log(keywordVal);
		if(keywordVal == '') {
			alert('검색 내용을 입력하세요.');
			return;
		}
		
		let pageNum = 1; // 검색 후 1페이지로 고정
		// 현재 페이지 사이즈값 저장
		
		localStorage.setItem('buttonCreated', 'true');
		
		// 페이지 번호를 input name='pageNum' 값으로 적용
		searchForm.find("input[name='pageNum']").val(pageNum);
		searchForm.submit(); // form 전송
	}); // end on()
	
	$(document).ready(function() {
	    // 로컬 스토리지에서 'buttonCreated' 상태 가져오기
	    let buttonCreated = localStorage.getItem('buttonCreated');

	    // 'buttonCreated' 값이 true일 경우에만 새 버튼을 추가
	    if (buttonCreated === 'true') {
	        let searchForm = $("#searchForm");
	        const urlParams = new URLSearchParams(window.location.search);
	        const keyword = urlParams.get('keyword');
	        console.log(decodeURIComponent(keyword));
	        
	        // 새로운 버튼을 동적으로 생성
	        let newButton = $('<button>')
	            .text('쿠팡')
	            .attr('type', 'button')
	            .addClass('button')
	            .on('click', function() {
	                alert(keyword+' 이동합니다!');
	                let url = 'https://www.coupang.com/np/search?component=&q=' + encodeURIComponent(keyword);
                    window.open(url, '_blank');
	            });

	        // 새 버튼을 폼에 추가
	        searchForm.append(newButton);

	        // 버튼을 생성한 상태를 로컬 스토리지에서 삭제
	        localStorage.removeItem('buttonCreated');
	    }
	});

	
</script>	
</div> <!-- area -->
</body>
</html>