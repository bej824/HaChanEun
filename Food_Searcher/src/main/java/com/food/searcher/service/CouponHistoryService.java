package com.food.searcher.service;

import java.util.List;

import com.food.searcher.domain.CouponHistoryVO;
import com.food.searcher.util.Pagination;

public interface CouponHistoryService {
	
	int createCouponHistory();
	
	int couponHistoryCount();
	
	List<CouponHistoryVO> couponHistoryGet(Pagination pagination);
	
	List<CouponHistoryVO> couponHistoryBySellerId(String SellerId);

}
