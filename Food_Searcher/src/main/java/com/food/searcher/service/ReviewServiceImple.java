package com.food.searcher.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.food.searcher.domain.DirectOrderVO;
import com.food.searcher.domain.ReviewVO;
import com.food.searcher.exception.CustomException;
import com.food.searcher.persistence.DirectOrderMapper;
import com.food.searcher.persistence.ReviewMapper;

import lombok.extern.log4j.Log4j;

@Repository
@Service
@Log4j
public class ReviewServiceImple implements ReviewService {
	
	@Autowired
	ReviewMapper reviewMapper;
	
	@Autowired
	DirectOrderMapper directOrderMapper;
	
	@Override
	public int createReview(ReviewVO reviewVO) {
	   return reviewMapper.insert(reviewVO);
	}


	@Override
	public List<ReviewVO> getAll(long itemId) {
		List<ReviewVO> vo = reviewMapper.selectAll(itemId);
		return vo;
	}
	
	@Transactional(value="transactionManager")
	@Override
	public ReviewVO getReview(long itemId, String memberId) {
				
		List<DirectOrderVO> isEnabled = directOrderMapper.isEnabled(memberId);
		
		boolean result = false;
		int intItemId = (int) itemId;
		
		for (DirectOrderVO orderVO : isEnabled) {
			if (orderVO.getItemId() == intItemId && orderVO.getDeliveryCompletedDate() != null) {
			    result = true;
			    break;
			}
		}
		
		if (!result) {
	        throw new CustomException("배송이 완료된 상품만 리뷰를 작성할 수 있습니다.", "REVIEW_001");
	    }

	    List<ReviewVO> existResult = reviewMapper.isExist(itemId, memberId);
	    
	    if (existResult != null && !existResult.isEmpty()) {
	        throw new CustomException("이미 리뷰가 존재합니다.", "REVIEW_002");
	    }

	    return reviewMapper.selectOne(itemId, memberId);
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
