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
public class RecipeVO {
	private int recipeId;
	private String recipeTitle;
	private String recipeFood;
	private String recipeContent;
	private Date recipeDateCreated;
	private int replyCount;
	private String memberId;
}
