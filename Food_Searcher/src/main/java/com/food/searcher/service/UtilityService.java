package com.food.searcher.service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import org.springframework.stereotype.Service;

@Service
public class UtilityService {
	
	/**
	 * @return 현재시간(yyyyMMddHHmmss)
	 */
	public String sysDate() {
		
		return LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
	}

}
