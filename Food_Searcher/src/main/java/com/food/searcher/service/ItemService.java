package com.food.searcher.service;

import java.util.List;

import com.food.searcher.domain.ItemVO;
import com.food.searcher.util.Pagination;

public interface ItemService {
	int createItem(ItemVO itemVO);
	List<ItemVO> getAllItem(int itemStatus);
	List<ItemVO> getAllItem();
	List<ItemVO> getPagingItems(Pagination pagintaion);
	ItemVO getItemById(int itemId);
	int updateItem(ItemVO itemVO);
	int deleteItem(int itemId);
	int getTotalCount(Pagination pagination);
	
}
