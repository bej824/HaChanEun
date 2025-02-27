package com.food.searcher.persistence;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.food.searcher.domain.ItemVO;
import com.food.searcher.util.Pagination;

@Mapper
public interface ItemMapper {
	int insert(ItemVO itemVO);
	
	List<ItemVO> selectAll();
	List<ItemVO> selectAllByPagination(Pagination pagination); // 전체 게시글 페이징 처리
	
	List<ItemVO> selectStatus(int itemStatus);
	List<ItemVO> selectStatusByPagination(Pagination pagination);
	
	ItemVO selectOne(int itemId);
	
	int update(ItemVO itemVO);
	int delete(int itemId);
	
	int selectTotalCountByStatus(Pagination pagination);
	int selectTotalCount(Pagination pagination);
	int itemAmount(@Param("itemAmount") int itemAmount, @Param("itemId") int itemId);
}
