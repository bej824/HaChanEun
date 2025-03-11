package com.food.searcher.service;

import java.util.List;

import com.food.searcher.domain.AskVO;

public interface AskService {
	int createAsk(AskVO askVO);
	List<AskVO> getAsk(long itemId);
	int updateAsk(long askId, String askContent);
	int deleteAsk(long askId);
	boolean canWriteAsk(String memberId, long itemId);
}
