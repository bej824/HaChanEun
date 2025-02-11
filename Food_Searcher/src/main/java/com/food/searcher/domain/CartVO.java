package com.food.searcher.domain;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@ToString

public class CartVO {
	private int cartId;
	private int cartAmount;
	private int itemId;
	private String memberId;
	
	// item table
	private String itemName;
	private int itemPrice;
	
	private int totalPrice;
}
