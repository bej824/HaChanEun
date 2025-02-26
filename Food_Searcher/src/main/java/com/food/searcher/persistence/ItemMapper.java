package com.food.searcher.persistence;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.food.searcher.domain.ItemVO;
import com.food.searcher.util.Pagination;

@Mapper
public interface ItemMapper {
	
	int insert(ItemVO itemVO);
	List<ItemVO> selectList(int itemStatus);
	List<ItemVO> selectListAll();
	List<ItemVO> selectListByPagination(Pagination pagination);
	ItemVO selectOne(int itemId);
	int update(ItemVO itemVO);
	int delete(int itemId);
	int selectTotalCount(Pagination pagination);
	int itemAmount(@Param("itemAmount") int itemAmount, @Param("itemId") int itemId);
}
