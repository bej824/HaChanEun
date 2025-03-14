package com.food.searcher.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.food.searcher.domain.CtgVO;
import com.food.searcher.persistence.CtgViewCountMapper;

import lombok.extern.log4j.Log4j;

@Service
@Log4j
public class CtgViewsCountServiceImple implements CtgViewsCountService {
	
	@Autowired
	CtgViewCountMapper ctgViewsCountMapper;
	
	@Autowired
	LocalService localService;
	
	@Override
	public CtgVO selectCtgViewCount(String memberId, String mainCtg) {
		
		return ctgViewsCountMapper.selectCtgViewCount(memberId, mainCtg);
	}
	
	@Transactional
	@Override
	public int updateCtgViewCount() {
		
		ctgViewsCountMapper.updateCtgViewCount();
		int result = localService.deleteView();
		
		return result;
	}

}
