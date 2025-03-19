package com.food.searcher.service;

import java.util.List;

import com.food.searcher.domain.CtgVO;

public interface CtgService {
	
	int createCtg(CtgVO foodCtgVO);
	
	List<CtgVO> selectCtg(String url);

}
