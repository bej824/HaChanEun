package com.food.searcher.domain;

import java.time.LocalDateTime;

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
	
	private int couponHistoryId;
	private String memberId;
	private int couponId;
	private int couponIssuedDate;
	private LocalDateTime couponUseDate;
	private int itemId;
	private int settled;

}
