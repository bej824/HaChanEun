package com.food.searcher.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.food.searcher.domain.CtgVO;
import com.food.searcher.service.CtgService;

import lombok.extern.log4j.Log4j;

@RequestMapping("/ctg")
@Controller
@Log4j
public class CtgController {
	
	@Autowired
	private CtgService ctgService;
	
	@ResponseBody
	@GetMapping("ctgGet")
	public List<CtgVO> ctgGET(@RequestParam(value = "url", required = false) String url) {
		
		return ctgService.selectCtg(url);
	}

}
