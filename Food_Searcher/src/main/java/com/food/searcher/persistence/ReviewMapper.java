package com.food.searcher.persistence;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.food.searcher.domain.ReviewVO;

@Mapper
public interface ReviewMapper {
	int insert(ReviewVO reviewVO);
	List<ReviewVO> selectAll(long itemId);
	ReviewVO selectOne(long itemId);
	int isEnabled(@Param("memberId") String memberId, @Param("itemId") long itemId);
	int update(ReviewVO reviewVO);
	int delete(long reviewId);
	
}
