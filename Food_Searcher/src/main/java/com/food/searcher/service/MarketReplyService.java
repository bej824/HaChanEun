package com.food.searcher.service;

import java.util.List;

import com.food.searcher.domain.MarketReplyVO;
import com.food.searcher.domain.RecipeReplyVO;

public interface MarketReplyService {
	int createReply(MarketReplyVO marketReplyVO);
	List<MarketReplyVO> getAllReply(int marketId);
	MarketReplyVO getReplyById(int marketReplyId);
	int updateReply(int marketReplyId, String marketReplyContent);
	int deleteReply(int marketReplyId, int marketId);
	int deleteReplyByMarket(int marketId);
}
