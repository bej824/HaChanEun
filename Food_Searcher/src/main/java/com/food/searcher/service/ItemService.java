package com.food.searcher.service;

import java.util.List;

import com.food.searcher.domain.CtgVO;
import com.food.searcher.domain.DirectOrderVO;
import com.food.searcher.domain.ItemAttachVO;
import com.food.searcher.domain.ItemVO;
import com.food.searcher.util.Pagination;

public interface ItemService {
   int createItem(ItemVO itemVO);
   
   List<ItemVO> getPagingAllItems(Pagination pagination);
   List<ItemVO> getPagingStatusItems(Pagination pagination);
   List<ItemVO> selectSellerItem(String memberId, Pagination pagination);
   List<ItemVO> getSelectCategoryList(String mainCtg, int itemId, Pagination pagination);
   List<ItemVO> selectAllList();
   
   int getTotalCount(Pagination pagination);
   int getStatusTotalCount(Pagination pagination);
   int getSellerTotalCount(String memberId); 
   
   ItemVO getItemById(int itemId);
   List<CtgVO> mainCtgList();
   
   int updateItem(ItemVO itemVO);
   int updateItemStatus(int itemId, int itemStatus);
   int updateItemAmount(int itemId, int itemAmount);
   int returnItemAmount(List<DirectOrderVO> orderList);
   
   int deleteItem(int itemId);
   
   List<ItemAttachVO> attachAll();
   List<ItemAttachVO> attachById(int itemId);
}
