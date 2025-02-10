package com.food.searcher.service;

import java.util.List;

import com.food.searcher.domain.ItemVO;

public interface ItemService {
	int createItem(ItemVO itemVO);
	List<ItemVO> getAllItem();
	ItemVO getItemById(int itemId);
	int updateItem(ItemVO itemVO);
	int deleteItem(int itemId);
	
}
