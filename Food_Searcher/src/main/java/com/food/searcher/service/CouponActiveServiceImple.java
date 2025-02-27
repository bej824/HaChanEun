package com.food.searcher.service;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.food.searcher.domain.CouponActiveVO;
import com.food.searcher.domain.DiscountCouponVO;
import com.food.searcher.domain.ItemVO;
import com.food.searcher.persistence.CouponActiveMapper;
import com.food.searcher.task.MemberCouponTask;

import lombok.extern.log4j.Log4j;

@Log4j
@Service
public class CouponActiveServiceImple implements CouponActiveService {
	
	@Autowired
	CouponActiveMapper couponActiveMapper;
	
	@Autowired
	DiscountCouponService discountCouponService;
	
	@Autowired
	ItemService itemService;
	
	@Transactional
	@Override
	public int createCouponActive(CouponActiveVO couponActiveVO) {
		log.info("createCouponActive()");
		
		if(couponActiveVO.getItemName() == null) {
			couponActiveVO.setItemName("");
		}
		
		return couponActiveMapper.insertCouponActive(couponActiveVO);
	}
	
	@Transactional
	@Override
	public List<CouponActiveVO> selectCouponActive(String memberId, int itemId) {
		log.info("selectCouponActive()");
		
		return couponActiveMapper.selectCouponActive(memberId, itemId);
	}
	
	@Transactional
	@Override
	public Integer selectCouponActiveByCouponPrice(int couponActiveId, String memberId) {
		log.info("selectCouponActiveByCouponPrice()");
		
		return couponActiveMapper.selectCouponPriceByCouponActiveId(couponActiveId, memberId);
	}
	
	@Transactional
	@Override
	public int updateCouponActiveByCouponActiveId(CouponActiveVO couponActiveVO) {
		log.info("updateCouponActiveByCouponActiveId()");
		int result = 0;
		try {
			result = couponActiveMapper.updateCouponActiveByCouponActiveId(couponActiveVO);
		} catch (Exception e) {
			log.info(couponActiveVO.getOrderId() + " 처리 중 에러" + e);
		}
		
		return result;
	}
	
	@Transactional
	@Override
	public int updateCouponActiveByOrderId(String orderId) {
		log.info("updateCouponActiveByOrderId()");
		int result = 0;
		
		try {
			result = couponActiveMapper.updateCouponActiveByOrderId(orderId);
		} catch (Exception e) {
			log.info(orderId + " 처리 중 에러" + e);
		}
		
		return result;
	}
	
	@Transactional
	@Override
	public CouponActiveVO setCouponInfo(CouponActiveVO couponActiveVO) {
		
		DiscountCouponVO coupon = discountCouponService.selectOneCoupon(couponActiveVO.getCouponId());
		
		if(couponActiveVO.getItemId() > 0) {
			ItemVO item = itemService.getItemById(couponActiveVO.getItemId());
			couponActiveVO.setItemName(item.getItemName());
		}
		
		couponActiveVO.setCouponName(coupon.getCouponName());
		couponActiveVO.setCouponIssuedDate(LocalDate.now());
		couponActiveVO.setCouponExpireDate(LocalDate.now().plusDays(coupon.getCouponExpirationDate()));
		
		return couponActiveVO;
	} // end setCouponInfo()

}
