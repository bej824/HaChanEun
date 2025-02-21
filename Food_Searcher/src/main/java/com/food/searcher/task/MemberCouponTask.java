package com.food.searcher.task;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import com.food.searcher.domain.CouponActiveVO;
import com.food.searcher.domain.DiscountCouponVO;
import com.food.searcher.domain.ItemVO;
import com.food.searcher.domain.MemberVO;
import com.food.searcher.service.CouponActiveService;
import com.food.searcher.service.DiscountCouponService;
import com.food.searcher.service.ItemService;
import com.food.searcher.service.MemberService;

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
	ItemService itemService;
	
	@Scheduled(cron = "0 0 0 * * *") // 매일 00:00 마다 실행 
	public void couponEvent() {
		
		Random random = new Random();
		LocalDate now = LocalDate.now();
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMdd");
		int today = Integer.valueOf(now.format(formatter));
		
		String[] MBTI = {
				"ISFJ", "ISTJ", "INFJ", "INTJ", "ISTP", "ISFP", "INFP", "INTP",
				"ESTP", "ESFP", "ENFP", "ENTP", "ESTJ", "ESFJ", "ENFJ", "ENTJ"
				};
		
		int randomIndex = random.nextInt(MBTI.length);
		
		List<DiscountCouponVO> todayBirthCouponList = 
				discountCouponService.selectCoupon("COUPON_EVENT", "memberDateOfBirth");
		
		List<MemberVO> todayBirthMemberList = 
				memberService.searchId(null, null, null, today, null);
		
		createCouponActiveBatch(todayBirthCouponList, todayBirthMemberList);
		
		
		List<DiscountCouponVO> todayMBTICoupon = 
				discountCouponService.selectCoupon("COUPON_EVENT", "memberMBTI");
		
		List<MemberVO> todayMBTIMembersList = 
				memberService.searchId(null, null, null, 0, MBTI[randomIndex]);
		
		createCouponActiveBatch(todayMBTICoupon, todayMBTIMembersList);
		
	} // end couponEvent()
	
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
	public void createCouponActiveBatch(List<DiscountCouponVO> couponList, List<MemberVO> memberList) {
		
		for(int i = 0; i < couponList.size(); i++) {
			CouponActiveVO couponActiveVO = new CouponActiveVO();
			couponActiveVO.setCouponId(couponList.get(i).getCouponId());
			couponActiveVO = setCouponInfo(couponActiveVO);
			
			for(int j = 0; j < memberList.size(); j++) {
				couponActiveVO.setMemberId(memberList.get(j).getMemberId());
				couponActiveService.createCouponActive(couponActiveVO);
			}
		}
		
	} // end createCouponActiveBatch()

}
