package com.food.searcher.domain;


import java.util.ArrayList;
import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@ToString
@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor

public class MarketVO {
	
	private int marketId;         
	private String marketTitle;	 
	private String marketContent; 
	private String marketLocal;
	private String marketDistrict;
	private String marketReplyCount;
	private String marketName;
	private String marketFood;
	
	private List<MarketAttachVO> marketAttachList;
	
	public List<MarketAttachVO> getAttachList() {
		if(marketAttachList == null) {
			marketAttachList = new ArrayList<MarketAttachVO>();
		}
		return marketAttachList;
	}
	
}
