package com.food.searcher.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.food.searcher.domain.CtgVO;
import com.food.searcher.persistence.CtgViewCountMapper;

import lombok.extern.log4j.Log4j;

@Service
@Log4j
public class CtgViewsCountServiceImple implements CtgViewsCountService {
	
	@Autowired
	CtgViewCountMapper ctgViewsCountMapper;
	
	@Override
	public int countCtgViewCount(String memberId, String mainCtg) {
		log.info("countCtgViewCount()");
		int result = ctgViewsCountMapper.countCtgViewCount(memberId, mainCtg);
		
		if(result == 0) {
			return createCtgViewCount(memberId, mainCtg);
		} else {
			return updateCtgViewCount(memberId, mainCtg);
		}
		
	}
	
	@Override
	public CtgVO selectCtgViewCount(String memberId, String mainCtg) {
		
		return ctgViewsCountMapper.selectCtgViewCount(memberId, mainCtg);
	}
	
	public int createCtgViewCount(String memberId, String mainCtg) {
		
		return ctgViewsCountMapper.insertCtgViewCount(memberId, mainCtg);
	}
	
	public int updateCtgViewCount(String memberId, String mainCtg) {
		
		return ctgViewsCountMapper.updateCtgViewCount(memberId, mainCtg);
	}

}
