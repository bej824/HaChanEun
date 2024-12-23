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
public class HeaderReplyVO {
	
	private int boardId;
	private int replyId;
	private String memberId;
	private String headerReplyContent;
	private Date replyDateCreated;

}
