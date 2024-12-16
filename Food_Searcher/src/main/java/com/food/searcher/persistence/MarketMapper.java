package com.food.searcher.persistence;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.food.searcher.domain.MarketVO;
import com.food.searcher.util.Pagination;

@Mapper

public interface MarketMapper {
	int insert(MarketVO marketVO);		 // 관리자
	List<MarketVO> selectList();         // 전체 게시글
	MarketVO selectOne(int marketId); 	 // 특정 게시글 조회
	int update (MarketVO marketVO); 	 // 관리자
	int delete (int marketId);           // 관리자
	List<MarketVO> selectListByPagination(Pagination pagination); 
	int selectTotalCount();
	// int updateReplyCount(@Param("marketId") int MarketId, @Param("amount") int amount); REPLY_COUNT 컬럼이 없어서 보류
		
}
