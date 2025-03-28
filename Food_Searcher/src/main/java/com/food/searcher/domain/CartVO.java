package com.food.searcher.domain;

import java.util.Date;

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
	private Date cartDate;
	private int cartChecked;
	
	// Item Join
	private String itemName;
	private int itemPrice;
	private int itemAmount;
	private int itemStatus;
	
	private int totalPrice;
	
	public void updateAmount(int cartAmount) {
		this.cartAmount = cartAmount;
	}
	
	
}
