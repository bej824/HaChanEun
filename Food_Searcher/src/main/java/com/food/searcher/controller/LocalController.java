package com.food.searcher.controller;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.food.searcher.domain.LocalSpecialityVO;
import com.food.searcher.domain.RecipeVO;
import com.food.searcher.service.LocalService;
import com.food.searcher.util.PageMaker;
import com.food.searcher.util.Pagination;

import lombok.extern.log4j.Log4j;

@Controller
@RequestMapping("/local")
@Log4j
public class LocalController {
	
	@Autowired
	private LocalService localService;
	
	
	@GetMapping("/map")
	public void mapGET(Model model, Pagination pagination) {
		log.info("mapGET()");
		log.info("pagination" + pagination);
		List<LocalSpecialityVO> SpecialityList = localService.getAllSpeciality();
		
		PageMaker pageMaker = new PageMaker();
		pageMaker.setPagination(pagination);
		pageMaker.setTotalCount(localService.getTotalCount());
		
		model.addAttribute("pageMaker", pageMaker);
		model.addAttribute("SpecialityList", SpecialityList);
		
	}
	  
	@ResponseBody
	@GetMapping("checkLocal")
	public String checkLocalGET(@RequestParam("local") String local,
			HttpServletResponse response) 
			throws UnsupportedEncodingException {
		log.info("checkLocalGET()");
		String result = local;

		return result;
	}
}
