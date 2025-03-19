package com.food.searcher.controller;
import java.security.Principal;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.food.searcher.domain.LocalSpecialityVO;
import com.food.searcher.service.LocalService;

import lombok.extern.log4j.Log4j;

@Controller
@RequestMapping("/local")
@Log4j
public class LocalController {

	@Autowired
	private LocalService localService;

	@GetMapping("/list")
	public void listGET(Model model, 
			@RequestParam(value = "localLocal", required = false) String localLocal,
			@RequestParam(value = "localDistrict", required = false) String localDistrict,
			@RequestParam(value = "localTitle", required = false) String localTitle,
			@RequestParam(value = "mainCtg", required = false) String mianCtg) {
		log.info("listGET()");
		
		model.addAttribute("localLocal", localLocal);
		model.addAttribute("localDistrict", localDistrict);
		model.addAttribute("localTitle", localTitle);
		model.addAttribute("mainCtg", mianCtg);
	}
	
	@GetMapping("register")
	public void registerSpecialityGET(){
		log.info("registerSpecialityGET()");
	}
	
	@ResponseBody
	@PostMapping("register")
	public int registerSpecialityPOST(LocalSpecialityVO localSpecialityVO) {
		log.info("registerSpecialityPOST()");
		log.info("등록할 특산품 : " + localSpecialityVO);
		int result = localService.createSpeciality(localSpecialityVO);
		
		return result;
	}
	
	@ResponseBody
	@GetMapping("localUpdate")
	public List<LocalSpecialityVO> localUpdateGET(LocalSpecialityVO localSpecialityVO) {
		log.info("localUpdateGET()");
		
		List<LocalSpecialityVO> SpecialityList = 
				localService.getAllSpeciality(localSpecialityVO);
		return SpecialityList;
	}
	
	@ResponseBody
	@GetMapping("listDistrict")
	public List<String> localDistrictGET(@RequestParam("localLocal") String localLocal) {
		log.info("localDistrictGET()");
		List<String> districtList = localService.getDistrictByLocal(localLocal);
		log.info(districtList);
		
		return districtList;
	}
	
	@ResponseBody
	@PostMapping("update")
	public int localUpdatePOST(LocalSpecialityVO localSpecialityVO) {
		log.info("localUpdatePOST()");

		return localService.updateSpeciality(localSpecialityVO);
	}
	
	@GetMapping("/detail")
	public void localDetailGET(
			@RequestParam("localId") int localId,
			@RequestParam(value = "localLocal", required = false) String localLocal,
			@RequestParam(value = "localDistrict", required = false) String localDistrict,
			@RequestParam(value = "localTitle", required = false) String localTitle,
			@RequestParam(value = "mainCtg", required = false) String mainCtg,
			Model model, LocalSpecialityVO localSpecialityVO) {
		log.info("localDetailGET()");
		
		localSpecialityVO = localService.getSpecialityByLocalId(localId);

		model.addAttribute("localSpecialityVO", localSpecialityVO);
		model.addAttribute("localLocal", localLocal);
		model.addAttribute("localDistrict", localDistrict);
		model.addAttribute("localTitle", localTitle);
	}
	
	@GetMapping("modify")
	public void modifyGET(@RequestParam("localId") int localId,
			Map<String, Object> result, LocalSpecialityVO localSpecialityVO, Model model) {
		log.info("modifyGET()");
		
		localSpecialityVO = localService.getSpecialityByLocalId(localId);
		
		model.addAttribute("localSpecialityVO", localSpecialityVO);
	}

}