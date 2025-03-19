package com.food.searcher.service;

import java.util.Date;
import java.util.List;

import com.food.searcher.domain.DirectOrderVO;
import com.food.searcher.domain.ReviewVO;

public interface ReviewService {
	int createReview(ReviewVO reviewVO);
	List<ReviewVO> getAll(long itemId);
	ReviewVO getReview(long itemId, String memberId);
	int updateReview(ReviewVO reviewVO);
	int deleteReview(long reviewId);
}