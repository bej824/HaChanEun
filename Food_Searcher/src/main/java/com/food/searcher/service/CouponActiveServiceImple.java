package com.food.searcher.service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.food.searcher.domain.CouponActiveVO;
import com.food.searcher.domain.DirectOrderVO;
import com.food.searcher.domain.DiscountCouponVO;
import com.food.searcher.domain.ItemVO;
import com.food.searcher.persistence.CouponActiveMapper;
import com.food.searcher.task.MemberCouponTask;

import lombok.extern.log4j.Log4j;

/**
 * @author sdedu
 *
 */
@Log4j
@Service
public class CouponActiveServiceImple implements CouponActiveService {
	
	@Autowired
	CouponActiveMapper couponActiveMapper;
	
	@Autowired
	DiscountCouponService discountCouponService;
	
	@Autowired
	CouponHistoryService couponHistoryService;
	
	@Autowired
	ItemService itemService;
	
	@Autowired
	UtilityService utilityService;
	
	@Transactional
	@Override
	public int createCouponActive(CouponActiveVO couponActiveVO) {
		
		if(couponActiveVO.getItemName() == null) {
			couponActiveVO.setItemName("");
		}
		
		couponActiveVO.setCouponActiveId(utilityService.sysDate());
		return couponActiveMapper.insertCouponActive(couponActiveVO);
	}
	
	@Transactional
	@Override
	public List<CouponActiveVO> selectCouponActive(String memberId, int itemId) {
		
		return couponActiveMapper.selectCouponActive(memberId, itemId);
	}
	
	@Transactional
	@Override
	public Integer selectCouponActiveByCouponPrice(DirectOrderVO directOrderVO, LocalDateTime now) {
		log.info("selectCouponActiveByCouponPrice()");
		Integer discountPrice = 0;
		String couponActiveId = directOrderVO.getCouponActiveId();
		String memberId = directOrderVO.getMemberId();
		
		if(!directOrderVO.getCouponActiveId().equals("0")) {
			discountPrice = couponActiveMapper.selectCouponPriceByCouponActiveId(
					 couponActiveId
					,memberId);
			
			discountPrice = (discountPrice == null) ? 0 : discountPrice;
		}
		
		if(discountPrice > 0) {
			applyCoupon(directOrderVO, now, discountPrice);				
		} else {
			return 0;
		}
		
		return discountPrice;
	}
	
	@Transactional
	@Override
	public int updateCouponActiveByCouponActiveId(CouponActiveVO couponActiveVO) {
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
		int result = 0;
		
		try {
			result = couponActiveMapper.updateCouponActiveByOrderId(orderId);
		} catch (Exception e) {
			log.info(orderId + " 처리 중 에러" + e);
			throw e;
		}
		
		return result;
	}
	
	@Transactional
	@Override
	public void deleteCouponActiveByOrderId() {
		
		try {
			couponHistoryService.createCouponHistory();
			couponActiveMapper.deleteCouponActiveByOrderId();
		} catch (Exception e) {
			log.info("발급된 쿠폰 삭제 처리 중 에러" + e);
			throw e;
		}
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
	
	@Transactional
	private int applyCoupon(DirectOrderVO directOrderVO, LocalDateTime now, Integer discountPrice) {
		
		CouponActiveVO couponActiveVO = new CouponActiveVO();
		couponActiveVO.setCouponActiveId(directOrderVO.getCouponActiveId());
		couponActiveVO.setMemberId(directOrderVO.getMemberId());
		couponActiveVO.setOrderId(directOrderVO.getOrderId());
		couponActiveVO.setItemId(directOrderVO.getItemId());
		couponActiveVO.setCouponUseDate(now);
		return updateCouponActiveByCouponActiveId(couponActiveVO);
		
	}

}
