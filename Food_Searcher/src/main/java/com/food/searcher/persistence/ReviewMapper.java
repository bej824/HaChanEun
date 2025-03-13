package com.food.searcher.persistence;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.food.searcher.domain.ReviewVO;

@Mapper
public interface ReviewMapper {
	int insert(ReviewVO reviewVO);
	List<ReviewVO> selectAll(long itemId);
	ReviewVO selectOne(long itemId);
	int update(ReviewVO reviewVO);
	int delete(long reviewId);
	
}
