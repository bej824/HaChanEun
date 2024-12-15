package com.food.searcher.persistence;

import java.util.List;

import com.food.searcher.domain.RecipeCommentVO;


public interface RecipeCommentMapper {
	int insert(RecipeCommentVO recipeCommentVO);
	List<RecipeCommentVO> selectListByBoardId(int replyId);
	RecipeCommentVO selectOne(int recipeCommentId);
	int update(RecipeCommentVO replyVO);
	int delete(int recipeCommentId);
}
