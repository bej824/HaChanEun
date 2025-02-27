package com.food.searcher.service;

import java.util.List;

import com.food.searcher.domain.DirectOrderVO;
import com.food.searcher.domain.DiscountCouponVO;
import com.food.searcher.domain.ItemVO;

public interface SellerService {
	
	int SellerCreate(String memberId);
	
	List<DiscountCouponVO> selectSellerCoupon();
	
	List<DirectOrderVO> purchaseHistory(String memberId);
	
	DirectOrderVO purchaseInfo(String orderId);
	
	ItemVO purchaseItemInfo(String orderId);

}
