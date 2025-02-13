package com.food.searcher.persistence;

import java.util.List;

import com.food.searcher.domain.RecipeCommentVO;

public interface RecipeCommentMapper {
	List<RecipeCommentVO> selectListByBoardId(int replyId);
	RecipeCommentVO selectOne(int recipeCommentId);
	int insert(RecipeCommentVO recipeCommentVO);
	int update(RecipeCommentVO replyVO);
	int delete(int recipeCommentId);
}
