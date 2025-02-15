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

public class MarketCommentVO {
	
	private int marketCommentId;
	private int marketReplyId;
	private String memberId;
	private String marketCommentContent;
	private Date commentDateCreated;

}
