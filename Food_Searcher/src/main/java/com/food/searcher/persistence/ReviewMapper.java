package com.food.searcher.persistence;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.food.searcher.domain.ReviewVO;

@Mapper
public interface ReviewMapper {
	int insert(ReviewVO reviewVO);
	List<ReviewVO> selectAll(long itemId);
	ReviewVO selectOne(@Param("itemId") long itemId, @Param("memberId") String memberId);
	List<ReviewVO> isExist(@Param("itemId") long itemId, @Param("memberId") String memberId);
	int update(ReviewVO reviewVO);
	int delete(long reviewId);
	
}
