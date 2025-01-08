package com.food.searcher.controller;

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
	public String registerPOST(RecipeVO recipeVO, @RequestParam("file") List<MultipartFile> files) {
	    log.info("registerPOST()");
	    log.info("recipeVO = " + recipeVO.toString());

	    int result = recipeService.createBoard(recipeVO);
	    log.info(result + "행 등록");

	    // recipeId를 가져옵니다.
	    List<RecipeVO> list = recipeService.getAllBoards();
	    log.info("recipeId 번호 : " + list.get(0).getRecipeId());

	    // 여러 파일을 처리합니다.
	    if (files != null && !files.isEmpty()) {
	        for (MultipartFile file : files) {
	            if (!file.isEmpty()) {
	                // UUID 생성
	                String chgName = UUID.randomUUID().toString() + "." + FileUploadUtil.subStrExtension(file.getOriginalFilename());

	                // 파일 저장
	                FileUploadUtil.saveFile(uploadPath, file, chgName);

	                // AttachVO 객체 생성
	                AttachVO attachVO = new AttachVO();
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
	        }
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
	@PostMapping("/modify") // 멀티 이미지 구현 전 단일 이미지만 등록중
	public String modifyPOST(RecipeVO recipeVO, @RequestParam("file") MultipartFile file, Integer recipeId) {
	    log.info("modifyPOST()");
	    log.info("recipeVO = " + recipeVO);

	    // 1. 게시글 수정 처리
	    int result = recipeService.updateBoard(recipeVO);
	    log.info(result + "행 수정");
	    
	    log.info("file : " + file);

	    // 2. 기존 이미지 삭제 (파일 업로드가 있는 경우)
	    if (file != null && !file.isEmpty()) {
	        List<AttachVO> existingAttachVO = attachService.getBoardById(recipeId);
	        log.info("existingAttachVO : " + existingAttachVO);

	        // 기존 파일 삭제 처리 (기존 파일이 있을 경우)
	        if (existingAttachVO != null && !existingAttachVO.isEmpty()) {
	            for (AttachVO attach : existingAttachVO) {
	            	log.info("attach : " + attach);
	                // 기존 이미지를 서버에서 삭제
	                FileUploadUtil.deleteFile(uploadPath, attach.getAttachPath(), attach.getAttachChgName());
	                // DB에서 기존 파일 정보 삭제
	                attachService.deleteAttach(attach.getAttachId());
	            }
	        }

	        // 새 파일 업로드 처리
	    	String chgName = UUID.randomUUID().toString() + "." + FileUploadUtil.subStrExtension(file.getOriginalFilename()); // 새로운 파일명 생성
	        log.info("chgName : " + chgName);
	        // 파일 저장
            FileUploadUtil.saveFile(uploadPath, file, chgName);

	        // 새 이미지 정보 객체 생성하여 DB에 저장
	        AttachVO attachVO = new AttachVO();
	        attachVO.setBoardId(recipeVO.getRecipeId());
	        attachVO.setAttachPath(FileUploadUtil.makeDatePath()); // 저장 경로 생성
	        attachVO.setAttachRealName(FileUploadUtil.subStrName(file.getOriginalFilename())); // 원본 파일명
	        attachVO.setAttachChgName(chgName); // 변경된 파일명
	        attachVO.setAttachExtension(FileUploadUtil.subStrExtension(file.getOriginalFilename())); // 파일 확장자

	        // DB에 파일 정보 등록
	        int resultImg = attachService.createAttach(attachVO);
	        log.info(resultImg + "행 등록");
	        log.info("새로 업로드된 파일 정보: " + attachVO);

	    }
	    // 3. 수정된 게시글 상세 페이지로 리디렉션
	    return "redirect:/recipe/detail?recipeId=" + recipeVO.getRecipeId();
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
