package com.food.searcher.controller;

import java.util.ArrayList;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.food.searcher.domain.MarketAttachVO;
import com.food.searcher.service.MarketAttachService;
import com.food.searcher.util.FileUploadUtil;

import lombok.extern.log4j.Log4j;

@RestController
@RequestMapping(value = "/images")
@Log4j

public class MarketAttachController {
	 @Autowired
	    private String uploadPath;
	    
	    @Autowired
	    private MarketAttachService attachService;
	    
	    @PostMapping
		public ResponseEntity<ArrayList<MarketAttachVO>> createImage(MultipartFile[] files) {
			log.info("createImage()");

			ArrayList<MarketAttachVO> list = new ArrayList<>();

			for (MultipartFile file : files) {

				// UUID 생성
				String chgName = UUID.randomUUID().toString();
				// 파일 저장
				FileUploadUtil.saveFile(uploadPath, file, chgName);

				String path = FileUploadUtil.makeDatePath();
				String extension = FileUploadUtil.subStrExtension(file.getOriginalFilename());

				FileUploadUtil.createThumbnail(uploadPath, path, chgName, extension);

				MarketAttachVO attachVO = new MarketAttachVO();
				// 파일 경로 설정
				attachVO.setAttachPath(path);
				// 파일 실제 이름 설정
				attachVO.setAttachRealName(FileUploadUtil.subStrName(file.getOriginalFilename()));
				// 파일 변경 이름(UUID) 설정
				attachVO.setAttachChgName(chgName);
				// 파일 확장자 설정
				attachVO.setAttachExtension(extension);

				list.add(attachVO);
			}

			return new ResponseEntity<ArrayList<MarketAttachVO>>(list, HttpStatus.OK);
		}
		
	    
	    
}
