package com.food.searcher.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.food.searcher.domain.AttachVO;
import com.food.searcher.domain.RecipeVO;
import com.food.searcher.service.AttachService;
import com.food.searcher.service.RecipeService;
import com.food.searcher.util.FileUploadUtil;
import com.food.searcher.util.PageMaker;
import com.food.searcher.util.Pagination;

import lombok.extern.log4j.Log4j;

@Controller
@RequestMapping(value="/recipe")
@Log4j
public class RecipeController {

	@Autowired
	private String uploadPath;
	   
	   @Autowired
	   private AttachService attachService;
	
	@Autowired
	private RecipeService recipeService;
	
	@GetMapping("/list")
	public void list(@RequestParam(required = false) String recipeTitle, @RequestParam(required = false) String filterBy, @RequestParam(defaultValue = "1") int pageNum, Model model, Pagination pagination) {
		log.info("list()");
		log.info("pagination : " + pagination);
		log.info("recipeTitle : " + recipeTitle);
		log.info("filterBy : " + filterBy);
		log.info("pageNum : " + pageNum);
		pagination.setKeyword(recipeTitle);
		pagination.setType(filterBy);
		log.info("필터 적용 pagination : " + pagination);
		List<RecipeVO> recipeList = recipeService.getPagingBoards(pagination);
		log.info("vo list : " + recipeList);
		log.info(recipeList.size());
		
		PageMaker pageMaker = new PageMaker();
		pageMaker.setPagination(pagination);
		log.info(pageMaker);
		pageMaker.setTotalCount(recipeService.getTotalCount(recipeTitle, filterBy));
		log.info(recipeService.getTotalCount(recipeTitle, filterBy));
		
        model.addAttribute("recipeTitle", recipeTitle);
        model.addAttribute("filterBy", filterBy);
        model.addAttribute("pageNum", pageNum);
	
		model.addAttribute("pageMaker", pageMaker);
		model.addAttribute("recipeList", recipeList);

	}
	
	@GetMapping("/register")
	public void registerGET() {
		log.info("registerGET()");
	}
	
	// register.jsp에서 전송받은 게시글 데이터를 저장
	@PostMapping("/register")
	public String registerPOST(RecipeVO recipeVO, @RequestParam("file") List<MultipartFile> files) {
	    log.info("registerPOST()");
	    log.info("recipeVO = " + recipeVO.toString());

	    int result = recipeService.createBoard(recipeVO);
	    log.info(result + "행 등록");

	    return "redirect:/recipe/list";
	}
	
	// list.jsp에서 선택된 게시글 번호를 바탕으로 게시글 상세 조회
	// 조회된 게시글 데이터를 detail.jsp로 전송
	@GetMapping("/detail")
	public void detail(@RequestParam(required = false) String recipeTitle, @RequestParam(required = false) String filterBy, @RequestParam(defaultValue = "1") int pageNum, Model model, Integer recipeId) {
		log.info("detail()");
		log.info("recipeTitle : " + recipeTitle + " filterBy : " + filterBy + " pageNum : " + pageNum);
		log.info("레시피 ID : " + recipeId);
		RecipeVO recipeVO = recipeService.getBoardById(recipeId);
		log.info("RecipeVO : " + recipeVO);
		model.addAttribute("recipeVO", recipeVO);
		List<AttachVO> attachVO = attachService.getBoardById(recipeId);
		log.info("AttachVO : " + attachVO);
		if(attachVO != null  && !attachVO.isEmpty()) {
		model.addAttribute("idList", attachVO);
		} else {
			log.info("attachVO is null");
		}
	}
	
	// 게시글 번호를 전송받아 상세 게시글 조회
	// 조회된 게시글 데이터를 modify.jsp로 전송
	@GetMapping("/modify")
	public void modifyGET(Model model, Integer recipeId) {
		log.info("modifyGET()");
		log.info("recipeId : " + recipeId);
		RecipeVO recipeVO = recipeService.getBoardById(recipeId);
		log.info("recipeVO : " + recipeVO);
		model.addAttribute("recipeVO", recipeVO);
		List<AttachVO> attachVO = attachService.getBoardById(recipeId);
		log.info("attachVO : " + attachVO);
		if(attachVO != null  && !attachVO.isEmpty()) {
		model.addAttribute("idList", attachVO);
		}
	}
	
	// modify.jsp에서 데이터를 전송받아 게시글 수정
	@PreAuthorize("isAuthenticated() and (principal.username == #recipeVO.memberId)")
	@PostMapping("/modify")
	public String modifyPOST(RecipeVO recipeVO, 
	                         @RequestParam("file") List<MultipartFile> files,
	                         @RequestParam(name = "deleteFiles", required = false) List<String> deleteFileIds, 
	                         Integer recipeId) {
	    log.info("modifyPOST()");
	    log.info("recipeVO = " + recipeVO);

	    // 1. 게시글 수정 처리
	    int result = recipeService.updateBoard(recipeVO);
	    log.info(result + "행 수정");

	    // 4. 수정된 게시글 상세 페이지로 리디렉션
	    return "redirect:/recipe/detail?recipeId=" + recipeVO.getRecipeId();
	}

	   // detail.jsp에서 boardId를 전송받아 게시글 데이터 삭제
	@PostMapping("/delete")
	public String delete(Integer recipeId) {
	    log.info("delete()");
	    log.info("recipeId" + recipeId);

	    // recipeId에 해당하는 모든 이미지 파일 삭제
	    List<AttachVO> existingAttachVO = attachService.getBoardById(recipeId);
	    log.info("existingAttachVO : " + existingAttachVO);

	    if (existingAttachVO != null && !existingAttachVO.isEmpty()) {
	        for (AttachVO attach : existingAttachVO) {
	            log.info("attach : " + attach);
	            try {
	                // 서버에서 파일 삭제
	                FileUploadUtil.deleteFile(uploadPath, attach.getAttachPath(), attach.getAttachChgName());

	                // DB에서 파일 정보 삭제
	                attachService.deleteAttach(attach.getAttachId());
	            } catch (Exception e) {
	                log.error("파일 삭제 중 오류 발생: ", e);
	            }
	        }
	    }

	    // 레시피 삭제
	    int result = recipeService.deleteBoard(recipeId);
	    log.info(result + "행 삭제");

	    // 삭제 후 레시피 목록 페이지로 리다이렉트
	    return "redirect:/recipe/list";
	}

}
