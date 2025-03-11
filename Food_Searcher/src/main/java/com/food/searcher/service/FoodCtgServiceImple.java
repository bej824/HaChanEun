package com.food.searcher.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import com.food.searcher.domain.CtgVO;
import com.food.searcher.persistence.FoodCtgMapper;

public class FoodCtgServiceImple implements FoodCtgService {
	
	@Autowired
	FoodCtgMapper foodCtgMapper;
	
	@Override
	public int createCtg(CtgVO foodCtgVO) {
		
		return foodCtgMapper.insertFoodCtg(foodCtgVO);
	}
	
	@Override
	public List<CtgVO> selectCtg(String mainCtg) {
		
		return foodCtgMapper.selectFoodCtg(mainCtg);			
	}

}
