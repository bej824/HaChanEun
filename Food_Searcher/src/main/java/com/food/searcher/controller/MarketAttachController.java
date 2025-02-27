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
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.food.searcher.domain.MarketAttachVO;
import com.food.searcher.domain.MarketVO;
import com.food.searcher.service.MarketAttachService;
import com.food.searcher.service.MarketService;
import com.food.searcher.util.FileUploadUtil;

import lombok.extern.log4j.Log4j;

@RestController
@RequestMapping(value = "/imaged")
@Log4j

public class MarketAttachController {
	 @Autowired
	 private String uploadPath;
	   
	 @Autowired
	 private MarketService marketService;
	 
	 @Autowired
	 private MarketAttachService attachService;
	    
	 @PostMapping(value="/uploadImg")
	 public ResponseEntity<List<MarketAttachVO>> createImage(@ModelAttribute MarketVO marketVO, MultipartFile[] files) {
		 // 반환 타입이 ResponseEntity인 객체이며, Http의 Body에 추가될 데이터는 List<MarketAttachVO> 이다.
		 
		log.info("createImage()");
		List<MarketAttachVO> list = new ArrayList<>();
		log.info("arraylist : " + list);
		
		
		for (MultipartFile file : files) {
				log.info(files);
				
				// UUID 생성
				String chgName = UUID.randomUUID().toString();
				// 파일 저장
				FileUploadUtil.saveFile(uploadPath, file, chgName);

				String path = FileUploadUtil.makeDatePath();
				String extension = FileUploadUtil.subStrExtension(file.getOriginalFilename());

				FileUploadUtil.createThumbnail(uploadPath, path, chgName, extension);

				MarketAttachVO attachVO = new MarketAttachVO();
				log.info("attachVO : " + attachVO);
				// 파일 경로 설정
				attachVO.setAttachPath(path);
				// 파일 실제 이름 설정
				attachVO.setAttachRealName(FileUploadUtil.subStrName(file.getOriginalFilename()));
				// 파일 변경 이름(UUID) 설정
				attachVO.setAttachChgName(chgName);
				// 파일 확장자 설정
				attachVO.setAttachExtension(extension);
				list.add(attachVO);
			
				attachService.createAttach(attachVO);
				log.info(attachService.createAttach(attachVO) + "행 등록 (attachService)");
				
				log.info("attachVO : " + attachVO);
			} // for
		
		ResponseEntity<List<MarketAttachVO>> result = new ResponseEntity<List<MarketAttachVO>>(list, HttpStatus.OK);
		return result;
		}
	 
		
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
		public ResponseEntity<byte[]> getImage(int attachId, String attachExtension) {
			log.info("getImage()");
			
			MarketAttachVO attachVO = attachService.getAttachById(attachId);
			ResponseEntity<byte[]> entity = null;
			try {
				// 파일을 읽어와서 byte 배열로 변환
				String savedPath = uploadPath + File.separator 
						+ attachVO.getAttachPath() + File.separator; 

				if(attachExtension != null) {
					savedPath += "t_" + attachVO.getAttachChgName() + "." + attachVO.getAttachExtension();					
				} else {
					savedPath += attachVO.getAttachChgName();
				}
				Path path = Paths.get(savedPath);
				byte[] imageBytes = Files.readAllBytes(path);


				Path extensionPath = Paths.get("." + attachVO.getAttachExtension());
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
		
	    
}
