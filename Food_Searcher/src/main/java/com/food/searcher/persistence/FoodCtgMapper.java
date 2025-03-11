package com.food.searcher.persistence;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.food.searcher.domain.CtgVO;

@Mapper
public interface FoodCtgMapper {
	
	int insertFoodCtg(CtgVO foodctgVO);
	
	List<CtgVO> selectFoodCtg(
			 @Param("mainCtg") String mainCtg);
	
	int updateFoodCtg(CtgVO foodctgVO);

}
