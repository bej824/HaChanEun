package com.food.searcher.util;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;

import com.food.searcher.domain.EmailAuthVO;

public class EmailAuthUtil {
	
	@Autowired
	EmailAuthVO emailAuthVO;
	
	private Map<String, Integer> map = new HashMap<String, Integer>();
	
	public int insertAuth(String email, int checkNum) {
		int result = 0;
		
		map.put(email, checkNum);
		
		return result;
	}
	
	public int checkAuth(String email, int checkNum) {
		int result = 0;
		
		map.get(email);
		
		return result;
		
	}

}
