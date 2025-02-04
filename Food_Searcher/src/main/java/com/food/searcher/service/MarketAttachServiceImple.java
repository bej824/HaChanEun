package com.food.searcher.service;


import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.food.searcher.domain.MarketAttachVO;
import com.food.searcher.persistence.MarketAttachMapper;

import lombok.extern.log4j.Log4j;
@Service
@Log4j
public class MarketAttachServiceImple implements MarketAttachService {
	
	@Autowired
    private MarketAttachMapper mapper;

	@Override
	public int createAttach(MarketAttachVO attachVO) {
		int result = mapper.insert(attachVO);
		return result;
	}

	@Override
	public List<MarketAttachVO> getAllAttach(int marketId) {
		log.info("getAllAttach()");
		List<MarketAttachVO> list = mapper.selectByMarketId(marketId);
		log.info(list);
		
		return list.stream().collect(Collectors.toList());
	}

	@Override
	public MarketAttachVO getAttachById(int attachId) {
		log.info("getMarketById()");
		log.info("attachId : " + attachId);
		MarketAttachVO attachVO = mapper.selectByAttachId(attachId);
		
		return attachVO;
	}

	@Override
	public int updateAttach(MarketAttachVO attachVO) {
		log.info("updateAttach()");
		return mapper.insertModify(attachVO);
	}

	@Override
	public int deleteAttach(int attachId) {
		log.info("deleteMarket()");
		
		return mapper.delete(attachId);
	}

	
	
	
}
