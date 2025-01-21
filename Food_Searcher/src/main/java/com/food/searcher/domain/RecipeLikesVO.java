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
public class RecipeLikesVO {
	private int recipeLikesId;
	private int recipeBoardId;
	private String memberId;
	private int memberAge;
	private String memberGender;
	private String memberMBTI;
	private String memberConstellation;
	private int memberLike;
	private int previousMemberLike;
}
