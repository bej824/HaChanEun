package com.food.searcher.service;

import java.util.List;

import com.food.searcher.domain.CtgVO;

public interface CtgService {
	
	int createCtg(CtgVO ctvVO);
	
	List<CtgVO> selectCtg(String mainCtg, String subCtg);
	
	/**
	 * @param ctgVO
	 * @param others 기타 선택 시 true, 그 외 false
	 * @return
	 */
	int updateCtg(CtgVO ctgVO, boolean others);

}
