package com.food.searcher.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.food.searcher.domain.DiscountCouponVO;
import com.food.searcher.persistence.DiscountCouponMapper;

import lombok.extern.log4j.Log4j;

@Service
@Log4j
public class DiscountCouponServiceImple implements DiscountCouponService {
	
	@Autowired
	DiscountCouponMapper discountCouponMapper;
	
	@Transactional
	@Override
	public int createCoupon(DiscountCouponVO discountCouponVO) {
		log.info("createCoupon()");
		
		return discountCouponMapper.insertCoupon(discountCouponVO);
	}
	
	@Override
	public List<DiscountCouponVO> selectAllCoupon() {
		
		return discountCouponMapper.selectAllCoupon();
	}

}
