package com.food.searcher.persistence;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.food.searcher.domain.RecipeViewListVO;

@Mapper
public interface RecipeViewMapper {
	int insert(RecipeViewListVO recipeViewList);
	List<RecipeViewListVO> selectAll();
}
