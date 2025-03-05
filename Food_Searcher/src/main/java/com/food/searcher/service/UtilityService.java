package com.food.searcher.service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.stereotype.Service;

@Service
public class UtilityService {
	
	/**
	 * @return 현재시간(yyyyMMddHHmmss)
	 */
	public String sysDate() {
		
		return LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
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
