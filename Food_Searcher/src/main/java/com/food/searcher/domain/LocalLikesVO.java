package com.food.searcher.domain;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@NoArgsConstructor
@Getter
@Setter
@ToString
public class LocalLikesVO {
	
	private int likesId;
	private int boardId;
	private String memberId;
	private int memberAge;
	private String memberGender;
	private String memberMBTI;
	private String memberConstellation;
	private int memberLike;

}
