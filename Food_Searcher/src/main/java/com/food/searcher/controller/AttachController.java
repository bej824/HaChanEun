package com.food.searcher.controller;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.food.searcher.domain.AttachVO;
import com.food.searcher.service.AttachService;
import com.food.searcher.util.FileUploadUtil;

import lombok.extern.log4j.Log4j;

@Controller
@Log4j
public class AttachController {

   @Autowired
   private String uploadPath;

   @Autowired
   private AttachService attachService;

   // 첨부 파일 업로드 페이지 이동(GET)
   @GetMapping("/register")
   public void registerGET() {
      log.info("registerGET()");
   } // end registerGET()

   // 첨부 파일 업로드 처리(POST)
   @PostMapping("/attach")
   public String attachPOST(AttachVO attachVO) {
      log.info("attachPost()");
      log.info("attachDTO = " + attachVO);
      MultipartFile file = attachVO.getFile();

      // UUID 생성
      String chgName = UUID.randomUUID().toString();
      // 파일 저장
      FileUploadUtil.saveFile(uploadPath, file, chgName);

      // 파일 경로 설정
      attachVO.setAttachPath(FileUploadUtil.makeDatePath());
      // 파일 실제 이름 설정
      attachVO.setAttachRealName(FileUploadUtil.subStrName(file.getOriginalFilename()));
      // 파일 변경 이름(UUID) 설정
      attachVO.setAttachChgName(chgName);
      // 파일 확장자 설정
      attachVO.setAttachExtension(FileUploadUtil.subStrExtension(file.getOriginalFilename()));
      // DB에 첨부 파일 정보 저장
      log.info(attachService.createAttach(attachVO) + "행 등록");

      return "redirect:/list";
   } // end attachPOST()
   
    // 첨부 파일 목록 조회(GET)
    @GetMapping("/list")
    public void list(Model model) {
        // 첨부 파일 attachId 리스트를 Model에 추가하여 전달
        model.addAttribute("idList", attachService.getAllId());
        log.info("list()");
    }

    // 첨부 파일 상세 정보 조회(GET)
    @GetMapping("/detail")
    public void detail(int attachId, Model model) {
        log.info("detail()");
        log.info("attachId : " + attachId);
        // attachId로 상세 정보 조회
//        AttachVO attachVO = attachService.getAttachById(attachId);
//        // 조회된 상세 정보를 Model에 추가하여 전달
//        model.addAttribute("attachVO", attachVO);
    } // end detail()
    
    // 첨부 파일 다운로드(GET)
      // 파일을 클릭하면 사용자가 다운로드하는 방식
      // 파일 리소스를 비동기로 전송하여 파일 다운로드
    @GetMapping(value = "/download", produces = MediaType.APPLICATION_OCTET_STREAM_VALUE)
    @ResponseBody
    public ResponseEntity<Resource> download(int attachId) throws IOException {
        log.info("download()");
        
        // attachId로 상세 정보 조회
        List<AttachVO> attachVO = attachService.getAttachById(attachId);
        String attachPath = ((AttachVO) attachVO).getAttachPath();
        String attachChgName = ((AttachVO) attachVO).getAttachChgName();
        String attachExtension = ((AttachVO) attachVO).getAttachExtension();
        String attachRealName = ((AttachVO) attachVO).getAttachRealName();
        
        // 서버에 저장된 파일 정보 생성
        String resourcePath = uploadPath + File.separator + attachPath 
                                    + File.separator + attachChgName;
        // 파일 리소스 생성
        Resource resource = new FileSystemResource(resourcePath);
        // 다운로드할 파일 이름을 헤더에 설정
        HttpHeaders headers = new HttpHeaders();
        String attachName = new String(attachRealName.getBytes("UTF-8"), "ISO-8859-1");
        headers.add(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=" 
              + attachName + "." + attachExtension);

        // 파일을 클라이언트로 전송
        return new ResponseEntity<Resource>(resource, headers, HttpStatus.OK);
    } // end download()


} // end FileUploadController
