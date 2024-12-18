package com.food.searcher.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.food.searcher.domain.RecipeVO;
import com.food.searcher.service.RecipeService;
import com.food.searcher.util.PageMaker;
import com.food.searcher.util.Pagination;

import lombok.extern.log4j.Log4j;

@Controller
@RequestMapping(value="/recipe")
@Log4j
public class RecipeController {
	
	@Autowired
	private RecipeService recipeService;
	
	@GetMapping("/list")
	public void list(Model model, Pagination pagination) {
		log.info("list()");
		log.info("pagination : " + pagination);
		@SuppressWarnings("unchecked")
		List<RecipeVO> recipeList = (List<RecipeVO>) model.asMap().get("recipeList");
		log.info("vo list : " + recipeList);
		
		PageMaker pageMaker = new PageMaker();
		pageMaker.setPagination(pagination);
		
		
	    if (recipeList == null) {
	        recipeList = recipeService.getPagingBoards(pagination);
	        log.info("페이징 : " + recipeList);
	        pageMaker.setTotalCount(recipeService.getTotalCount());
	    } else {
	    	pageMaker.setTotalCount(recipeList.size());
	    	log.info(recipeList.size());
	    }
		
		model.addAttribute("pageMaker", pageMaker);
		model.addAttribute("recipeList", recipeList);
	}
	
	// 검색 기능 (제목, 음식, 작성자, 내용)
	@PostMapping("/list")
	public String searchPOST(@RequestParam String recipeTitle, @RequestParam String filterBy, RedirectAttributes redirectAttributes, Pagination pagination) {
		log.info("searchPOST()");
		log.info("검색어: " + recipeTitle);
		log.info("필터 기준: " + filterBy);
		
		List<RecipeVO> recipeVO;
		
		switch (filterBy) {
        case "recipeTitle":
        	recipeVO = recipeService.getselectSearch(recipeTitle);
        	log.info("recipeVO" + recipeVO);
            break;
        case "recipeFood":
        	recipeVO = recipeService.getSelectFood(recipeTitle);
        	log.info("recipeVO" + recipeVO);
        	break;
        case "content":
        	recipeVO = recipeService.getSelectContent(recipeTitle);
        	log.info("recipeVO" + recipeVO);
            break;
        case "author":
        	recipeVO = recipeService.getSelectId(recipeTitle);
        	log.info("recipeVO" + recipeVO);
            break;
        default:
        	recipeVO = recipeService.getselectSearch(recipeTitle); // 기본값으로 제목 검색
        	log.info("recipeVO" + recipeVO);
            break;
    }
		
	    PageMaker pageMaker = new PageMaker();
	    pageMaker.setPagination(pagination);
	    pageMaker.setTotalCount(recipeVO.size());
	    
		redirectAttributes.addFlashAttribute("pageMaker", pageMaker);
		redirectAttributes.addFlashAttribute("recipeList", recipeVO);
		
		return "redirect:/recipe/list";
	}
	
	@GetMapping("/register")
	public void registerGET() {
		log.info("registerGET()");
	}
	
	// register.jsp에서 전송받은 게시글 데이터를 저장
	@PostMapping("/register")
	public String registerPOST(RecipeVO recipeVO) {
		log.info("registerPOST()");
		log.info("recipeVO = " + recipeVO.toString());
		int result = recipeService.createBoard(recipeVO);
		log.info(result + "행 등록");
		return "redirect:/recipe/list";
	}
	
	// list.jsp에서 선택된 게시글 번호를 바탕으로 게시글 상세 조회
	// 조회된 게시글 데이터를 detail.jsp로 전송
	@GetMapping("/detail")
	public void detail(Model model, Integer recipeId) {
		log.info("detail()");
		RecipeVO recipeVO = recipeService.getBoardById(recipeId);
		model.addAttribute("recipeVO", recipeVO);
	}
	
	// 게시글 번호를 전송받아 상세 게시글 조회
	// 조회된 게시글 데이터를 modify.jsp로 전송
	@GetMapping("/modify")
	public void modifyGET(Model model, Integer recipeId) {
		log.info("modifyGET()");
		RecipeVO recipeVO = recipeService.getBoardById(recipeId);
		model.addAttribute("recipeVO", recipeVO);
	}
	
	// modify.jsp에서 데이터를 전송받아 게시글 수정
	@PostMapping("/modify")
	public String modifyPOST(RecipeVO recipeVO) {
		log.info("modifyPOST()");
		log.info(recipeVO);
		int result = recipeService.updateBoard(recipeVO);
		log.info(result + "행 수정");
		return "redirect:/recipe/list";
	}
	
	   // detail.jsp에서 boardId를 전송받아 게시글 데이터 삭제
	   @PostMapping("/delete")
	   public String delete(Integer recipeId) {
	      log.info("delete()");
	      int result = recipeService.deleteBoard(recipeId);
	      log.info(result + "행 삭제");
	      return "redirect:/recipe/list";
	   }
	   
}
