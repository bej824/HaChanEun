package com.food.searcher.util;

import java.util.HashMap;
import java.util.Map;
import java.util.Random;

import org.springframework.scheduling.annotation.Scheduled;

import lombok.extern.log4j.Log4j;

@Log4j
public class RandomUtil {
	
	private Map<String, String> todayMBTI = new HashMap<String, String>();
	
	@Scheduled(cron = "0 58 23 * * *")
	public void randomMBTI() {
		
		Random random = new Random(16);
		String[] MBTI = {
				"ISFJ", "ISTJ", "INFJ", "INTJ", "ISTP", "ISFP", "INFP", "INTP",
				"ESTP", "ESFP", "ENFP", "ENTP", "ESTJ", "ESFJ", "ENFJ", "ENTJ"
				};
		int randomIndex = random.nextInt(MBTI.length);
		
		todayMBTI.put("todayMBTI", MBTI[randomIndex]);
	}
	
	public String getTodayMBTI() {
		
		return todayMBTI.get("todayMBTI");
	}
	
	

}
