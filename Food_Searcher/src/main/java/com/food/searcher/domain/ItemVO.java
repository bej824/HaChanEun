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

public class ItemVO {
	private int itemId;
	private int storeId;
	private String itemName;
	private int itemPrice;
	private String itemContent;
	private String itemTag;
	private int itemAmount;
	private Date itemDate;
	
}
