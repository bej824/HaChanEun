package com.food.searcher.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;

import com.food.searcher.domain.ReviewVO;
import com.food.searcher.persistence.ReviewMapper;

import lombok.extern.log4j.Log4j;

@Repository
@Service
@Log4j
public class ReviewServiceImple implements ReviewService {
	
	@Autowired
	ReviewMapper reviewMapper;
	
	@Override
	public int createReview(ReviewVO reviewVO) {
		return reviewMapper.insert(reviewVO);
	}

	@Override
	public List<ReviewVO> getAll(long itemId) {
		List<ReviewVO> vo = reviewMapper.selectAll(itemId);
		return vo;
	}

	@Override
	public int updateReview(long reviewId, String reviewContent) {
		ReviewVO reviewVO = new ReviewVO();
		reviewVO.setReviewId(reviewId);
		reviewVO.setReviewContent(reviewContent);
		return reviewMapper.update(reviewVO);
	}

	@Override
	public int deleteReview(long reviewId) {
		return reviewMapper.delete(reviewId);
	}

}
