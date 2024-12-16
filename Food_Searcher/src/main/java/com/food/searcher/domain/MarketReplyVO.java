package com.food.searcher.domain;

import java.util.Date;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@NoArgsConstructor
@Getter
@Setter
@ToString
public class MarketReplyVO {
	
	private int marketReplyId;
	private int marketId;
	private String memberId;
	private String marketReplyContent;
	private Date replyDateCreated;
	
}
