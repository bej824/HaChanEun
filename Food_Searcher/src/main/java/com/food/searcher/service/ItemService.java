package com.food.searcher.service;

import java.util.List;

import com.food.searcher.domain.FoodCtgVO;
import com.food.searcher.domain.ItemVO;
import com.food.searcher.util.Pagination;

public interface ItemService {
   int createItem(ItemVO itemVO);
   
   List<ItemVO> getPagingAllItems(Pagination pagination);
   List<ItemVO> getPagingStatusItems(Pagination pagination);
   List<ItemVO> selectSellerItem(String memberId);
   List<ItemVO> getSelectCategoryList(String mainCtg, Pagination pagination);
   List<ItemVO> selectAllList();
   
   int getTotalCount(Pagination pagination);
   int getStatusTotalCount(Pagination pagination);
   
   ItemVO getItemById(int itemId);
   List<FoodCtgVO> mainCtgList();
   
   int updateItem(ItemVO itemVO);
   int updateItemStatus(int itemId, int itemStatus);
   int updateItemAmount(int itemId, int itemAmount);
   
   int deleteItem(int itemId);
   
}
