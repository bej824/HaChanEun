package com.food.searcher.service;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.food.searcher.domain.DirectOrderVO;
import com.food.searcher.domain.ReviewVO;
import com.food.searcher.persistence.ReviewMapper;

import lombok.extern.log4j.Log4j;

@Repository
@Service
@Log4j
public class ReviewServiceImple implements ReviewService {
	
	@Autowired
	ReviewMapper reviewMapper;
	
	@Transactional(value = "transactionManager")
	@Override
	public int createReview(ReviewVO reviewVO) {
		return reviewMapper.insert(reviewVO);
	}

	@Override
	public List<ReviewVO> getAll(long itemId) {
		log.info("getReviewAll()");
		List<ReviewVO> vo = reviewMapper.selectAll(itemId);
		return vo;
	}
	
	@Override
	public ReviewVO getReview(long itemId) {
		log.info("getReviewOne");
		ReviewVO reviewVO = reviewMapper.selectOne(itemId);
		
		return reviewVO;
	}
	
	@Override
	public int isEnabled(String memberId, Date deliveryCompletedDate) {
		log.info("isEnabled()");
		return reviewMapper.isEnabled(memberId, deliveryCompletedDate);
	}
	
	@Override
	public int updateReview(ReviewVO reviewVO) {
		return reviewMapper.update(reviewVO);
	}

	@Override
	public int deleteReview(long reviewId) {
		return reviewMapper.delete(reviewId);
	}

}
