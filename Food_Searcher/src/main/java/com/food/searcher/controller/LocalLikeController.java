package com.food.searcher.controller;

import java.security.Principal;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.food.searcher.service.LocalLikesService;

import lombok.extern.log4j.Log4j;

@Controller
@RequestMapping("/local")
@Log4j
public class LocalLikeController {
	
	@Autowired
	LocalLikesService localLikesService;
	
	@ResponseBody
	@GetMapping("/likeCount")
	public Map<String, Object> likeCountGET(@RequestParam("localId") int localId) {
		log.info("likeCountGET()");
		
		Map<String, Object> likesCount = localLikesService.selectLikesByLocalId(localId);
		
		Map<String, Object> result = new HashMap<>();
		result.put("likeCount", (likesCount.getOrDefault("LIKECOUNT", 0)));
		result.put("dislikeCount", (likesCount.getOrDefault("DISLIKECOUNT", 0)));

		
		return result;
	}
	
	@PostMapping("likeUpdate")
	public int likeUpdatePOST(int localId, int memberLike, Principal principal) {
		log.info("likeUpdatePOST()");
		String memberId = principal.getName();
		
		int result = localLikesService.updateLikes(localId, memberId, memberLike);
		
		return result;
	}

}
