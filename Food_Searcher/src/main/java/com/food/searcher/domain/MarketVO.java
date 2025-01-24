package com.food.searcher.domain;


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
	
	private int marketId;         // MARKET_ID
	private String marketTitle;	  // MARKET_TITLE
	private String marketContent; // MARKET_CONTENT
	private String marketLocal;   // MARKET_LOCAL
	private String marketDistrict;
	private String marketReplyCount;
}
