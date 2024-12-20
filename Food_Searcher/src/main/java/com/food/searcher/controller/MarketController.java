package com.food.searcher.controller;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.food.searcher.domain.MarketVO;
import com.food.searcher.service.MarketService;
import com.food.searcher.util.PageMaker;
import com.food.searcher.util.Pagination;

import lombok.extern.log4j.Log4j;

@RequestMapping("/market")
@Controller
@Log4j

public class MarketController {
	
	@Autowired
	private String uploadPath; // Bean으로 설정된 uploadPath() 객체 주입
	
	@Autowired
	private MarketService marketService;
	
	@GetMapping("/list")
	public void list(Model model, Pagination pagination) {
		log.info("list");
		log.info("pagination = " + pagination);
		List<MarketVO> marketList = marketService.getPagingMarkets(pagination);
		
		PageMaker pageMaker = new PageMaker();
		pageMaker.setPagination(pagination);
		pageMaker.setTotalCount(marketService.getTotalCount());
		
		model.addAttribute("pageMaker", pageMaker);
		model.addAttribute("marketList", marketList);
		
	}
	
	@GetMapping("/register")
	public void register() {
		log.info("register");
	}
	

	
	@PostMapping("/register")
	public String marketPOST (MarketVO marketVO, MultipartFile file) {
		log.info("registerPOST()");
		log.info("marketVO = " + marketVO.toString());
		int result = marketService.createMarket(marketVO);
		log.info(result + "행 등록");

		return "redirect:/market/list";
	}


	@GetMapping("/detail")
	public void detail(Model model, Integer marketId) {
		log.info("detail()");
		MarketVO marketVO = marketService.getMarketById(marketId);
		model.addAttribute("marketVO", marketVO);
	}
	
	@GetMapping("/modify")
	public void modifyGET(Model model, Integer marketId) {
		log.info("modifyGET()");	
		MarketVO marketVO = marketService.getMarketById(marketId);
		model.addAttribute("marketVO", marketVO);
	}
	
	// modify.jsp에서 데이터를 전송받아 게시글 수정
	@PostMapping("/modify")
	public String modifyPOST(MarketVO marketVO) {
		log.info("modifyPOST()");
		int result = marketService.updateMarket(marketVO);
		log.info(result + "행 수정");
		return "redirect:/market/list";
	}
	
	@PostMapping("/delete")
	public String delete(Integer marketId) {
		log.info("delete()");
		int result = marketService.deleteMarket(marketId);
		log.info(result + "행 삭제");
		return "redirect:/market/list";
	}
	

	

} // end MarketController