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
	MemberCouponTask memberCouponTask;
	
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
	public CouponActiveVO selectOneCoupon(CouponActiveVO couponActiveVO) {
		log.info("selectOneCoupon()");
		
		couponActiveVO = memberCouponTask.setCouponInfo(couponActiveVO);
		
		return couponActiveVO;
	}
	
	@Transactional
	@Override
	public List<CouponActiveVO> selectCouponActive(String memberId, int itemId) {
		log.info("selectCouponActive()");
		log.info(memberId);
		
		return couponActiveMapper.selectCouponActive(memberId, itemId);
	}
	
	@Transactional
	@Override
	public int updateCouponActiveByCouponActiveId(String memberId, int couponActiveId, int couponId) {
		log.info("updateCouponActiveByCouponActiveId()");
		
		return couponActiveMapper.updateCouponActiveByCouponActiveId(couponActiveId);
	}

}
