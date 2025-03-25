<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>추천 음식</title>
</head>
<body>
<c:set var="found" value="false" />

<c:forEach var="recommend" items="${recommend }">
<c:if test="${recommend.memberId eq memberId }">
${recommend.food }  어떠신가요?
<c:set var="found" value="true" />
</c:if>
</c:forEach>

<c:if test="${not found}">
    ${random.recipeFood }(${random.category }) 어떠신가요?
</c:if>
</body>
</html>