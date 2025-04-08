package com.food.searcher.task;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import com.food.searcher.domain.DiscountCouponVO;
import com.food.searcher.domain.MemberVO;
import com.food.searcher.service.CouponActiveService;
import com.food.searcher.service.CouponHistoryService;
import com.food.searcher.service.DiscountCouponService;
import com.food.searcher.service.MemberService;
import com.food.searcher.service.UtilityService;
import com.food.searcher.util.RandomUtil;

import lombok.extern.log4j.Log4j;

@Component
@Log4j
public class MemberCouponTask {
	
	@Autowired
	MemberService memberService;
	
	@Autowired
	DiscountCouponService discountCouponService;
	
	@Autowired
	CouponActiveService couponActiveService;
	
	@Autowired
	CouponHistoryService couponHistoryService;
	
	@Autowired
	UtilityService utilityService;
	
	@Autowired
	RandomUtil randomUtil;
	
	@Scheduled(cron = "0 0 0 * * *") // 매일 00:00 마다 실행 
	public void couponEvent() {
		
		LocalDate now = LocalDate.now();
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMdd");
		int today = Integer.valueOf(now.format(formatter));
		
		List<DiscountCouponVO> todayBirthCouponList = 
				discountCouponService.selectCoupon("COUPON_EVENT", "memberDateOfBirth");
		
		List<MemberVO> todayBirthMemberList = 
				memberService.searchId(null, null, null, today, null);
		
		couponActiveService.createCouponListActive(todayBirthCouponList, todayBirthMemberList);
		
		if(randomUtil.getTodayMBTI() != null) {
			List<DiscountCouponVO> todayMBTICoupon = 
					discountCouponService.selectCoupon("COUPON_EVENT", "memberMBTI");
			List<MemberVO> todayMBTIMembersList = 
					memberService.searchId(null, null, null, 0, randomUtil.getTodayMBTI());
			couponActiveService.createCouponListActive(todayMBTICoupon, todayMBTIMembersList);
		}
		
		couponActiveService.deleteCouponActiveByOrderId();
		
	} // end couponEvent()

}
