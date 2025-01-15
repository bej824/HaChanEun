package com.food.searcher.controller;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
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

	@GetMapping("/map")
	public void mapGET(Model model, @RequestParam(value = "localLocal", required = false) String localLocal,
			@RequestParam(value = "localDistrict", required = false) String localDistrict) {
		log.info("mapGET()");
		
		log.info("localLocal = " + localLocal + ", localDistrict = " + localDistrict);
		List<LocalSpecialityVO> SpecialityList = localService.getAllSpeciality(localLocal, localDistrict);
		
		model.addAttribute("SpecialityList", SpecialityList);
		model.addAttribute("localLocal", localLocal);
		model.addAttribute("localDistrict", localDistrict);
	}

	@ResponseBody
	@GetMapping("localUpdate")
	public List<LocalSpecialityVO> localUpdateGET(@RequestParam("localLocal") String localLocal,
			@RequestParam("localDistrict") String localDistrict) {
		log.info("localUpdateGET()");
		
		log.info(localLocal + " " + localDistrict);
		List<LocalSpecialityVO> SpecialityList = localService.getAllSpeciality(localLocal, localDistrict);

		return SpecialityList;
	}

	@PostMapping("update")
	public String localUpdatePOST(@RequestParam("Id") String localId, @RequestParam("localContent") String localContent,
			LocalSpecialityVO localSpecialityVO) {
		log.info("localUpdatePOST()");
		String location = "redirect:detail?localId=" + localId;
		localSpecialityVO = new LocalSpecialityVO(localId, null, null, null, localContent, 0);
		int result = localService.updateSpeciality(localSpecialityVO);
		log.info(result + "행 수정");

		return location;
	}

	@GetMapping("/detail")
	public void localDetailGET(@RequestParam("localId") String localId,
			@RequestParam(value = "localLocal", required = false) String localLocal,
			@RequestParam(value = "localDistrict", required = false) String localDistrict,
			Model model, LocalSpecialityVO localSpecialityVO) {
		log.info("localDetailGET()");
		log.info("localLocal = " + localLocal + ", localDistrict = " + localDistrict);
		localSpecialityVO = localService.getSpecialityByLocalId(localId);
		log.info(localSpecialityVO);
		
		model.addAttribute("LocalSpecialityVO", localSpecialityVO);
		model.addAttribute("localLocal", localLocal);
		model.addAttribute("localDistrict", localDistrict);
	}

}