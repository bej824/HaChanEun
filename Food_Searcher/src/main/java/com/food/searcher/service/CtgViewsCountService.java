package com.food.searcher.service;

import com.food.searcher.domain.CtgVO;

public interface CtgViewsCountService {
	
	CtgVO selectCtgViewCount(String memberId, String mainCtg);
	
	int updateCtgViewCount();

}
