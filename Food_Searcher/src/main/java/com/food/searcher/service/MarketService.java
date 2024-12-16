package com.food.searcher.service;

import java.util.List;

import com.food.searcher.domain.MarketVO;
import com.food.searcher.util.Pagination;

public interface MarketService {
	int createMarket(MarketVO marketVO);
	List<MarketVO> getAllMarket();
	MarketVO getMarketById(int marketId);
	int updateMarket(MarketVO marketVO);
	int deleteMarket(int marketId);
	List<MarketVO> getPagingMarkets(Pagination pagination);
	int getTotalCount();
	
}
