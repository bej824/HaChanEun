package com.food.searcher.service;

import com.food.searcher.domain.LocalLikesVO;

public interface LocalLikesService {
	
	int createLikes(LocalLikesVO localLikesVO);
	LocalLikesVO selectLikes(int boardId, int memberId);
	int updateLikes(int boardId, int memberId, int memberLike);

}
