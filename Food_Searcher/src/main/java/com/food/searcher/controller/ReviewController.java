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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

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
	
	@GetMapping("/reviewRegister")
    public String registerGET(long itemId, Principal principal, Model model) {
        log.info("registerGET()");
        
        String memberId = principal.getName();
        ReviewVO reviewVO = reviewService.getReview(itemId, memberId);
        if (reviewVO == null) {
            model.addAttribute("msg", "배송이 완료된 상품만 리뷰를 작성할 수 있습니다..");
            model.addAttribute("url", "../item/purchaseHistory");
            return "alert";
        }
        
        model.addAttribute("reviewVO", reviewVO);
        model.addAttribute("itemId", itemId);

        log.info("VO : " + reviewVO);

        return "product/reviewRegister";
        
    }
	
	@PostMapping("/reviewRegister")
	public ResponseEntity<String> reviewPOST(ReviewVO reviewVO, Principal principal) {
	    log.info("postreviewPOST() 호출");

	    String memberId = principal.getName();
	    reviewVO.setMemberId(memberId);

	    int result = reviewService.createReview(reviewVO);

	    if (result == 1) {
	        return ResponseEntity.ok("리뷰가 성공적으로 등록되었습니다.");
	    } else {
	        return ResponseEntity.badRequest().body("리뷰 등록 실패: 구매 내역이 없습니다.");
	    }
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
