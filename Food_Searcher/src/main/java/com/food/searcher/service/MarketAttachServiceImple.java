package com.food.searcher.service;

import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.log;

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
	public MarketAttachVO getAttachById(int attachId) {
		log.info("getAttachById()");
		return getAttachById(attachId);
        }

}
