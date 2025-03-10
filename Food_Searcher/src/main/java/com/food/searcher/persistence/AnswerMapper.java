package com.food.searcher.persistence;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.food.searcher.domain.AnswerVO;

@Mapper
public interface AnswerMapper {
	int insert(AnswerVO answerVO);
	List<AnswerVO> select(long askId);
	int update(AnswerVO answerVO);
	int delete(long answerId);
}
