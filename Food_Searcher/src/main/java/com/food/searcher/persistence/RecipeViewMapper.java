package com.food.searcher.persistence;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.food.searcher.domain.RecipeViewListVO;
import com.food.searcher.domain.RecipeViewsVO;

@Mapper
public interface RecipeViewMapper {
	List<RecipeViewListVO> selectAll();
	RecipeViewsVO selectOne(int recipeId);
	int insert(Map<String, Object> params);
	int insertViews();
	int updateViews();
	int insertCategoryViews();
	int updateCategoryViews();
	int delete();
}
