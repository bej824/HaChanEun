package com.food.searcher.task;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.food.searcher.domain.CtgVO;
import com.food.searcher.persistence.RecipeViewMapper;
import com.food.searcher.service.CtgViewsCountService;
import com.food.searcher.service.LocalService;
import com.food.searcher.service.UtilityService;

import lombok.extern.log4j.Log4j;

@Component
@Log4j
public class ViewsTask {
	
	@Autowired
	private RecipeViewMapper recipeViewMapper;
	
	@Autowired
	private LocalService localService;
	
	@Autowired
	private CtgViewsCountService ctgViewsCountService;
	
	@Autowired
	private UtilityService utilityService;
	
	@Scheduled(cron = "0 0 12 * * *") // 자정에 실행
	public void viewsCount() {
		log.info("조회수 확인");
		String memberId = utilityService.loginMember();
		
		recipeViewMapper.updateViews();
		recipeViewMapper.insertViews();
		recipeViewMapper.updateCategoryViews();
		recipeViewMapper.insertCategoryViews();
		recipeViewMapper.delete();
		
		if(memberId != null) {
			List<CtgVO> list = localService.getViews();
			for(int i = 0; i < list.size(); i++) {
				String mainCtg = list.get(i).getMainCtg();
				ctgViewsCountService.countCtgViewCount(memberId, mainCtg);
			}
		}
	}
}
