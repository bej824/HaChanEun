package com.food.searcher.domain;

import java.util.Date;
import java.util.List;

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
public class RecipeReplyVO {
	private int replyId;
	private int boardId;
	private String memberId;
	private String replyContent;
	private Date replyDateCreated;
	private List<RecipeCommentVO> comments;
}
