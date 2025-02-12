package com.food.searcher.service;

import java.util.List;

import com.food.searcher.domain.DiscountCouponVO;

public interface DiscountCouponService {
	
	int createCoupon(DiscountCouponVO couponListVO);
	
	List<DiscountCouponVO> selectAllCoupon();

}
