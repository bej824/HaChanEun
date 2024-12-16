<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>전통시장 리스트</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f9f9f9;
        }
        .container {
            width: 80%;
            margin: 30px auto;
            background: #fff;
            border: 1px solid #ddd;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }
        h1 {
            text-align: center;
            background: #0066cc;
            color: white;
            margin: 0;
            padding: 20px 0;
            border-top-left-radius: 8px;
            border-top-right-radius: 8px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
        }
        th, td {
            padding: 10px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background-color: #f2f2f2;
        }
        tr:hover {
            background-color: #f5f5f5;
        }
        .button {
            display: inline-block;
            padding: 10px 20px;
            background-color: #0066cc;
            color: #fff;
            text-decoration: none;
            border-radius: 5px;
            transition: background-color 0.3s;
        }
        .button:hover {
            background-color: #004a99;
        }
        .footer {
            text-align: center;
            padding: 15px;
            background: #f2f2f2;
            border-top: 1px solid #ddd;
        }
    </style>
</head>
<body>
	<!-- 게시판 -->
    <div class="container">
        <h1>전통시장 리스트</h1>
        <table>
            <thead>
                <tr>
                    <th>번호</th>
                    <th>시장 이름</th>
                    <th>위치</th>
                    <th>운영 시간</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="market" items="${MarketList }">
                    <tr>
                 	<td>${MarketVO.marketId }</td>
					<td><a href="detail?MarketId=${MarketVO.marketId }">
					${MarketVO.marketTitle }</a></td>
					<td>${BoardVO.memberId }</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        
        	<ul>
		<!-- 이전 버튼 생성을 위한 조건문 -->
		<c:if test="${pageMaker.isPrev() }">
			<li><a href="list?pageNum=${pageMaker.startNum - 1}">이전</a></li>
		</c:if>
		<!-- 반복문으로 시작 번호부터 끝 번호까지 생성 -->
		<c:forEach begin="${pageMaker.startNum }"
			end="${pageMaker.endNum }" var="num">
			<li><a href="list?pageNum=${num }">${num }</a></li>
		</c:forEach>
		<!-- 다음 버튼 생성을 위한 조건문 -->
		<c:if test="${pageMaker.isNext() }">
			<li><a href="list?pageNum=${pageMaker.endNum + 1}">다음</a></li>
		</c:if>
	</ul>
        
        
        <div class="footer">
            <a href="register" class="button">시장 추가하기</a>
        </div>
    </div>
</body>
</html>
