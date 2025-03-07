package com.food.searcher.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;

import com.food.searcher.domain.AnswerVO;
import com.food.searcher.persistence.AnswerMapper;

import lombok.extern.log4j.Log4j;

@Repository
@Service
@Log4j
public class AnswerServiceImple implements AnswerService {

	@Autowired
	AnswerMapper answerMapper;
	
	@Override
	public int createAnswer(AnswerVO answerVO) {
		log.info("createAnswer()");
		return answerMapper.insert(answerVO);
	}

	@Override
	public List<AnswerVO> getAnswer(long askId) {
		log.info("getAnswer()");
		List<AnswerVO> answerVO = answerMapper.select(askId);
		return answerVO;
	}

	@Override
	public int updateAnswer(long answerId, String answerContent) {
		log.info("updateAnswer()");
		AnswerVO answerVO = new AnswerVO();
		answerVO.setAnswerContent(answerContent);
		answerVO.setAnswerId(answerId);
		
		return answerMapper.update(answerVO);
	}

	@Override
	public int deleteAnswer(long answerId) {
		log.info("deleteAnswer()");
		return answerMapper.delete(answerId);
	}

}
