package com.food.searcher.service;

import java.util.List;

import com.food.searcher.domain.ItemVO;
import com.food.searcher.util.Pagination;

public interface ItemService {
   int createItem(ItemVO itemVO);
   
   List<ItemVO> getAllItem();
   List<ItemVO> getPagingAllItems(Pagination pagination);
   
   List<ItemVO> getItemByStatus(int itemStatus);
   List<ItemVO> getPagingStatusItems(Pagination pagination);
   
   ItemVO getItemById(int itemId);
   
   int updateItem(ItemVO itemVO);
   int deleteItem(int itemId);
   int getTotalCount(Pagination pagination);
   int getStatusTotalCount(Pagination pagination);
   
}
