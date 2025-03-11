package com.food.searcher.persistence;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.food.searcher.domain.AskVO;

@Mapper
public interface AskMapper {
	List<AskVO> select(long itemId);
	int insert(AskVO askVO);
	int update(AskVO askVO);
	int delete(long askId);
	int countTodayAsk(AskVO askVO);
}
