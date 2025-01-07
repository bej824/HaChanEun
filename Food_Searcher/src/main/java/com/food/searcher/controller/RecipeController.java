package com.food.searcher.controller;

import java.io.File;
import java.util.List;
import java.util.UUID;

//import javax.servlet.ServletContext;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.food.searcher.domain.AttachVO;
import com.food.searcher.domain.RecipeCommentVO;
import com.food.searcher.domain.RecipeReplyVO;
import com.food.searcher.domain.RecipeVO;
import com.food.searcher.service.AttachService;
import com.food.searcher.service.RecipeCommentService;
import com.food.searcher.service.RecipeReplyService;
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
	
	@Autowired
	private RecipeReplyService recipeReplyService;
	
	@Autowired
	private RecipeCommentService recipeCommentService;
	
//    @Autowired
//    private ServletContext servletContext;
	
	@GetMapping("/list")
	public void list(@RequestParam(required = false) String recipeTitle, @RequestParam(required = false) String filterBy, Model model, Pagination pagination) {
		log.info("list()");
		log.info("pagination : " + pagination);
		log.info("recipeTitle : " + recipeTitle);
		log.info("filterBy : " + filterBy);
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
	
		model.addAttribute("pageMaker", pageMaker);
		model.addAttribute("recipeList", recipeList);

	}
	
	@GetMapping("/register")
	public void registerGET() {
		log.info("registerGET()");
	}
	
	// register.jsp에서 전송받은 게시글 데이터를 저장
	@PostMapping("/register")
	public String registerPOST(RecipeVO recipeVO, AttachVO attachVO) {
		log.info("registerPOST()");
		log.info("recipeVO = " + recipeVO.toString());
		int result = recipeService.createBoard(recipeVO);
		log.info(result + "행 등록");
		
		
		List<RecipeVO> list = recipeService.getAllBoards();
		log.info("recipeId 번호 : " + list.get(0).getRecipeId());
		
		if (attachVO != null && attachVO.getFile() != null && !attachVO.getFile().isEmpty()) {
	      MultipartFile file = attachVO.getFile();

	      // UUID 생성
	      String chgName = UUID.randomUUID().toString();
	      
	      // 파일 저장
	      FileUploadUtil.saveFile(uploadPath, file, chgName);

	      attachVO.setBoardId(list.get(0).getRecipeId());
	      // 파일 경로 설정
	      attachVO.setAttachPath(FileUploadUtil.makeDatePath());
	      // 파일 실제 이름 설정
	      attachVO.setAttachRealName(FileUploadUtil.subStrName(file.getOriginalFilename()));
	      // 파일 변경 이름(UUID) 설정
	      attachVO.setAttachChgName(chgName);
	      // 파일 확장자 설정
	      attachVO.setAttachExtension(FileUploadUtil.subStrExtension(file.getOriginalFilename()));
	      // DB에 첨부 파일 정보 저장
	      log.info(attachVO);
	      log.info(attachService.createAttach(attachVO) + "행 등록");
		}
		return "redirect:/recipe/list";
	}
	
	// list.jsp에서 선택된 게시글 번호를 바탕으로 게시글 상세 조회
	// 조회된 게시글 데이터를 detail.jsp로 전송
	@GetMapping("/detail")
	public void detail(Model model, Integer recipeId) {
		log.info("detail()");
		log.info("레시피 ID : " + recipeId);
		RecipeVO recipeVO = recipeService.getBoardById(recipeId);
		log.info("RecipeVO : " + recipeVO);
		List<RecipeVO> list = recipeService.getAllBoards();
		model.addAttribute("recipeVO", recipeVO);
		List<AttachVO> attachVO = attachService.getAttachById(recipeId);
		log.info("AttachVO : " + attachVO);
		if(attachVO != null  && !attachVO.isEmpty()) {
		model.addAttribute("idList", attachVO);
		String date = attachVO.get(0).getAttachPath().replace("\\", "/");
		String imagePath = "/food/"+date+"/" + attachVO.get(0).getAttachChgName(); // 이미지 경로
		log.info("이미지 경로 : " + imagePath);
	    model.addAttribute("imagePath", imagePath); // JSP로 경로 전달
		} else {
			log.info("attachVO is null");
		}
	}
	
	// 게시글 번호를 전송받아 상세 게시글 조회
	// 조회된 게시글 데이터를 modify.jsp로 전송
	@GetMapping("/modify")
	public void modifyGET(Model model, Integer recipeId) {
		log.info("modifyGET()");
		RecipeVO recipeVO = recipeService.getBoardById(recipeId);
		model.addAttribute("recipeVO", recipeVO);
		List<AttachVO> attachVO = attachService.getAttachById(recipeId);
		if(attachVO != null  && !attachVO.isEmpty()) {
		model.addAttribute("idList", attachVO);
		}
	}
	
	// modify.jsp에서 데이터를 전송받아 게시글 수정
	@PostMapping("/modify")
	public String modifyPOST(RecipeVO recipeVO) {
		log.info("modifyPOST()");
		log.info(recipeVO);
		int result = recipeService.updateBoard(recipeVO);
		log.info(result + "행 수정");
		return "redirect:/recipe/detail?recipeId=" + recipeVO.getRecipeId();
	}
	
	   // detail.jsp에서 boardId를 전송받아 게시글 데이터 삭제
	   @PostMapping("/delete")
	   public String delete(Integer recipeId) {
	      log.info("delete()");
	      List<RecipeReplyVO> replyList = recipeReplyService.getAllReply(recipeId);
	      log.info("댓글 목록 : " + replyList);
	      for(RecipeReplyVO reVO : replyList) {
	    	  List<RecipeCommentVO> commentList = recipeCommentService.getAllComment(reVO.getReplyId());
	    	  log.info("대댓글 목록 : " + commentList);
	    	  for(RecipeCommentVO coVO : commentList) {
	    		  int result = recipeCommentService.deleteComment(coVO.getRecipeCommentId(), coVO.getRecipeReplyId());
	    		  log.info(coVO);
	    		  log.info(result + "행 대댓글 삭제");
	    	  }
	    	  log.info(reVO);
	    	  int result = recipeReplyService.deleteReply(reVO.getReplyId(), reVO.getBoardId());
	    	  log.info(result + "행 댓글 삭제");
	      }
	      int result = recipeService.deleteBoard(recipeId);
	      log.info(result + "행 삭제");
	      return "redirect:/recipe/list";
	   }
}
