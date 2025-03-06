package com.food.searcher.service;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.food.searcher.domain.CouponHistoryVO;
import com.food.searcher.persistence.CouponHistoryMapper;
import com.food.searcher.util.Pagination;

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
	
	@Override
	public int couponHistoryCount() {
		
		return couponHistoryMapper.selectAllCount();
	}
	
	@Override
	public List<CouponHistoryVO> couponHistoryGet(Pagination pagination) {
		
		List<CouponHistoryVO> list = couponHistoryMapper.selectCouponHistoryByPagination(pagination);
		
		return list.stream().collect(Collectors.toList());
	}
	
	@Override
	public List<CouponHistoryVO> couponHistoryBySellerId(String SellerId) {
		
		return couponHistoryMapper.selectCouponHistoryBySellerId(SellerId);
	}

}
