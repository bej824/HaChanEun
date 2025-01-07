package com.food.searcher.util;

import java.util.HashMap;
import java.util.Map;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import lombok.extern.log4j.Log4j;

@Log4j
public class EmailAuthUtil {
	
	private Map<String, Integer> map = new HashMap<String, Integer>();
	
	public int insertAuth(String email, int checkNum) {
		int result = 0;
		try {
			map.put(email, checkNum);
			result = 1;
		} catch (Exception e) {
			
		}
		
		return result;
	}
	
	public int checkAuth(String email, int emailCheck) {
		int result = 0;
		if(map.containsKey(email) && emailCheck == map.get(email)) {
			result = 1;
		}
		
		return result;
		
	}

}
