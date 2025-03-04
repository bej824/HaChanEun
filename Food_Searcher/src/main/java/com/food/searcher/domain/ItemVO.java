package com.food.searcher.domain;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

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

public class ItemVO {
	private int itemId;
	
	private int storeId;
	private String itemContent;
	private int itemAmount;
	private Date itemDate;
	private String memberId;
	
	private String itemTag;
	
	private String mainCtg;
	private String subCtg;
	private String origin;
	private String itemName;
	private int itemPrice;
	private int itemStatus;
	private int itemLikes;
	
	private List<ItemAttachVO> attachList;
	private int itemCount;
	
	public List<ItemAttachVO> getAttachList() {
		if(attachList == null) {
			attachList = new ArrayList<ItemAttachVO>();
		}
		return attachList;
	}
}
