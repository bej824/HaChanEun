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
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.food.searcher.domain.AskVO;
import com.food.searcher.service.AskService;

import lombok.extern.log4j.Log4j;

@Controller
@RequestMapping("/ask")
@Log4j

public class AskController {
	
	@Autowired
	private AskService askService;
	
	@GetMapping("/list/{itemId}")
	public ResponseEntity<List<AskVO>> askGET(@PathVariable("itemId") int itemId, Model model)	{
		List<AskVO> askVO = askService.getAsk(itemId);
		model.addAttribute("askVO", askVO);
		log.info(askVO);
		
		return new ResponseEntity<List<AskVO>>(askVO, HttpStatus.OK);
	}
	
	@GetMapping("/register")
	public void register() {
		
	}
	
	@ResponseBody
	@PostMapping
	public ResponseEntity<Integer> askPOST(@RequestBody AskVO askVO, Principal principal) {
		log.info("askVO : " + askVO);		
		askVO.setMemberId(principal.getName());
		int result = askService.createAsk(askVO);
		return new ResponseEntity<Integer>(result, HttpStatus.OK);
	}

	
	@PostMapping("/modify")
	public String modifyPOST(AskVO askVO, Principal principal) {
		log.info("modifyPOST()");
		askVO.setMemberId(principal.getName());

		int result = askService.updateAsk(askVO);
		log.info(result + "행 수정");

		return "redirect:/ask/list";
	}

	
	
	
} // end controller
