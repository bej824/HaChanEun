package com.food.searcher.service;

import java.util.List;

import com.food.searcher.domain.DiscountCouponVO;

public interface DiscountCouponService {
	
	int createCoupon(DiscountCouponVO couponListVO);
	
	List<DiscountCouponVO> selectCoupon(String searchBy, String searchText);
	
	DiscountCouponVO selectOneCoupon(int couponId);
	
	int updateCoupon(DiscountCouponVO discountCouponVO);

	int deleteCoupon(int couponId);

}
