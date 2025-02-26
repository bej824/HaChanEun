package com.food.searcher.controller;

import java.security.Principal;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.food.searcher.service.SellerService;

import lombok.extern.log4j.Log4j;

@Controller
@RequestMapping("/seller")
@Log4j
public class SellerController {
	
	@Autowired
	SellerService sellerService;
	
	@GetMapping("authenticate")
	public void authenticateGET() {
		log.info("authenticateGET()");
		
	}
	
	@PostMapping("roleUpdate")
	public int roleUpdatePOST(Principal principal) {
		log.info("roleUpdatePOST()");
		String memberId = principal.getName();
		
		return sellerService.SellerCreate(memberId);
	}

}
