package com.food.searcher.service;

import java.util.List;

import com.food.searcher.domain.MarketCommentVO;

public interface MarketCommentService {
	
	int createComment(MarketCommentVO marketCommentVO);
	List<MarketCommentVO> getAllComment(int marketReplyId);
	int updateComment(int marketCommentId, String commentContent);
	int deleteComment(int marketCommentId, int marketReplyId);

}
