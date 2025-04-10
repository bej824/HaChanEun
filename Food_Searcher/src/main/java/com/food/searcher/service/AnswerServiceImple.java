package com.food.searcher.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.food.searcher.domain.AnswerVO;
import com.food.searcher.persistence.AnswerMapper;

import lombok.extern.log4j.Log4j;

@Repository
@Service
@Log4j
public class AnswerServiceImple implements AnswerService {

	@Autowired
	AnswerMapper answerMapper;
	
	@Transactional(value = "transactionManager")	
	@Override
	public int createAnswer(AnswerVO answerVO) {
		long askId = answerVO.getAskId();
		List<AnswerVO> list = answerMapper.select(askId);
		if(list.isEmpty()) {
			answerMapper.insert(answerVO);
			answerMapper.updateAnswerCount(askId);
			return 1;
		} else if (list.size() > 0) {
			return 2;
		} else {
			log.error("error");
			return 0;
		}
		
	}

	@Override
	public List<AnswerVO> getAnswer(long askId) {
		List<AnswerVO> answerVO = answerMapper.select(askId);
		return answerVO;
	}

	@Override
	public int updateAnswer(long answerId, String answerContent) {
		AnswerVO answerVO = new AnswerVO();
		answerVO.setAnswerContent(answerContent);
		answerVO.setAnswerId(answerId);
		
		return answerMapper.update(answerVO);
	}

	@Override
	public int deleteAnswer(long answerId) {
		return answerMapper.delete(answerId);
	}
	
}
