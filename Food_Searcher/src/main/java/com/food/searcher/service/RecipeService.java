package com.food.searcher.service;

import java.util.List;

import com.food.searcher.domain.RecipeVO;
import com.food.searcher.util.Pagination;

public interface RecipeService {
	int createBoard(RecipeVO recipeVO);
	List<RecipeVO> getAllBoards();
	RecipeVO getBoardById(int recipeId);
	int updateBoard(RecipeVO recipeVO);
	int deleteBoard(int recipeId);
	List<RecipeVO> getPagingBoards(Pagination pagination);
	int getTotalCount();
}
