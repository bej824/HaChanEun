package com.food.searcher.persistence;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.food.searcher.domain.CtgVO;

@Mapper
public interface CtgViewCountMapper {
	
	int insertCtgViewCount(
			@Param("memberId") String memberId,
			@Param("mainCtg") String mainCtg);
	
	int countCtgViewCount(
			@Param("memberId") String memberId,
			@Param("mainCtg") String mainCtg);
	
	CtgVO selectCtgViewCount(
			@Param("memberId") String memberId,
			@Param("mainCtg") String mainCtg);
	
	int updateCtgViewCount();

}
