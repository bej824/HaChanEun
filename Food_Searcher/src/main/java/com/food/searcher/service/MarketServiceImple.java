package com.food.searcher.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.food.searcher.domain.MarketVO;
import com.food.searcher.persistence.MarketMapper;
import com.food.searcher.util.Pagination;

import lombok.extern.log4j.Log4j;

@Service
@Log4j

public class MarketServiceImple implements MarketService {

	@Autowired
	MarketMapper marketMapper;

	@Override
	public int createMarket(MarketVO marketVO) {
		log.info("createMarket()");
		int result = marketMapper.insert(marketVO);
		return result;
	}

	@Override
	public List<MarketVO> getAllMarket() {
		log.info("getAllMarket()");
		return marketMapper.selectList();
	}

	@Override
	public MarketVO getMarketById(int marketId) {
		log.info("getMarketById()");
		return marketMapper.selectOne(marketId);
	}

	@Override
	public int updateMarket(MarketVO marketVO) {
		log.info("updateMarket()");
		return marketMapper.update(marketVO);
	}

	@Override
	public int deleteMarket(int marketId) {
		log.info("deleteMarket()");
		return marketMapper.delete(marketId);
	}

	@Override
	public List<MarketVO> getPagingMarkets(Pagination pagination) {
		log.info("getPagingMarkets()");
		return marketMapper.selectListByPagination(pagination);
	}

	@Override
	public int getTotalCount() {
		log.info("getTotalCount()");
		return marketMapper.selectTotalCount();
	}
	

}
