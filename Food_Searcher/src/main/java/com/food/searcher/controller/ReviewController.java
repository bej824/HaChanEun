package com.food.searcher.controller;

import java.security.Principal;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.food.searcher.domain.DirectOrderVO;
import com.food.searcher.domain.ReviewVO;
import com.food.searcher.service.ReviewService;

import lombok.extern.log4j.Log4j;

@RequestMapping("/product")
@Controller
@Log4j

public class ReviewController {
	
	@Autowired
	private ReviewService reviewService;
	
	@GetMapping("/review/list/{itemId}")
	public ResponseEntity<List<ReviewVO>> reviewGET(@PathVariable("itemId") long itemId, Model model) {
		log.info("reviewGET()");
		List<ReviewVO> reviewVO = reviewService.getAll(itemId);
		model.addAttribute("reviewVO", reviewVO);
		log.info("리뷰 VO : " + reviewVO);
		
		return new ResponseEntity<List<ReviewVO>>(reviewVO, HttpStatus.OK);
	}
	
	@ResponseBody
	@GetMapping("/reviewRegister")
    public String registerGET(Date deliveryCompletedDate, Principal principal, Model model) {
        log.info("registerGET()");
        String memberId = principal.getName();
        
        int result = reviewService.isEnabled(memberId, deliveryCompletedDate);
        if(result == 1){
        	 log.info("리뷰 작성 완료");
        	 return null;
        } else {
        	log.info("리뷰 작성 실패");
        	return null;
        }
        
    }
	
	@PostMapping("/reviewRegister")
	public ResponseEntity<String> reviewPOST(ReviewVO reviewVO,	
			@RequestParam(value="memberId") String memberId, 
			@RequestParam(value="itemId") long itemId ) {
		log.info("memberId : " + memberId);
		log.info("itemId : " + itemId);
		
		int result = reviewService.createReview(reviewVO);
		
	    log.info("result : " + result);
		return ResponseEntity.ok("리뷰가 성공적으로 등록되었습니다.");
	}	
	
	@ResponseBody
	@PostMapping("/review-update")
	public int modifyPOST(ReviewVO reviewVO) {
		log.info("reviewModify()");
		int result = reviewService.updateReview(reviewVO);
		log.info(reviewVO);
		
		return result;
	}
	
	@DeleteMapping("/review-delete/{reviewId}") 
	   public ResponseEntity<Integer> deleteReview(
			   @PathVariable("reviewId") long reviewId) {
	      log.info("deleteReview()");
	      log.info("reviewId : " + reviewId);
	      
	      int result = reviewService.deleteReview(reviewId);
	      
	      return new ResponseEntity<Integer>(result, HttpStatus.OK);
	   } // 댓글 삭제
	
} // end ReviewController
