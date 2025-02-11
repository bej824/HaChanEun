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
public class CouponHistoryVO {
	
	private int couponHistoryId; // 쿠폰 사용 기록 고유번호
	private String memberId; // 발급받은 memberId
	private int couponId; // 쿠폰 Id
	private String couponName; // 쿠폰 이름
	private int couponIssuedDate; // 쿠폰 발급 날짜
	private int couponUsed; // 쿠폰 사용 유무

}
