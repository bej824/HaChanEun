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
public class ItemListVO {
	private String orderId;
	private String memberId;
	private int itemId;
	private int totalCount;
	private int totalPrice;
	private String deliveryAddress;
}
