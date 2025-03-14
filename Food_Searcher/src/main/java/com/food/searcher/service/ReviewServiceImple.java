package com.food.searcher.service;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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
		if(isEnabled(reviewVO.getMemberId(), reviewVO.getItemId()) == 1) {
			log.info("1");
			return reviewMapper.insert(reviewVO);
		} else {
			log.info("2");
			return 0;
		}
		
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
	public int isEnabled(String memberId, long itemId) {
		log.info("isEnabled()");
		return reviewMapper.isEnabled(memberId, itemId);
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
