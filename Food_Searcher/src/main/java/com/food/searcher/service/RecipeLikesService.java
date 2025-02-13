package com.food.searcher.service;

import java.util.List;

import com.food.searcher.domain.RecipeLikesVO;
import com.food.searcher.util.Pagination;

public interface RecipeLikesService {
	List<RecipeLikesVO> getSelectAll();
	List<RecipeLikesVO> getPagingBoards(Pagination pagination);
	RecipeLikesVO getMemberLikes(int recipeBoardId, String memberId);
	int createLike(RecipeLikesVO recipeLikesVO);
	int updateLike(RecipeLikesVO recipeLikesVO);
}
