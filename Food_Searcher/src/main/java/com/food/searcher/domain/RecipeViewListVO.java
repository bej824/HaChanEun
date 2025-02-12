package com.food.searcher.domain;

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
public class RecipeViewListVO {
	private int viewsNo;
	private int recipeId;
	private String memberId;
	private RecipeViewsVO views;
}
