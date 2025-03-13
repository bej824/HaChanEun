package com.food.searcher.controller;

import java.security.Principal;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

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
	public String reviewPOST(ReviewVO reviewVO, Principal principal) {
		log.info("reviewPOST()");
	    reviewVO.setMemberId(principal.getName());
	     
	    reviewService.createReview(reviewVO);
	    
	    log.info("200 return");
	    return "redirect:/item/list";
	}
	
	
} // end ReviewController
