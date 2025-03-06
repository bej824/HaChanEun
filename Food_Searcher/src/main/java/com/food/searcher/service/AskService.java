package com.food.searcher.service;

import java.util.List;

import com.food.searcher.domain.AskVO;

public interface AskService {
	int createAsk(AskVO askVO);
	List<AskVO> getAsk(int itemId);
	int updateAsk(AskVO askVO);
	int deleteAsk(int askId);
}
