package com.food.searcher.persistence;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.food.searcher.domain.ItemVO;

@Mapper
public interface ItemMapper {
	
	int insert(ItemVO itemVO);
	List<ItemVO> selectList();
	ItemVO selectOne(int itemId);
	int update(ItemVO itemVO);
	int delete(int itemId);

}
