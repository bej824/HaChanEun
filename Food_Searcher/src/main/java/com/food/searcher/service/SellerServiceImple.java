package com.food.searcher.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.food.searcher.domain.DirectOrderVO;
import com.food.searcher.domain.DiscountCouponVO;
import com.food.searcher.domain.ItemVO;
import com.food.searcher.persistence.DirectOrderMapper;
import com.food.searcher.persistence.ItemMapper;

import lombok.extern.log4j.Log4j;

@Log4j
@Service
public class SellerServiceImple implements SellerService {
	
	@Autowired
	AdminService adminService;
	
	@Autowired
	DiscountCouponService discountCouponService;
	
	@Autowired
	DirectOrderService directOrderService;
	
	@Autowired
	private ItemService itemService;
	
	@Autowired
	ItemMapper itemMapper;
	
	@Override
	public int SellerCreate(String memberId) {
		log.info("SellerCreate()");
		String RoleName = "ROLE_SELLER";
		
		return adminService.createRole(memberId, RoleName);
	}
	
	@Override
	public List<DiscountCouponVO> selectSellerCoupon() {
		log.info("selectSellerCoupon()");
		
		return discountCouponService.selectCoupon("COUPON_ISSUER", "ROLE_SELLER");
	}
	
	@Override
	public List<DirectOrderVO> purchaseHistory(String memberId) {
		
		return directOrderService.sellerList(memberId);
	}

	@Override
	public DirectOrderVO purchaseInfo(String orderId) {
		return directOrderService.getselectOne(orderId);
	}

	@Override
	public ItemVO purchaseItemInfo(String orderId) {
		DirectOrderVO directOrderVO = purchaseInfo(orderId);
		return itemService.getItemById(directOrderVO.getItemId());
	}

	@Override
	public List<ItemVO> selectSellerItem(String memberId) {
		log.info("selectSellerItem()");
		return itemMapper.selectSellerItem(memberId);
	}

}
