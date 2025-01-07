<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비밀번호 찾기</title>
</head>
<body>
	<jsp:include page="../header.jsp" />
	<h1>비밀번호 찾기</h1>
	
	<c:if test="${request.method == 'GET'}">
        <jsp:include page="emailAuthHeader.jsp" />
    </c:if>

    <c:if test="${request.method == 'POST'}">
        <jsp:include page="pwUpdateHeader.jsp" />
    </c:if>
	
	<script type="text/javascript">
	
	</script>

</body>
</html>