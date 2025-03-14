package com.food.searcher.service;

import java.util.Date;
import java.util.List;

import com.food.searcher.domain.ReviewVO;

public interface ReviewService {
	int createReview(ReviewVO reviewVO);
	List<ReviewVO> getAll(long itemId);
	ReviewVO getReview(long itemId);
	int isEnabled(String memberId, long itemId);
	int updateReview(long reviewId, String reviewContent);
	int deleteReview(long reviewId);
}