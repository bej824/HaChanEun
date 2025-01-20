package com.food.searcher.service;

import com.food.searcher.domain.RecipeLikesVO;

public interface RecipeLikesService {
	int createLike(RecipeLikesVO recipeLikesVO);
	RecipeLikesVO getMemberLikes(int recipeBoardId, String memberId);
	int updateLike(RecipeLikesVO recipeLikesVO);
}
