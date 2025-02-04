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
	private int memberLike;
	private int previousMemberLike;
	private int likeCount;
	private MemberVO member;
}
