package com.food.searcher.domain;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@ToString
public class LocalLikesVO {
	
	private int likesId;
	private int localId;
	private String memberId;
	private int memberLike;
	
	// 좋아요, 싫어요 갯수
	
	private int likeCount;
	private int dislikeCount;

}
