package com.food.searcher.controller;

import java.security.Principal;
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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.food.searcher.domain.ReviewVO;
import com.food.searcher.exception.CustomException;
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
	
	@GetMapping("/reviewRegister")
    public String registerGET(long itemId, Principal principal, Model model) {
        log.info("registerGET()");
        
        String memberId = principal.getName();
        try {
            ReviewVO reviewVO = reviewService.getReview(itemId, memberId);
            
            model.addAttribute("reviewVO", reviewVO);
            model.addAttribute("itemId", itemId);
            
            log.info("VO : " + reviewVO);
            
            return "product/reviewRegister";

        } catch (CustomException e) {
            log.info(e.getErrorCode());
            log.info(e.getMessage());
            
            model.addAttribute("msg", e.getMessage());
            
            if ("REVIEW_001".equals(e.getErrorCode())) {
                model.addAttribute("url", "../item/purchaseHistory");
            } else if ("REVIEW_002".equals(e.getErrorCode())) {
                model.addAttribute("url", "../item/purchaseHistory");
            } else {
                model.addAttribute("url", "../home");
            }

            return "alert";
        }
        

	}
	
	@PostMapping("/reviewRegister")
	public String reviewPOST(ReviewVO reviewVO, Principal principal) {
	    log.info("postreviewPOST() 호출");
	    String memberId = principal.getName();
	    reviewVO.setMemberId(memberId);
	    reviewService.createReview(reviewVO);
	    return "redirect:/item/purchaseHistory";
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
