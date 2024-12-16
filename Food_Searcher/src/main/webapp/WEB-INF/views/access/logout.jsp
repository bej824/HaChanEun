<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    // 세션 종료
    session.invalidate(); // 세션 종료

    // 홈 페이지로 리디렉션
    response.sendRedirect("home.jsp"); // home.jsp로 리디렉션
%>