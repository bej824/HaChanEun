package com.food.searcher.task;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.food.searcher.service.CtgViewsCountService;
import com.food.searcher.service.RecipeViewService;

import lombok.extern.log4j.Log4j;

@Component
@Log4j
public class ViewsTask {
	
	@Autowired
	private RecipeViewService recipeViewService;
	
	@Autowired
	private CtgViewsCountService ctgViewsCountService;
	
	@Scheduled(cron = "0 0 0 * * *") // 자정에 실행
	public void viewsCount() {
		
		recipeViewService.RecipeViewCount();
		
		ctgViewsCountService.updateCtgViewCount();
	}
}
