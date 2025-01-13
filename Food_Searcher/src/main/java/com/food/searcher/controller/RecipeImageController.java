package com.food.searcher.controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
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
@RequestMapping(value = "/image")
@Log4j
public class RecipeImageController {
	
    @Autowired
    private String uploadPath;
    
    @Autowired
    private AttachService attachService;
    

	@PostMapping
	public ResponseEntity<ArrayList<AttachVO>> createImage(RecipeVO recipeVO, MultipartFile[] files) {
		log.info("createImage()");
		log.info(files);
		ArrayList<AttachVO> list = new ArrayList<>();

		for (MultipartFile file : files) {

			// UUID 생성
			String chgName = UUID.randomUUID().toString();
			// 파일 저장
			FileUploadUtil.saveFile(uploadPath, file, chgName);

			String path = FileUploadUtil.makeDatePath();
			String extension = FileUploadUtil.subStrExtension(file.getOriginalFilename());

			FileUploadUtil.createThumbnail(uploadPath, path, chgName, extension);

			AttachVO attachVO = new AttachVO();
			// 파일 경로 설정
			attachVO.setAttachPath(path);
			// 파일 실제 이름 설정
			attachVO.setAttachRealName(FileUploadUtil.subStrName(file.getOriginalFilename()));
			// 파일 변경 이름(UUID) 설정
			attachVO.setAttachChgName(chgName);
			// 파일 확장자 설정
			attachVO.setAttachExtension(extension);
			
			log.info(attachVO);
			list.add(attachVO);
		}
		

		return new ResponseEntity<ArrayList<AttachVO>>(list, HttpStatus.OK);
	}
	
	// 전송받은 파일 경로 및 파일 이름, 확장자로 
	// 이미지 파일을 호출
	@GetMapping("/display")
	public ResponseEntity<byte[]> display(String attachPath, String attachChgName, String attachExtension) {
		log.info("display()");
		ResponseEntity<byte[]> entity = null;
		try {
			// 파일을 읽어와서 byte 배열로 변환
			String savedPath = uploadPath + File.separator 
					+ attachPath + File.separator + attachChgName; 
			if(attachChgName.startsWith("t_")) { // 섬네일 파일에는 확장자 추가
				savedPath += "." + attachExtension;
			}
			Path path = Paths.get(savedPath);
			byte[] imageBytes = Files.readAllBytes(path);


			Path extensionPath = Paths.get("." + attachExtension);
			// 이미지의 MIME 타입 확인하여 적절한 Content-Type 지정
			String contentType = Files.probeContentType(extensionPath);

			// HTTP 응답에 byte 배열과 Content-Type을 설정하여 전송
			HttpHeaders httpHeaders = new HttpHeaders();
			httpHeaders.setContentType(MediaType.parseMediaType(contentType));
			entity = new ResponseEntity<byte[]>(imageBytes, httpHeaders, HttpStatus.OK);
		} catch (IOException e) {
			// 파일을 읽는 중에 예외 발생 시 예외 처리
			e.printStackTrace();
			return ResponseEntity.notFound().build(); // 파일을 찾을 수 없음을 클라이언트에게 알림
		}

		return entity;
	}

	
	
	@GetMapping("/get")
	public ResponseEntity<byte[]> getImage(Integer boardId, Integer attachId, String attachExtension) {
	    log.info("getImage()");
	    log.info("attachId : " + attachId);
	    log.info("boardId : " + boardId);
	    log.info("attachExtension : " + attachExtension);

	    // 파일 정보 조회
	    List<AttachVO> attachList = attachService.getAttachById(attachId);
	    if (attachList.isEmpty()) {
	        return ResponseEntity.notFound().build(); // 파일이 존재하지 않으면 404 반환
	    }
	    log.info("attachList : " + attachList);

	    AttachVO attachVO = attachList.get(0); // 첫 번째 첨부 파일 정보
	    log.info("AttachVO: " + attachVO);
	    
	    // 파일 경로 설정
	    String savedPath = uploadPath + File.separator 
	            + attachVO.getAttachPath() + File.separator;
	    log.info("Saved path: " + savedPath);

	    // 파일 이름과 확장자 처리
	    String fileName = attachVO.getAttachChgName();
	    log.info("fileName : " + fileName);
	    
	    Path path = Paths.get(savedPath, fileName);
	    log.info("path : " + path);

	    // 파일 읽기 및 MIME 타입 처리
	    try {
	        byte[] imageBytes = Files.readAllBytes(path);
	        log.info("imageBytes : " + imageBytes);
	        
	        // MIME 타입 추출
	        String contentType = Files.probeContentType(path);
	        log.info("contentType : " + contentType);
	        if (contentType == null) {
	            // 확장자 기반으로 contentType 설정
	            if (fileName.endsWith(".webp")) {
	                contentType = "image/webp";
	            } else {
	                contentType = "application/octet-stream"; // 기본 타입
	            }
	        }

	        // HTTP 응답 설정
	        HttpHeaders headers = new HttpHeaders();
	        headers.setContentType(MediaType.parseMediaType(contentType));
	        log.info("headers : " + headers);
	        return new ResponseEntity<>(imageBytes, headers, HttpStatus.OK);

	    } catch (IOException e) {
	        log.error("Error reading file", e);
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null); // 파일 읽기 실패 시 500 반환
	    }
	}

	
    // 섬네일 및 원본 이미지 삭제 기능
    @PostMapping("/delete")
    public ResponseEntity<Integer> deleteImage(String attachPath, String attachChgName, String attachExtension) {
    	log.info("deleteAttach()");
    	log.info(attachChgName);
    	FileUploadUtil.deleteFile(uploadPath, attachPath, attachChgName);
    	
    	String thumbnailName = "t_" + attachChgName + "." + attachExtension;
    	FileUploadUtil.deleteFile(uploadPath, attachPath, thumbnailName);
    	
    	return new ResponseEntity<Integer>(1, HttpStatus.OK);
    }

}
