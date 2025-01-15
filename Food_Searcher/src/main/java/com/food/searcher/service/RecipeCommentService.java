package com.food.searcher.service;

import java.util.List;

import com.food.searcher.domain.RecipeCommentVO;

public interface RecipeCommentService {
	int createComment(RecipeCommentVO recipeCommentVO);
	List<RecipeCommentVO> getAllComment(int replyId);
	int updateComment(int recipeCommentId, String commentContent);
	int deleteComment(int recipeCommentId, int replyId);
}
