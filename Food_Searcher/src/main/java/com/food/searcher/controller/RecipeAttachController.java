package com.food.searcher.controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.food.searcher.domain.AttachVO;
import com.food.searcher.domain.RecipeVO;
import com.food.searcher.service.AttachService;
import com.food.searcher.util.FileUploadUtil;

import lombok.extern.log4j.Log4j;

@RestController
@RequestMapping(value = "/attach")
@Log4j
public class RecipeAttachController {
    @Autowired
    private String uploadPath;
    
    @Autowired
    private AttachService attachService;

    // 첨부 파일 생성 
	@PostMapping
	public ResponseEntity<ArrayList<AttachVO>> createAttach(RecipeVO recipeVO, MultipartFile[] files) {
		log.info("createAttach");
		log.info(files);

		ArrayList<AttachVO> list = new ArrayList<>();
		log.info(list);

		for (MultipartFile file : files) {

			// UUID 생성
			String chgName = UUID.randomUUID().toString();
			// 파일 저장
			FileUploadUtil.saveFile(uploadPath, file, chgName);

			String path = FileUploadUtil.makeDatePath();
			String extension = FileUploadUtil.subStrExtension(file.getOriginalFilename());

			AttachVO attachVO = new AttachVO();
			log.info(attachVO);
			// 파일 경로 설정
			attachVO.setAttachPath(path);
			log.info(attachVO);
			// 파일 실제 이름 설정
			attachVO.setAttachRealName(FileUploadUtil.subStrName(file.getOriginalFilename()));
			log.info(attachVO);
			// 파일 변경 이름(UUID) 설정
			attachVO.setAttachChgName(chgName);
			log.info(attachVO);
			// 파일 확장자 설정
			attachVO.setAttachExtension(extension);
			
			log.info(attachVO);
			list.add(attachVO);
		}

		return new ResponseEntity<ArrayList<AttachVO>>(list, HttpStatus.OK);
	}
	
    // 첨부 파일 다운로드(GET)
    @GetMapping(value = "/download", produces = MediaType.APPLICATION_OCTET_STREAM_VALUE)
    public ResponseEntity<Resource> download(int attachId) throws IOException {
        log.info("download()");
        
        // attachId로 상세 정보 조회
        AttachVO attachVO =  attachService.getAttachById(attachId);
        String attachPath = attachVO.getAttachPath();
        String attachChgName = attachVO.getAttachChgName();
        String attachExtension = attachVO.getAttachExtension();
        String attachRealName = attachVO.getAttachRealName();
        log.info(attachVO);
        
        // 서버에 저장된 파일 정보 생성
        String resourcePath = uploadPath + File.separator + attachPath + File.separator + attachChgName;
        log.info(resourcePath);
        // 파일 리소스 생성
        Resource resource = new FileSystemResource(resourcePath);
        log.info(resource);
        // 다운로드할 파일 이름을 헤더에 설정
        HttpHeaders headers = new HttpHeaders();
        String attachName = new String(attachRealName.getBytes("UTF-8"), "ISO-8859-1");
        log.info(attachName);
        headers.add(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=" + attachName + "." + attachExtension);

        // 파일을 클라이언트로 전송
        return new ResponseEntity<Resource>(resource, headers, HttpStatus.OK);
    } // end download()

	// 첨부 파일 삭제
    @PostMapping("/delete")
    public ResponseEntity<Integer> deleteAttach(String attachPath, String attachChgName) {
    	log.info("deleteAttach()");
    	FileUploadUtil.deleteFile(uploadPath, attachPath, attachChgName);
    	
    	return new ResponseEntity<Integer>(1, HttpStatus.OK);
    }
    
}
