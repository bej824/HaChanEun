package com.food.searcher.service;

import org.apache.ibatis.annotations.Param;

import com.food.searcher.domain.CtgVO;

public interface CtgViewsCountService {
	
	int countCtgViewCount(String memberId, String mainCtg);
	
	CtgVO selectCtgViewCount(String memberId, String mainCtg);

}
