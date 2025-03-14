package com.food.searcher.task;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.food.searcher.persistence.RecipeViewMapper;
import com.food.searcher.service.CtgViewsCountService;

import lombok.extern.log4j.Log4j;

@Component
@Log4j
public class ViewsTask {
	
	@Autowired
	private RecipeViewMapper recipeViewMapper;
	
	@Autowired
	private CtgViewsCountService ctgViewsCountService;
	
	@Scheduled(cron = "0 0 0 * * *") // 자정에 실행
	public void viewsCount() {
		log.info("조회수 확인");
		
		recipeViewMapper.updateViews();
		recipeViewMapper.insertViews();
		recipeViewMapper.updateCategoryViews();
		recipeViewMapper.insertCategoryViews();
		recipeViewMapper.delete();
		
		ctgViewsCountService.updateCtgViewCount();
	}
}
