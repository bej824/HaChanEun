package com.food.searcher.service;

import java.util.List;

import com.food.searcher.domain.FoodCtgVO;

public interface FoodCtgService {
	
	int createCtg(FoodCtgVO foodCtvVO);
	
	List<FoodCtgVO> selectCtg(String mainCtg, String subCtg);
	
	/**
	 * @param ctgVO
	 * @param others 기타 선택 시 true, 그 외 false
	 * @return
	 */
	int updateCtg(FoodCtgVO foodCtgVO, boolean others);

}
