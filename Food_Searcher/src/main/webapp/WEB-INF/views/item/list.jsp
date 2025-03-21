<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>

<style>

#area{
	flex-wrap: wrap; /* 넘치면 자동으로 줄 바꿈 */
    gap: 20px; /* 아이템 사이 여백 추가 */
}

li {
	display:inline-block;
}

</style>

<link rel="stylesheet"
	href="../resources/css/Base.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath }/resources/css/List.css">
	
<meta charset="UTF-8">
<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<title>상품 리스트</title>
</head>
<body>
<%@ include file="/WEB-INF/views/header.jsp"%>
<%@ include file ="../layout/side.jsp" %>
<div id="area">
			
<div style="display: flex; align-items: center; justify-content: space-between; width: 100%;">
    <h1>상품 리스트</h1>
    <div style="display: flex; align-items: center; justify-content: flex-end;">
    <span id="ctg" style="text-align: right; font-weight: bold;"></span>
	<p style="text-align: right;"> 상품 명 : 
	<input type="text" id="keyword" name="keyword" placeholder="검색어 입력">
	<button id="btn_search" class="button">검색</button></p>
	</div>
</div>
<div class="testDiv">
<sec:authorize access="hasRole('ROLE_MEMBER')">
</sec:authorize>
<br>
</div>

<hr>
		<div class="item-container">
			<c:forEach var="itemVO" items="${itemList}">
			<div class="item" onclick="window.location.href='detail?itemId=${itemVO.itemId}&keyword=${param.keyword}&type=${param.type}&pageNum=${param.pageNum == num ? '1' : param.pageNum}'">
					<input type="hidden" value="${itemVO.itemStatus }" >
					<c:set var="imageFound" value="false"/>
					<c:forEach var="attachVO" items="${attachVO}">
					<c:if test="${itemVO.itemId eq attachVO.itemId}">
					<div class="image_item">
						<img
     					src="../images/get?attachId=${attachVO.attachId }&attachChgName=${attachVO.attachChgName}" 
    					onerror="this.onerror=null; this.src='../resources/image/imageReady.png';">
					</div>
					<c:set var="imageFound" value="true"/>
				    </c:if>
			</c:forEach>
			<c:if test="${!imageFound}">
	            <div class="image_item">
	                <img 
	                     src="../resources/image/imageReady.png"/>
	            </div>
	        </c:if>
	        	<div class="nameDiv">
					<p class="titleText">${itemVO.itemName }</p>
				</div>
					<p class="priceText"><fmt:formatNumber value="${itemVO.itemPrice}" pattern="###,###,###"/>원</p>
					<input type="hidden" value="${itemVO.itemTag }">
					<input type="hidden" value="${itemVO.itemId }">
			</div>
			</c:forEach>
		</div>
	</div> <!-- area -->
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
				class="pg_button">이전</a></li>
		</c:if>

		<!-- 반복문으로 시작 번호부터 끝 번호까지 생성 -->
		<c:forEach begin="${pageMaker.startNum }" end="${pageMaker.endNum }"
			var="num">
			<li class="pagination_button ${param.pageNum == num ? 'selected' : ''}"
               onclick="changeColor(this, ${num}); return isNumber(${num})"></li>
               <a href="list?keyword=${param.keyword}&type=${param.type}&pageNum=${num}" class="pg_button">${num}</a>
		</c:forEach>

		<!-- 다음 버튼 생성을 위한 조건문 -->
		<c:if test="${pageMaker.isNext() }">
			<li class="pagination_button"><a href="${pageMaker.endNum + 1}"
				class="pg_button">다음</a></li>
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
	        const type = urlParams.get('type');
	        console.log(decodeURIComponent(keyword));
	        console.log(decodeURIComponent(type));
	        
	        if(type == 'ITEM_NAME') {
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
	        }

	        // 버튼을 생성한 상태를 로컬 스토리지에서 삭제
	        localStorage.removeItem('buttonCreated');
	    }
	    
	    $("#btn_search").click(function(){
	    	let typeInput = 'ITEM_NAME';
			let keywordInput = $('#keyword').val();
			let type = [];
			let keyword = [];
			
			if(keywordInput == '' || keywordInput == null) {
				return;
			}
				
			if (window.location.href.includes('type=MAIN_CTG&keyword=')) {
			    let mainCtg = decodeURIComponent(window.location.href.split('type=MAIN_CTG&keyword=')[1]);
			    type.push('MAIN_CTG');
			    keyword.push(mainCtg);
			}
				type.push(typeInput);
		    	keyword.push(keywordInput);
		    
		    const url = new URL(window.location.href);
	        url.searchParams.set("type", type);
	        url.searchParams.set("keyword", keyword);
	        window.location.href = url;
	        
	    })
	});

	
</script>	

</body>
</html>