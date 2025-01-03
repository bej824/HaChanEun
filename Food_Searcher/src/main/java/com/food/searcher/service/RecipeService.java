package com.food.searcher.service;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.food.searcher.domain.RecipeVO;
import com.food.searcher.util.Pagination;

public interface RecipeService {
	int createBoard(RecipeVO recipeVO);
	List<RecipeVO> getAllBoards();
	RecipeVO getBoardById(int recipeId);
	List<RecipeVO> getselectSearch(String recipeTitle);
	List<RecipeVO> getSelectId(String memberId);
	List<RecipeVO> getSelectContent(String recipeContent);
	List<RecipeVO> getSelectFood(String recipeFood);
	int updateBoard(RecipeVO recipeVO);
	int deleteBoard(int recipeId);
	List<RecipeVO> getPagingBoards(Pagination pagination);
	List<RecipeVO> getTitleByPagination(Pagination pagination, String recipeTitle);
	int getTotalCount(@Param("recipeTitle") String recipeTitle, @Param("filterBy") String filterBy);
	int getTitleTotalCount(String recipeTitle);
	List<RecipeVO> getPagingBoards(String recipeTitle, String filterBy, Pagination pagination);
}
