package com.food.searcher.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.food.searcher.persistence.CouponHistoryMapper;

import lombok.extern.log4j.Log4j;

@Log4j
@Service
public class CouponHistoryServiceImple implements CouponHistoryService {
	
	@Autowired
	CouponHistoryMapper couponHistoryMapper;
	
	@Override
	public int createCouponHistory() {
		
		return couponHistoryMapper.insertCouponHistory();
	}

}
