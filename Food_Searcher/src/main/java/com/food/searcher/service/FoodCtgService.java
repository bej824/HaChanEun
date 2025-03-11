package com.food.searcher.service;

import java.util.List;

import com.food.searcher.domain.CtgVO;

public interface FoodCtgService {
	
	int createCtg(CtgVO foodCtvVO);
	
	List<CtgVO> selectCtg(String mainCtg);

}
