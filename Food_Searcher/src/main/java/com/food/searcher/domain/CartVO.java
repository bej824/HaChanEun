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
@ToString

public class CartVO {
	private int cartId;
	private int cartAmount;
	private int itemId;
	private String memberId;
	private Date cartDate;
	
	// Item
	private String itemName;
	private int itemPrice;
	
	private int totalPrice;
	
	public void initTotal() {
		this.totalPrice = this.cartAmount * this.itemPrice;
	}
	
	
	public void setCartId(int cartId) {
		this.cartId = cartId;
	}
	public void setCartAmount(int cartAmount) {
		this.cartAmount = cartAmount;
	}
	public void setItemId(int itemId) {
		this.itemId = itemId;
	}
	public void setMemberId(String memberId) {
		this.memberId = memberId;
	}
	public void setItemName(String itemName) {
		this.itemName = itemName;
	}
	public void setItemPrice(int itemPrice) {
		this.itemPrice = itemPrice;
	}
	
	
}
