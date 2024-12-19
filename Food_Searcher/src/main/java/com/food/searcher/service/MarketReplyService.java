package com.food.searcher.service;

import java.util.List;

import com.food.searcher.domain.MarketReplyVO;

public interface MarketReplyService {
	int createReply(MarketReplyVO marketReplyVO);
	List<MarketReplyVO> getAllReply(int marketId);
	int updateReply(int marketReplyId, String marketReplyContent);
	int deleteReply(int marketReplyId, int marketId);
	MarketReplyVO getReplyById(int marketReplyId);
}
