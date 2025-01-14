package com.food.searcher.domain;

import java.util.ArrayList;
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
public class RecipeVO {
	private int recipeId;
	private String recipeTitle;
	private String recipeFood;
	private String recipeContent;
	private Date recipeDateCreated;
	private int replyCount;
	private String memberId;
	
	private List<AttachVO> attachList;
	
	public List<AttachVO> getAttachList() {
		if(attachList == null) {
			attachList = new ArrayList<AttachVO>();
		}
		return attachList;
	}
}
