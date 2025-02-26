package com.food.searcher.service;

import java.util.List;

import com.food.searcher.domain.CouponActiveVO;
import com.food.searcher.domain.DiscountCouponVO;

public interface CouponActiveService {
	
	int createCouponActive(CouponActiveVO couponActiveVO);
	
	List<CouponActiveVO> selectCouponActive(String memberId, int itemId);
	
	int updateCouponActiveByCouponActiveId(CouponActiveVO couponActiveVO);
	
	int updateCouponActiveByOrderId(String orderId);
	
	CouponActiveVO setCouponInfo(CouponActiveVO couponActiveVO);
	
	

}
