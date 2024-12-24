package com.food.searcher.controller;

import java.io.File;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
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

	
	// 다중 파일 업로드 수신 및 파일들 저장
	@PostMapping("/uploads")
	public void uploadsPost(MarketVO marketVO, MultipartFile[] files) { // 배열에 전송된 파일들 적용
		for(MultipartFile file : files) {
			log.info(file.getOriginalFilename());
			
			String fileName = UUID.randomUUID().toString() + "_" + file.getOriginalFilename();
			File savedFile = new File(uploadPath, fileName);
			
			try {
				file.transferTo(savedFile); // 실제 경로에 파일 저장
			} catch (Exception e) {
				log.error(e.getMessage());
			} 
		}
	} // end uploadsPost()
	
}






