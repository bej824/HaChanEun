<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>랭킹</title>
</head>
<body>
	<%@ include file ="header.jsp" %>
	<div id="area">
	<form id="searchForm" method="GET" action="ranking" class="search">
	    <select name="type"  id="type" onchange="updateFilters()">
	    	<option value="">전체</option>
	        <option value="나이">나이</option>
	        <option value="성별">성별</option>
	        <option value="MBTI">MBTI</option>
	        <option value="별자리">별자리</option>
	    </select>
	    
	    <select name="keyword" id="keyword" style="display:none;">
        <!-- 추가적인 옵션들이 동적으로 들어갈 부분 -->
    	</select>
	    <button type="submit" class="button">검색</button>
	</form>
	
	<h3>레시피</h3>
	<table border="1">
	<thead>
		<tr>
				<th style="width: 80px">번호</th>
				<th style="width: 500px">제목</th>
				<th style="width: 100px">작성자</th>
				<th style="width: 80px">댓글 수</th>
				<th style="width: 80px">좋아요 수</th>
				<c:if test="${not empty type}">
				<th style="width: 100px">${type }</th>
				</c:if>
		</tr>
		</thead>
		<tbody>
			<c:forEach var="RecipeLikesVO" items="${likeList }" varStatus="status">
			<c:if test="${status.index < 10}">
				<tr onclick="window.location.href='recipe/detail?recipeId=${RecipeLikesVO.recipeId }'">
					<td>${RecipeLikesVO.recipeId }</td>
					<td>${recipeList[status.index].recipeTitle }</td>
					<td>${recipeList[status.index].memberId }</td>
					<td>${recipeList[status.index].replyCount }</td>
					<td>${RecipeLikesVO.likeCount }</td>
					<c:if test="${not empty keyword }">
					<td>${keyword }</td>
					</c:if>
				</tr>
			</c:if>
			</c:forEach>
		</tbody>
	</table>
	</div>
	<script>
    function updateFilters() {
        let type = document.getElementById("type").value;
        let keyword = document.getElementById("keyword");

        // 추가 필터 초기화 (기존 옵션 제거)
        keyword.innerHTML = '';

        // 필터를 선택한 type 값에 따라 다르게 처리
        if (type === "나이") {
            // '나이'에 대한 추가 필터
            let options = ["10대 이하", "10대", "20대", "30대", "40대", "50대 이상"];
            keyword.style.display = "inline";  // 추가 필터 보이기
            options.forEach(function(optionText) {
                let option = document.createElement("option");
                option.value = optionText;
                option.text = optionText;
                keyword.appendChild(option);
            });
        } else if (type === "성별") {
            // '성별'에 대한 추가 필터
            let options = ['male', 'female'];
            keyword.style.display = "inline";  // 추가 필터 보이기
            options.forEach(function(optionText) {
                let option = document.createElement("option");
                option.value = optionText;
                option.text = optionText;
                keyword.appendChild(option);
            });
        } else if (type === "MBTI") {
            // 'MBTI'에 대한 추가 필터
            let options = ['ISFJ', 'ISTJ', 'ISTP', 'ISFP', 'INFJ', 'INTJ', 'INFP', 'INTP', 'ESTP', 'ESFP', 'ESTJ', 'ESFJ', 'ENFP', 'ENTP', 'ENFJ', 'ENTJ'];
            keyword.style.display = "inline";  // 추가 필터 보이기
            options.forEach(function(optionText) {
                let option = document.createElement("option");
                option.value = optionText;
                option.text = optionText;
                keyword.appendChild(option);
            });
        } else if (type === "별자리") {
            // '별자리'에 대한 추가 필터
            let options = ['양자리', '황소자리', '쌍둥이자리', '게자리', '사자자리', '처녀자리', '천칭자리', '전갈자리', '사수자리', '염소자리', '물병자리', '물고기자리'];
            keyword.style.display = "inline";  // 추가 필터 보이기
            options.forEach(function(optionText) {
                let option = document.createElement("option");
                option.value = optionText;
                option.text = optionText;
                keyword.appendChild(option);
            });
        } else {
        	keyword.style.display = "none";  // 필터 숨기기
        }
    }
</script>

<script type="text/javascript">
	window.onload = function() {
	    // 새로고침이 감지된 경우
	    if (sessionStorage.getItem("reloaded")) {
	
	        // URL에서 검색어 제거
	        window.history.replaceState({}, document.title, window.location.pathname);
	
	        // 새로고침 플래그 삭제
	        sessionStorage.removeItem("reloaded");
	    }
	};
	
	window.addEventListener("beforeunload", function() {
	    sessionStorage.setItem("reloaded", "true");
});

</script>
</body>
</html>