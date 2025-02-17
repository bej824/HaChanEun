package com.food.searcher.service;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.food.searcher.domain.CouponActiveVO;
import com.food.searcher.domain.DiscountCouponVO;
import com.food.searcher.domain.ItemVO;
import com.food.searcher.persistence.CouponActiveMapper;

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
	
	@Override
	public int createCouponActive(CouponActiveVO couponActiveVO) {
		log.info("createCouponActive()");
		
		log.info(couponActiveVO);
		
		return couponActiveMapper.insertCouponActive(couponActiveVO);
	}
	
	@Override
	public CouponActiveVO selectOneCoupon(CouponActiveVO couponActiveVO) {
		log.info("selectOneCoupon()");
		
		DiscountCouponVO coupon = discountCouponService.selectOneCoupon(couponActiveVO.getCouponId());
		LocalDate now = LocalDate.now();
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMdd");
		
		if(couponActiveVO.getItemId() > 0) {
			ItemVO item = itemService.getItemById(couponActiveVO.getItemId());
			couponActiveVO.setItemName(item.getItemName());
		}
		
		couponActiveVO.setCouponName(coupon.getCouponName());
		couponActiveVO.setCouponIssuedDate(now.format(formatter));
		couponActiveVO.setCouponExpireDate(now.plusDays(coupon.getCouponExpirationDate()).format(formatter));
		
		return couponActiveVO;
	}

}
