package com.food.searcher.domain;

import java.time.LocalDate;
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
	private LocalDate couponIssuedDate;
	private LocalDateTime couponUseDate;
	private int itemId;
	private int settled;
	
	private String sellerId;
	private String itemName;
	private String couponPrice;

}
