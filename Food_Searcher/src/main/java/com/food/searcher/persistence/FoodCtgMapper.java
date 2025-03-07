package com.food.searcher.persistence;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.food.searcher.domain.FoodCtgVO;

@Mapper
public interface FoodCtgMapper {
	
	int insertFoodCtg(FoodCtgVO foodctgVO);
	
	List<FoodCtgVO> selectFoodCtg(
			 @Param("mainCtg") String mainCtg
			,@Param("subCtg") String subCtg);
	
	int updateFoodCtg(FoodCtgVO foodctgVO);

}
