package com.food.searcher.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import com.food.searcher.domain.CtgVO;
import com.food.searcher.persistence.CtgMapper;

public class CtgServiceImple implements CtgService {
	
	@Autowired
	CtgMapper ctgMapper;
	
	@Override
	public int createCtg(CtgVO ctvVO) {
		
		return ctgMapper.insertCtg(ctvVO);
	}
	
	@Override
	public List<CtgVO> selectCtg(String mainCtg, String subCtg) {
		
		return ctgMapper.selectCtg(mainCtg, subCtg);			
	}
	
	@Override
	public int updateCtg(CtgVO ctgVO, boolean others) {
		
		if(others) {
			return createCtg(ctgVO);
		} else {
			return ctgMapper.updateCtg(ctgVO);
		}
	}

}
