package com.food.searcher.persistence;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.food.searcher.domain.MarketReplyVO;

@Mapper

public interface MarketReplyMapper {
	
	int insert(MarketReplyVO marketReplyVO);
	List<MarketReplyVO> selectListByMarketId(int marketId);
	int update(MarketReplyVO marketReplyVO);
	int delete(int marketReplyId);
	
}
