package com.food.searcher.domain;

import java.sql.Date;

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
public class CouponActiveVO {
	
	private int couponActiveId; // 쿠폰 발급 고유 넘버
	private String memberId; // 발급받은 memberId
	private int couponId; // 쿠폰 Id
	private String couponName; // 쿠폰 이름
	private Date couponIssuedDate; // 쿠폰 발급 날짜
	private Date couponExpireDate; // 쿠폰 만료 날짜
	private Date couponUsedDate; // 쿠폰 사용 날짜
	private String couponUsedItem; // 쿠폰 사용 상품

}
