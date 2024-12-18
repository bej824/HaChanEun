package com.food.searcher.service;

import java.util.List;

import com.food.searcher.domain.RecipeReplyVO;


public interface RecipeReplyService {
	int createReply(RecipeReplyVO replyVO);
	List<RecipeReplyVO> getAllReply(int boardId);
	RecipeReplyVO getReplyById(int replyId);
	int updateReply(int replyId, String replyContent);
	int deleteReply(int replyId, int boardId);
}
