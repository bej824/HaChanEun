package com.food.searcher.controller;

import java.security.Principal;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.food.searcher.domain.AskVO;
import com.food.searcher.service.AskService;

import lombok.extern.log4j.Log4j;

@RestController
@RequestMapping("/ask")
@Log4j

public class AskController {
	
	@Autowired
	private AskService askService;
	
	@GetMapping("/list/{itemId}")
	public ResponseEntity<List<AskVO>> askGET(@PathVariable("itemId") long itemId, Model model)	{
		List<AskVO> askVO = askService.getAsk(itemId);
		model.addAttribute("askVO", askVO);
		
		return new ResponseEntity<List<AskVO>>(askVO, HttpStatus.OK);
	}
	
	@GetMapping("/register")
	public void register() {
	}
	
	@PostMapping
	public ResponseEntity<String> askPOST(@RequestBody AskVO askVO, Principal principal) {
		log.info("askPOST()");
		HttpHeaders resHeaders = new HttpHeaders();
        resHeaders.add("Content-Type", "application/json;charset=UTF-8");
	    askVO.setMemberId(principal.getName());
	        // 오늘 이미 해당 상품에 대한 문의를 작성했는지 확인
	        boolean canWrite = askService.canWriteAsk(askVO.getMemberId(), askVO.getItemId());
	        
	        if (!canWrite) {
	        	log.info("400 return");
	            return ResponseEntity.badRequest().body("문의는 하루에 한 번만 작성 가능합니다.");
	        }
	        // 문의 등록
	        askService.createAsk(askVO);
	        log.info("200 return");
	        return ResponseEntity.ok("문의가 등록되었습니다.");
	        
	    }
	
	@PutMapping("/{askId}")
	public ResponseEntity<Integer> modifyPOST(@PathVariable("askId") long askId, 
											  @RequestBody String askContent) {

		return new ResponseEntity<Integer>(askService.updateAsk(askId, askContent), HttpStatus.OK);
	}
	
	@DeleteMapping("/delete/{askId}") 
	   public ResponseEntity<Integer> deleteReply(
			   @PathVariable("askId") long askId) {
	      log.info("deleteReply()");
	      log.info("askId : " + askId);
	      
	      int result = askService.deleteAsk(askId);
	      
	      return new ResponseEntity<Integer>(result, HttpStatus.OK);
	   } // 댓글 삭제
	
	
} // end controller
