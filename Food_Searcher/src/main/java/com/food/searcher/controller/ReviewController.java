package com.food.searcher.controller;

import java.security.Principal;
import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

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
		log.info(reviewVO);
		
		return new ResponseEntity<List<ReviewVO>>(reviewVO, HttpStatus.OK);
	}
		
	@GetMapping("/reviewRegister")
    public String registerGET(@RequestParam("itemId") long itemId, Model model) {
        log.info("registerGET()");
        
        ReviewVO reviewVO = reviewService.getReview(itemId);
        
        model.addAttribute("reviewVO", reviewVO);
        model.addAttribute("itemId", itemId);
        
        log.info("VO : " + reviewVO);
        
        return "product/reviewRegister";
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
	
	@PutMapping("/review-update/{reviewId}")
	public ResponseEntity<Integer> modifyPOST(@PathVariable("reviewId") long reviewId, 
											  @RequestBody String reviewContent) {

		return new ResponseEntity<Integer>(reviewService.updateReview(reviewId, reviewContent), HttpStatus.OK);
	}
	
	@DeleteMapping("/review-delete/{reviewId}") 
	   public ResponseEntity<Integer> deleteReview(
			   @PathVariable("askId") long reviewId) {
	      log.info("deleteReview()");
	      log.info("reviewId : " + reviewId);
	      
	      int result = reviewService.deleteReview(reviewId);
	      
	      return new ResponseEntity<Integer>(result, HttpStatus.OK);
	   } // 댓글 삭제
	
} // end ReviewController
