package com.food.searcher.persistence;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.food.searcher.domain.MarketCommentVO;


@Mapper

public interface MarketCommentMapper {
	
	int insert(MarketCommentVO marketCommentVO);
	List<MarketCommentVO> selectListByMarketReplyId(int marketReplyId);
	int update(MarketCommentVO marketCommentVO);
	int delete(int marketCommentId);
	
	
}
