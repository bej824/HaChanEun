package com.food.searcher.service;

import java.util.List;

import com.food.searcher.domain.AnswerVO;

public interface AnswerService {
	int createAnswer(AnswerVO answerVO);
	List<AnswerVO> getAnswer(long askId);
	int updateAnswer(long answerId, String answerContent);
	int deleteAnswer(long answerId);
}
