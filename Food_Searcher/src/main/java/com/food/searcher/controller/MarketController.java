package com.food.searcher.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.access.annotation.Secured;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

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
	private MarketService marketService;
	
	@GetMapping("/list")
	public void list(Model model, Pagination pagination) {
		log.info("list");
		log.info(pagination);
		List<MarketVO> marketList = marketService.getPagingMarkets(pagination);
		if(!marketList.isEmpty()) {
			model.addAttribute("marketList", marketList);
			log.info("marketList : " + marketList);
		} else {
			log.info("엥");
		}
		
		PageMaker pageMaker = new PageMaker();
		pageMaker.setPagination(pagination);
		pageMaker.setTotalCount(marketService.getTotalCount(pagination));
		
		log.info(pageMaker);
		model.addAttribute("pageMaker", pageMaker);
		
	}
	
	@PreAuthorize("isAuthenticated()")
	@GetMapping("/register")
	public void register() {
		log.info("registerGET()");
	}
	
	@PreAuthorize("isAuthenticated()")
	@PostMapping("/register")
	public String marketPOST (MarketVO marketVO, RedirectAttributes reAttr) {
		log.info("registerPOST()");
		log.info("marketVO = " + marketVO.toString());
		log.info("reAttr :  " + reAttr);
		
		int result = marketService.createMarket(marketVO);
		log.info(result + "행 등록");
		return "redirect:/market/list";
	}


	@GetMapping("/detail")
	public void detail(Model model, Integer marketId, @ModelAttribute("pagination") Pagination pagination) {
		log.info("detail()");
		log.info("marketId = " + marketId);
		log.info("pagination = " + pagination);
		
		MarketVO marketVO = marketService.getMarketById(marketId);
		log.info("MarketVO : " + marketVO);
		
		model.addAttribute("marketVO", marketVO);
	}
	
	@PreAuthorize("isAuthenticated()")
	@GetMapping("/modify")
	public void modifyGET(Model model, Integer marketId) {
		log.info("modifyGET()");	
		log.info("marketId = " + marketId);
		MarketVO marketVO = marketService.getMarketById(marketId);
		model.addAttribute("marketVO", marketVO);
	}
	
	// modify.jsp에서 데이터를 전송받아 게시글 수정
	@PreAuthorize("isAuthenticated()")
	@PostMapping("/modify")
	public String modifyPOST(MarketVO marketVO, Pagination pagination, RedirectAttributes reAttr) {
		log.info("modifyPOST()");
		int result = marketService.updateMarket(marketVO);
		log.info(marketVO);
		log.info(result + "행 수정");
		
		reAttr.addAttribute("pageNum", pagination.getPageNum());
		reAttr.addAttribute("pageSize", pagination.getPageSize());
		reAttr.addAttribute("type", pagination.getType());
		reAttr.addAttribute("keyword", pagination.getKeyword());
		
		
		return "redirect:/market/list";
	}
	
	@PostMapping("/delete")
	public String delete(Integer marketId, Pagination pagination, RedirectAttributes reAttr) {
		log.info("delete()");
		int result = marketService.deleteMarket(marketId);
		log.info(result + "행 삭제");
		
		reAttr.addAttribute("pageNum", pagination.getPageNum());
		reAttr.addAttribute("pageSize", pagination.getPageSize());
		reAttr.addAttribute("type", pagination.getType());
		reAttr.addAttribute("keyword", pagination.getKeyword());
		
		return "redirect:/market/list";
		
	} // end delete

	

} // end MarketController