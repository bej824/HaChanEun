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
		long askId = answerVO.getAskId();
		List<AnswerVO> list = answerMapper.select(askId);
		
		if(list.isEmpty()) {
			return answerMapper.insert(answerVO);
		} else {
			log.info("답변은 문의당 한 번만 작성 가능합니다.");
			return 0;
		}
		
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
