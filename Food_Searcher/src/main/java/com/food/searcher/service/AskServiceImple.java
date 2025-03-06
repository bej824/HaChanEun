package com.food.searcher.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;

import com.food.searcher.domain.AskVO;
import com.food.searcher.persistence.AskMapper;

import lombok.extern.log4j.Log4j;

@Repository
@Service
@Log4j
public class AskServiceImple implements AskService {
	
	@Autowired
	AskMapper askMapper;
	
	@Override
	public int createAsk(AskVO askVO) {
		return askMapper.insert(askVO);
	}
	
	@Override
	public List<AskVO> getAsk(int itemId) {
		List<AskVO> askVO = askMapper.select(itemId);
		return askVO;
	}

	@Override
	public int updateAsk(AskVO askVO) {
		return askMapper.update(askVO);
	}

	@Override
	public int deleteAsk(int askId) {
		return askMapper.delete(askId);
	}

	
	
}
