package com.food.searcher.domain;

import java.util.Date;

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

public class ReviewVO {
	
	private long reviewId;
	private String memberId;
	private long itemId;
	private String reviewContent;
	private Date reviewDate;
	private boolean reviewLove;
	private long likesCount;
	private String itemName;
	private String itemContent;
	private Date deliveryCompletedDate;
}
