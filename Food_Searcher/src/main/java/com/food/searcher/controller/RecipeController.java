package com.food.searcher.controller;

import java.security.Principal;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.food.searcher.domain.AttachVO;
import com.food.searcher.domain.LocalSpecialityVO;
import com.food.searcher.domain.MemberVO;
import com.food.searcher.domain.RecipeLikesVO;
import com.food.searcher.domain.RecipeVO;
import com.food.searcher.service.AttachService;
import com.food.searcher.service.MemberService;
import com.food.searcher.service.RecipeLikesService;
import com.food.searcher.service.RecipeService;
import com.food.searcher.util.PageMaker;
import com.food.searcher.util.Pagination;

import lombok.extern.log4j.Log4j;

@Controller
@RequestMapping(value="/recipe")
@Log4j
public class RecipeController {

	@Autowired
	private AttachService attachService;
	
	@Autowired
	private RecipeService recipeService;
	
	@Autowired
	private MemberService memberService;
	
	@Autowired
	private RecipeLikesService likesService;
	
	@GetMapping("/list")
	public void list(Model model, Pagination pagination) {
		log.info("list()");
		log.info("pagination : " + pagination);
		pagination.setPageSize(10);

		PageMaker pageMaker = new PageMaker();
		pageMaker.setPagination(pagination);
		log.info(pageMaker);
		pageMaker.setTotalCount(recipeService.getTotalCount(pagination));
		log.info(pageMaker);
		log.info(pageMaker.getEndNum());
		List<RecipeVO> recipeList = recipeService.getPagingBoards(pagination);
		log.info("vo list : " + recipeList);
		log.info(recipeList.size());

		model.addAttribute("pageMaker", pageMaker);
		model.addAttribute("recipeList", recipeList);
	}
	
	@GetMapping("/register")
	public void registerGET() {
		log.info("registerGET()");
	}
	
	// register.jsp에서 전송받은 게시글 데이터를 저장
	@PostMapping("/register")
	public String registerPOST(RecipeVO recipeVO, Principal principal) {
	    log.info("registerPOST()");
	    log.info(principal);
	    log.info("User role: " + principal.getName());
	    recipeVO.setMemberId(principal.getName());
	    log.info("recipeVO = " + recipeVO.toString());

	    int result = recipeService.createBoard(recipeVO);
	    log.info(result + "행 등록");

	    return "redirect:/recipe/list";
	}
	
	// list.jsp에서 선택된 게시글 번호를 바탕으로 게시글 상세 조회
	// 조회된 게시글 데이터를 detail.jsp로 전송
	@GetMapping("/detail")
	public void detail(Model model, Integer recipeId, Principal principal, @ModelAttribute("pagination") Pagination pagination) {
		log.info("detail()");
		log.info("레시피 ID : " + recipeId);
		log.info("memberId : " + principal);	
		log.info("pagination : " + pagination);
		String username = (principal != null && principal.getName() != null) ? principal.getName() : "nouser";
		RecipeVO recipeVO = recipeService.getBoardById(recipeId, username);
		log.info("RecipeVO : " + recipeVO);
		
		List<LocalSpecialityVO> localList = recipeService.getAllMap();
		String str = "";
		for(LocalSpecialityVO vo : localList) {
			str += vo.getLocalTitle() + " ";
		}
		log.info("toString : " + localList.toString());
		log.info("localList size : " + localList.size());
		model.addAttribute("localList", str);
		
		if(principal != null) {
		MemberVO memberVO = memberService.getMemberById(principal.getName());
		model.addAttribute("memberVO", memberVO);
		RecipeLikesVO likesVO = likesService.getMemberLikes(recipeId, principal.getName());
		log.info("likesVO : " + likesVO);
		model.addAttribute("likesVO", likesVO);
		}
		if(recipeId.equals(recipeVO.getRecipeId())) {
		model.addAttribute("recipeVO", recipeVO);
		List<AttachVO> attachVO = attachService.getBoardById(recipeId);
		log.info("AttachVO : " + attachVO);
		model.addAttribute("idList", attachVO);
		}
	}
	
	// 게시글 번호를 전송받아 상세 게시글 조회
	// 조회된 게시글 데이터를 modify.jsp로 전송
	@GetMapping("/modify")
	public void modifyGET(Model model, Integer recipeId, Principal principal) {
		log.info("modifyGET()");
		log.info("recipeId : " + recipeId);
		RecipeVO recipeVO = recipeService.getBoardById(recipeId, principal.getName());
		log.info("recipeVO : " + recipeVO);
		if(recipeId.equals(recipeVO.getRecipeId())) {
		model.addAttribute("recipeVO", recipeVO);
		List<AttachVO> attachVO = attachService.getBoardById(recipeId);
		log.info("attachVO : " + attachVO);
		if(attachVO != null  && !attachVO.isEmpty()) {
		model.addAttribute("idList", attachVO);
		}
		}
	}
	
	// modify.jsp에서 데이터를 전송받아 게시글 수정
	@PostMapping("/modify")
	public String modifyPOST(RecipeVO recipeVO, Principal principal) {
	    log.info("modifyPOST()");
	    log.info(principal);
	    log.info("User role: " + principal.getName());
	    recipeVO.setMemberId(principal.getName());
	    log.info("recipeVO = " + recipeVO);

	    // 1. 게시글 수정 처리
	    int result = recipeService.updateBoard(recipeVO);
	    log.info(result + "행 수정");

	    return "redirect:/recipe/detail?recipeId=" + recipeVO.getRecipeId();
	}

	   // detail.jsp에서 boardId를 전송받아 게시글 데이터 삭제
	@PostMapping("/delete")
	public String delete(RecipeVO recipeVO, Integer recipeId) {
	    log.info("delete()");
	    log.info("recipeId" + recipeId);

	    // 레시피 삭제
	    int result = recipeService.deleteBoard(recipeId);
	    log.info(result + "행 삭제");

	    // 삭제 후 레시피 목록 페이지로 리다이렉트
	    return "redirect:/recipe/list";
	}

}
