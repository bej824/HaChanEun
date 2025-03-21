package com.food.searcher.service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.stereotype.Service;

import lombok.extern.log4j.Log4j;

@Log4j
@Service
public class UtilityService {

	public String now() {
		
		return LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
	}
	
	public String loginMember() {
		
		return "anonymousUser".equals(SecurityContextHolder.getContext().getAuthentication().getName()) 
				? null : SecurityContextHolder.getContext().getAuthentication().getName();
	}
	
	public String checkRoleSeller() {
	    return checkRole("ROLE_SELLER");
	}

	public String checkRoleAdmin() {
	    return checkRole("ROLE_ADMIN");
	}
	
	public String checkRole(String role) {
	    Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
	    
	    if (authentication != null) {
	        // 현재 로그인한 사용자 정보
	        User user = (User) authentication.getPrincipal();
	        
	        if(user.getAuthorities().stream()
	                   .anyMatch(authority -> authority.getAuthority().equals(role))) {
	        	return authentication.getName();
	        }
	    }
	    
	    return null;
	}

}
