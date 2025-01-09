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
public class LocalReplyVO {
	
	private int replyId;
	private int localId;
	private String memberId;
	private String replyContent;
	private Date replyDateCreated;
	private int commentCount;

}
