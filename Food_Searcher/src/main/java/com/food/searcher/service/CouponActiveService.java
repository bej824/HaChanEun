package com.food.searcher.service;

import java.util.List;

import com.food.searcher.domain.CouponActiveVO;
import com.food.searcher.domain.DiscountCouponVO;

public interface CouponActiveService {
	
	int createCouponActive(CouponActiveVO couponActiveVO);
	
	CouponActiveVO selectOneCoupon(CouponActiveVO couponActiveVO);
	
	List<CouponActiveVO> selectCouponActive(String memberId, int itemId);
	
	int updateCouponActiveByCouponActiveId(String memberId, int couponActiveId, int couponId);
	
	

}
