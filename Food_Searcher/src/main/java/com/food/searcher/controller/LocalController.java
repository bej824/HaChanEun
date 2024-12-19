package com.food.searcher.controller;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.util.List;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

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
	public void mapGET(Model model) {
		log.info("mapGET()");
		String localLocal = null;
		String localDistrict = null;
		List<LocalSpecialityVO> SpecialityList = localService.getAllSpeciality(localLocal, localDistrict);
		
		model.addAttribute("SpecialityList", SpecialityList);
		
	}
	  
	@ResponseBody
	@GetMapping("listDistrict")
	public String[] localDistrictGET(@RequestParam("localLocal") String localLocal) {
		log.info("localDistrictGET()");
		List<LocalSpecialityVO> SpecialityList = localService.getDistrictByLocal(localLocal);
		String[] districtList = new String[SpecialityList.size()];
		for(int i = 0; i < SpecialityList.size(); i++) {
			districtList[i] = SpecialityList.get(i).getLocalDistrict();
		}
		
		return districtList;
	}
	
	@ResponseBody
	@GetMapping("localUpdate")
	public List<LocalSpecialityVO> localUpdateGET(@RequestParam("localLocal") String localLocal,
			@RequestParam("localDistrict") String localDistrict)  {
		log.info("localUpdateGET()");
		List<LocalSpecialityVO> SpecialityList = localService.getAllSpeciality(localLocal, localDistrict);
		
		return SpecialityList;
	}
	
	@GetMapping("/detail")
	public void localDetailGET(@RequestParam("localId") String localId,
			HttpSession session, Model model) {
		log.info("localDetailGET()");
		LocalSpecialityVO LocalSpecialityVO= localService.getSpecialityByLocalId(localId);
		log.info(LocalSpecialityVO);
		model.addAttribute("LocalSpecialityVO", LocalSpecialityVO);
	}
	
}
