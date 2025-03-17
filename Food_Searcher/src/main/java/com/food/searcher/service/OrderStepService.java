package com.food.searcher.service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.food.searcher.domain.DirectOrderVO;
import com.food.searcher.domain.ItemVO;
import com.food.searcher.persistence.DirectOrderMapper;

import lombok.extern.log4j.Log4j;

@Log4j
@Service
public class OrderStepService {
	
	@Autowired
	private DirectOrderMapper directOrderMapper;

	@Autowired
	private CouponActiveService couponActiveService;

	@Autowired
	private UtilityService utilityService;

	@Autowired
	private ItemService itemService;
	
	@Autowired
	private CartService cartService;
	
	@Transactional
	public int oneOrder(DirectOrderVO directOrderVO) {
		
		directOrderVO.setOrderId(utilityService.now() + String.format("%04d", 0));
		
		List<DirectOrderVO> orderList = new ArrayList<DirectOrderVO>();
		orderList.add(directOrderVO);
		
		return itemSearch(orderList);
	}
	
	public int cartOrder(List<DirectOrderVO> orderList) {
		
		for(int i = 0; i < orderList.size(); i++) {
			orderList.get(i).setOrderId(utilityService.now() + String.format("%04d", i));
		}
		
		return itemSearch(orderList);
	}
	
	@Transactional
	public int itemSearch(List<DirectOrderVO> orderList) {
		
		for(int i = 0; i < orderList.size(); i++) {
			
			ItemVO itemVO = itemService.getItemById(orderList.get(i).getItemId());
			
			if(itemVO.getItemAmount() - orderList.get(i).getTotalCount() >= 0) {
				itemService.updateItemAmount(
						itemVO.getItemId()
						,itemVO.getItemAmount() - orderList.get(i).getTotalCount());
				
				orderList.get(i).setTotalPrice(
						itemVO.getItemPrice() * orderList.get(i).getTotalCount());
				
			} else {
				log.warn(itemVO.getItemId() + " " + itemVO.getItemName() + "의 재고가 부족합니다.");
				return 401;
			}
			
			if(itemVO.getItemStatus() != 100) {
				return 402;
			}
			
		}
		return discountPrice(orderList);
	}
	
	@Transactional
	public int discountPrice(List<DirectOrderVO> orderList) {
		
		Integer discountPrice = 0;
		
		if(orderList.get(0).getCouponActiveId() != null) {
			discountPrice = couponActiveService.selectCouponActiveByCouponPrice(
					orderList.get(0).getCouponActiveId());			
		}
		
		if(discountPrice > 0) {
			orderList.get(0).setTotalPrice(
					orderList.get(0).getTotalPrice() - discountPrice);			
		}
		
		if(discountPrice != 0) {
			int couponUseInfo = couponActiveService.applyCoupon (
					 orderList.get(0)
					,LocalDateTime.now()
					,discountPrice);
			
			if(couponUseInfo != 1) {
				return 403;
			}
			
		}
		return priceInfo(orderList);
	}
	
	@Transactional
	public int priceInfo(List<DirectOrderVO> orderList) {
		
		
		int orderTotalPrice = 0;
		
		for(int i = 0; i < orderList.size(); i++) {
			orderTotalPrice += orderList.get(i).getTotalPrice();
		}
		
		orderTotalPrice = Math.max(orderTotalPrice, 0);
		
		return kakao(orderList, orderTotalPrice);
	}
	
	@Transactional
	public int kakao(List<DirectOrderVO> orderList, int orderTotalPrice) {
		
		return acountFinal(orderList);
	}
	
	
	@Transactional
	public int acountFinal(List<DirectOrderVO> orderList) {
		

		directOrderMapper.insert(orderList);
		cartService.deleteOrderCart();
		
		return 1;
	}

}
