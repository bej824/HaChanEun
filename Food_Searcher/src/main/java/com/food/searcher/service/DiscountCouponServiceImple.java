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
	public List<DiscountCouponVO> selectCoupon(String searchBy, String searchText) {
		log.info("selectAllCoupon()");
		
		return discountCouponMapper.selectCoupon(searchBy, searchText);
	}
	
	@Override
	public DiscountCouponVO selectOneCoupon(int couponId) {
		log.info("selectOneCoupon()");
		
		return discountCouponMapper.selectOneCoupon(couponId);
	}
	
	@Override
	public int updateCoupon(DiscountCouponVO discountCouponVO) {
		log.info("updateCoupon()");
		log.info(discountCouponVO);
		
		return discountCouponMapper.updateCoupon(discountCouponVO);
	}
	
	@Override
	public int deleteCoupon(int couponId) {
		log.info("deleteCoupon()");
		
		return discountCouponMapper.deleteCoupon(couponId);
	}

}
