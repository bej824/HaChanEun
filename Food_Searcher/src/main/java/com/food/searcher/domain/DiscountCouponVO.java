package com.food.searcher.domain;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@ToString
public class DiscountCouponVO {
	
	private int couponId; // 쿠폰 고유 id
	private String couponName; // 쿠폰 이름
	private String couponIssuer; // 쿠폰 발급자
	private String couponContent; // 쿠폰 내용
	private int couponPrice; // 쿠폰 할인 가격
	private int couponUseCondition; // 쿠폰 사용 조건
	private String couponEvent; // 쿠폰 발급 조건
	private int couponExpirationDate; // 쿠폰 발급 후 사용 기한
	
	private String sellerId;

}
