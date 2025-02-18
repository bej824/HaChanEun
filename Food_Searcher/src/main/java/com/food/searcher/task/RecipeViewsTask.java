package com.food.searcher.task;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.food.searcher.persistence.RecipeViewMapper;

import lombok.extern.log4j.Log4j;

@Component
@Log4j
public class RecipeViewsTask {
	
	@Autowired
	private RecipeViewMapper recipeViewMapper;
	
	@Scheduled(cron = "0 0 12 * * *") // 자정에 실행
	public void viewsCount() {
		log.info("조회수 확인");
		
		int updateCount = recipeViewMapper.updateViews();
		log.info(updateCount + "행 업데이트");
		int inputCount = recipeViewMapper.insertViews();
		log.info(inputCount + "행 추가");
		int deleteinfo = recipeViewMapper.delete();
		log.info(deleteinfo + "행 삭제");
	}
}
