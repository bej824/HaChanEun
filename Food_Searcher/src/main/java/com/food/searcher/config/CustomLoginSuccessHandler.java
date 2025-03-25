package com.food.searcher.config;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

@Component
public class CustomLoginSuccessHandler implements AuthenticationSuccessHandler{

	@Override
	public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication) throws IOException, ServletException {
		System.out.println("Custom Login Success Handler triggered.");
		
		response.setContentType("text/html; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        
		response.setContentType("text/html");
        response.getWriter().println("<html><body>");
        response.getWriter().println("<script>");
        response.getWriter().println("let newWindow = window.open('/searcher/recipe/recommend', 'newWindow', 'width=400,height=300,resizable=yes,scrollbars=yes,left=750');");  // Open a new window with custom properties
        response.getWriter().println("newWindow.onunload = function() {");
        response.getWriter().println("    window.location.href = '/searcher/home';");  // Redirect back to the main page when the new window is closed
        response.getWriter().println("};");
//        response.getWriter().println("alert('로그인 성공!');");
//        response.getWriter().println("setTimeout(function(){ window.location.href = '/searcher/home'; }, 500);");
        response.getWriter().println("</script>");
        response.getWriter().println("</body></html>");
		
	}

}
