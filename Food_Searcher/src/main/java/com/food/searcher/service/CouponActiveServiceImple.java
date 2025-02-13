package com.food.searcher.service;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.food.searcher.domain.CouponActiveVO;
import com.food.searcher.domain.DiscountCouponVO;
import com.food.searcher.persistence.CouponActiveMapper;

import lombok.extern.log4j.Log4j;

@Log4j
@Service
public class CouponActiveServiceImple implements CouponActiveService {
	
	@Autowired
	CouponActiveMapper couponActiveMapper;
	
	@Override
	public int createCouponActive(CouponActiveVO couponActiveVO) {
		log.info("createCouponActive()");
		
		int result = couponActiveMapper.insertCouponActive(couponActiveVO);
		
		return 0;
	}

}
