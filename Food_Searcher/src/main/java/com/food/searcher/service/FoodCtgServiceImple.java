package com.food.searcher.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import com.food.searcher.domain.FoodCtgVO;
import com.food.searcher.persistence.FoodCtgMapper;

public class FoodCtgServiceImple implements FoodCtgService {
	
	@Autowired
	FoodCtgMapper foodCtgMapper;
	
	@Override
	public int createCtg(FoodCtgVO foodCtgVO) {
		
		return foodCtgMapper.insertFoodCtg(foodCtgVO);
	}
	
	@Override
	public List<FoodCtgVO> selectCtg(String mainCtg, String subCtg) {
		
		return foodCtgMapper.selectFoodCtg(mainCtg, subCtg);			
	}
	
	@Override
	public int updateCtg(FoodCtgVO foodCtgVO, boolean others) {
		
		if(others) {
			return createCtg(foodCtgVO);
		} else {
			return foodCtgMapper.updateFoodCtg(foodCtgVO);
		}
	}

}
