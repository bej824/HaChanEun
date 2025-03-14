package com.food.searcher.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import com.food.searcher.domain.CtgVO;
import com.food.searcher.persistence.CtgMapper;

public class CtgServiceImple implements CtgService {
	
	@Autowired
	CtgMapper CtgMapper;
	
	@Override
	public int createCtg(CtgVO foodCtgVO) {
		
		return CtgMapper.insertCtg(foodCtgVO);
	}
	
	@Override
	public List<CtgVO> selectCtg(String mainCtg) {
		
		return CtgMapper.selectCtg(mainCtg);			
	}

}
