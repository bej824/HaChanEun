package com.food.searcher.service;

import java.util.List;

import com.food.searcher.domain.MarketAttachVO;

public interface MarketAttachService {
	
	int createAttach(MarketAttachVO attachVO);
	List<MarketAttachVO> getAllAttach(int marketId);
	MarketAttachVO getAttachById(int attachId);
	int updateAttach(MarketAttachVO attachVO);
	int deleteAttach(int attachId);
	
}
