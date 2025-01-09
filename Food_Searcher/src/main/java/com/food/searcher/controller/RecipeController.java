package com.food.searcher.controller;

import java.util.ArrayList;
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
	@PostMapping("/modify")
	public String modifyPOST(RecipeVO recipeVO, 
	                         @RequestParam("file") List<MultipartFile> files,
	                         @RequestParam(name = "deleteFiles", required = false) List<String> deleteFileIds, 
	                         Integer recipeId) {
	    log.info("modifyPOST()");
	    log.info("recipeVO = " + recipeVO);
	    log.info("deleteFileIds = " + deleteFileIds); // 삭제할 파일 ID들이 리스트로 전달됨

	    // 삭제할 파일 IDs가 있으면 Integer로 변환
	    List<Integer> deleteIds = new ArrayList<>();
	    if (deleteFileIds != null && !deleteFileIds.isEmpty()) {
	        for (String id : deleteFileIds) {
	            try {
	                log.info("id : " + id); // 삭제할 ID 로그 출력
	                deleteIds.add(Integer.parseInt(id)); // String을 Integer로 변환
	            } catch (NumberFormatException e) {
	                log.error("잘못된 파일 ID 형식: " + id, e);
	            }
	        }
	    }

	    // 1. 게시글 수정 처리
	    int result = recipeService.updateBoard(recipeVO);
	    log.info(result + "행 수정");

	    // 2. 파일 삭제 처리 (삭제할 파일이 있을 경우)
	    if (!deleteIds.isEmpty()) {
	        // 선택된 파일 삭제 처리
	        for (Integer attachId : deleteIds) {
	        	log.info("attachId : " + attachId);
	            List<AttachVO> attach = attachService.getAttachById(attachId); // 파일 ID로 파일 정보 가져오기
	            if (attach != null) {
	                log.info("삭제할 파일 : " + attach);
	                String path = attach.get(0).getAttachPath();
	                String chgName = attach.get(0).getAttachChgName();
	                // 서버에서 파일 삭제
	                FileUploadUtil.deleteFile(uploadPath, path, chgName);
	                // DB에서 파일 정보 삭제
	                attachService.deleteAttach(attachId);
	                log.info("파일 삭제 완료 : " + attachId);
	            }
	        }
	    } else {
	        log.info("삭제할 파일이 선택되지 않았습니다.");
	    }

	    // 3. 새 파일 업로드 처리 (파일이 업로드된 경우에만)
	    if (files != null && !files.isEmpty()) {
	        for (MultipartFile file : files) {
	            if (!file.isEmpty()) {
	                String chgName = UUID.randomUUID().toString() + "." + FileUploadUtil.subStrExtension(file.getOriginalFilename());
	                log.info("chgName : " + chgName);

	                // 파일 서버에 저장
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
	        }
	    }

	    // 4. 수정된 게시글 상세 페이지로 리디렉션
	    return "redirect:/recipe/detail?recipeId=" + recipeVO.getRecipeId();
	}

	   // detail.jsp에서 boardId를 전송받아 게시글 데이터 삭제
	@PostMapping("/delete")
	public String delete(Integer recipeId) {
	    log.info("delete()");

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
