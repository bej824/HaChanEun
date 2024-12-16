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
public class RecipeCommentVO {
	private int recipeCommentId;
	private int recipeReplyId;
	private String memberId;
	private String commentContent;
	private Date commentDateCreated;
}
