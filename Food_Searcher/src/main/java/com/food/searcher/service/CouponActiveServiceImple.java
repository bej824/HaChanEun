package com.food.searcher.service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.food.searcher.domain.CouponActiveVO;
import com.food.searcher.domain.DirectOrderVO;
import com.food.searcher.domain.DiscountCouponVO;
import com.food.searcher.domain.ItemVO;
import com.food.searcher.domain.MemberVO;
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
	CouponHistoryService couponHistoryService;
	
	@Autowired
	ItemService itemService;
	
	@Autowired
	UtilityService utilityService;
	
	@Transactional
	@Override
	public int createCouponActive(CouponActiveVO couponActiveVO) {
		
		List<CouponActiveVO> list = new ArrayList<CouponActiveVO>();
		couponActiveVO.setCouponActiveId(utilityService.now() + String.format("%04d", 0));
		couponActiveVO = setCouponInfo(couponActiveVO);
		list.add(couponActiveVO);
		
		return insertCouponActive(list);
	}
	
	@Transactional
	@Override
	public int createCouponListActive(List<DiscountCouponVO> couponList, List<MemberVO> memberList) {
		
		List<CouponActiveVO> list = new ArrayList<CouponActiveVO>();
		
		for(int i = 0; i < couponList.size(); i++) {
			CouponActiveVO couponActiveVO = new CouponActiveVO();
			couponActiveVO.setCouponId(couponList.get(i).getCouponId());
			couponActiveVO.setCouponActiveId(utilityService.now() + String.format("%04d", i));
			couponActiveVO = setCouponInfo(couponActiveVO);
			
			for(int j = 0; j < memberList.size(); j++) {
				couponActiveVO.setMemberId(memberList.get(j).getMemberId());
				list.add(couponActiveVO);
			}
		}
		
		return insertCouponActive(list);
	}
	
	@Transactional
	@Override
	public List<CouponActiveVO> selectCouponActive(String memberId) {
		
		return couponActiveMapper.selectCouponActive(memberId);
	}
	
	@Transactional
	@Override
	public Integer selectCouponActiveByCouponPrice(String couponActiveId) {
		Integer discountPrice = 0;
		String memberId = utilityService.loginMember();
			discountPrice = couponActiveMapper.selectCouponPriceByCouponActiveId(
					 couponActiveId
					,memberId);
			
			discountPrice = (discountPrice == null) ? 0 : discountPrice;
		
		return discountPrice;
	}
	
	@Transactional
	@Override
	public int updateCouponActiveByCouponActiveId(CouponActiveVO couponActiveVO) {
		int result = 0;
		try {
			result = couponActiveMapper.updateCouponActiveByCouponActiveId(couponActiveVO);
		} catch (Exception e) {
			log.error(couponActiveVO.getOrderId() + " 구매 쿠폰 처리 중 에러\n" + e);
		}
		
		return result;
	}
	
	@Transactional
	@Override
	public int updateCouponActiveByOrderId(String orderId) {
		int result = 0;
		
		try {
			couponActiveMapper.updateCouponActiveByOrderId(orderId);
			result = 1;
		} catch (Exception e) {
			log.error(orderId + " 환불 쿠폰 처리 중 에러\n" + e);
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
			log.error("발급된 쿠폰 삭제 처리 중 에러" + e);
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
	@Override
	public int applyCoupon(DirectOrderVO directOrderVO, LocalDateTime now) {
		
		CouponActiveVO couponActiveVO = new CouponActiveVO();
		couponActiveVO.setCouponActiveId(directOrderVO.getCouponActiveId());
		couponActiveVO.setMemberId(directOrderVO.getMemberId());
		couponActiveVO.setOrderId(directOrderVO.getOrderId());
		couponActiveVO.setItemId(directOrderVO.getItemId());
		couponActiveVO.setCouponUseDate(now);
		return updateCouponActiveByCouponActiveId(couponActiveVO);
		
	}
	
	@Transactional
	public int insertCouponActive(List<CouponActiveVO> list) {
		
		return couponActiveMapper.insertCouponActive(list);
	}

}
