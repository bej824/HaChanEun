package com.food.searcher.controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;

import com.food.searcher.domain.MarketVO;

import lombok.extern.log4j.Log4j;

@Controller
@RequestMapping(value="/market")
@Log4j
public class FileUploadController {
	
	@Autowired
	private String uploadPath; // Bean으로 설정된 uploadPath() 객체 주입

	// 이미지 출력
		@GetMapping("/display")
		public ResponseEntity<byte[]> getImage(String fileName) {
			
			log.info("getImage()........." + fileName);
			
			File file = new File("c:\\upload\\" + fileName);
			
			ResponseEntity<byte[]> result = null;
			
			try {
				
				HttpHeaders header = new HttpHeaders();
				
				header.add("Content-type", Files.probeContentType(file.toPath()));
				
				result = new ResponseEntity<>(FileCopyUtils.copyToByteArray(file), header, HttpStatus.OK);
				
			} catch (IOException e) {
				e.printStackTrace();
			}
			
			return result;
		}
		
		// http://localhost:8080/searcher/market/display?fileName=ham.jpg
		
		
		// 단일 파일 업로드 수신 및 파일 저장
		@PostMapping("/upload")
		public void uploadPOST(MultipartFile file) { // 전송된 파일 객체 저장
			log.info("uploadPost()");
			log.info("파일 이름 : " + file.getOriginalFilename());
			log.info("파일 크기 : " + file.getSize());
			
			// File 객체에 파일 경로 및 파일명 설정
			File savedFile = new File(uploadPath, file.getOriginalFilename());
			try {
				file.transferTo(savedFile); // 실제 경로에 파일 저장
			} catch (Exception e) {
				log.error(e.getMessage());
			} 
		} // end uploadPOST()
		
	
	// 다중 파일 업로드 수신 및 파일들 저장
	@PostMapping("/uploads")
	public void uploadsPost(MarketVO marketVO, MultipartFile[] files) { // 배열에 전송된 파일들 적용
		for(MultipartFile file : files) {
			log.info(file.getOriginalFilename());
			
			String fileName = UUID.randomUUID().toString() + "_" + file.getOriginalFilename();
			File savedFile = new File(uploadPath, fileName);
			
		    marketVO.setFileName(fileName); // 파일 이름
		    marketVO.setFilePath(uploadPath); // 파일 경로
			try {
				file.transferTo(savedFile); // 실제 경로에 파일 저장
			} catch (Exception e) {
				log.error(e.getMessage());
			} 
		}
	} // end uploadsPost()
	
}






