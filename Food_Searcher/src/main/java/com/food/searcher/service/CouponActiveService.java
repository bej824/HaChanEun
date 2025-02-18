package com.food.searcher.service;

import com.food.searcher.domain.CouponActiveVO;
import com.food.searcher.domain.DiscountCouponVO;

public interface CouponActiveService {
	
	int createCouponActive(CouponActiveVO couponActiveVO);
	
	CouponActiveVO selectOneCoupon(CouponActiveVO couponActiveVO);

}
