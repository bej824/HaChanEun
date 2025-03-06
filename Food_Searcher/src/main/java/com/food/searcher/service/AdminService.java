package com.food.searcher.service;

import java.util.List;

import com.food.searcher.domain.CouponHistoryVO;
import com.food.searcher.domain.DirectOrderVO;
import com.food.searcher.domain.ItemVO;
import com.food.searcher.util.Pagination;

public interface AdminService {
	

	int createRole(String memberId, String RoleName);
	
	int totalCount(Pagination pagination);
	
	int getTotalCount(Pagination pagination);
	
	List<ItemVO> itemGetAll(Pagination pagination);
	
	ItemVO getItemById(int itemId);
	
	DirectOrderVO getselectOne(String orderId);
	
	int couponHistoryCount();
	
	List<CouponHistoryVO> couponHistoryGet(Pagination pagination);
	
	List<CouponHistoryVO> couponHistoryBySellerId(String SellerId);
	
	int updateItemStatus(int itemId, int itemStatus);
	
	List<DirectOrderVO> orderList(Pagination pagination);
	
}
