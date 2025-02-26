package com.food.searcher.service;

import java.util.List;

import com.food.searcher.domain.DirectOrderVO;
import com.food.searcher.domain.DiscountCouponVO;

public interface SellerService {
	
	int SellerCreate(String memberId);
	
	List<DiscountCouponVO> selectSellerCoupon();
	
	List<DirectOrderVO> purchaseHistory(String memberId);
	

}
