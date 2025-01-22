<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<style>

#boardArea {
	width: 150px;
    height: 500px;
    font-size: 20px;
    font-family: "나눔고딕";
    line-height: 2.1;
    border-radius: 8px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    border: 1px solid #dcdcdc;
    text-decoration: none;
 	float: left;
 	box-sizing: border-box;
 	margin-right: 100px;
	margin-left: 100px;
}

#list a {
	font-size:16px;
	text-decoration: none;
}

#list a:hover{
	font-size:20px;
	font-weight:bold;
}


</style>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<div id="boardArea">
	<div id="list">
        <ul>
            <li><a href="/searcher/recipe/list"> 레시피 공유</a></li>
            <li><a href="/searcher/market/list"> 전통시장</a></li>
            <li><a href="/searcher/local/map"> 특산품</a></li>
        </ul>
    </div>
</div>
</body>
</html>