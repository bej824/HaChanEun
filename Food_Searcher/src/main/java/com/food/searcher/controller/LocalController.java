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

	@GetMapping("/map")
	public void mapGET(Model model, @RequestParam(value = "localLocal", required = false) String localLocal,
			@RequestParam(value = "localDistrict", required = false) String localDistrict) {
		log.info("mapGET()");
		
		log.info("localLocal = " + localLocal + ", localDistrict = " + localDistrict);
		List<LocalSpecialityVO> specialityList = localService.getAllSpeciality(localLocal, localDistrict);
		
		model.addAttribute("specialityList", specialityList);
		model.addAttribute("localLocal", localLocal);
		model.addAttribute("localDistrict", localDistrict);
	}
	
	@GetMapping("register")
	public void registerSpecialityGET(){
		log.info("registerSpecialityGET()");
		
	}
	
	@Transactional
	@ResponseBody
	@PostMapping("createSpeciality")
	public int createSpecialityPOST(LocalSpecialityVO localSpecialityVO) {
		log.info("createSpecialityPOST()");
		log.info("등록할 특산품 : " + localSpecialityVO);
		int result = localService.createSpeciality(localSpecialityVO);
		
		return result;
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
	
	@ResponseBody
	@GetMapping("listDistrict")
	public List<String> localDistrictGET(@RequestParam("localLocal") String localLocal) {
		log.info("localDistrictGET()");
		List<String> districtList = localService.getDistrictByLocal(localLocal);
		log.info(districtList);
		
		return districtList;
	}
	
	@Transactional
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
	public void localDetailGET(@RequestParam("localId") int localId,
			@RequestParam(value = "localLocal", required = false) String localLocal,
			@RequestParam(value = "localDistrict", required = false) String localDistrict,
			Principal principal, Model model, LocalSpecialityVO localSpecialityVO) {
		log.info("localDetailGET()");
		log.info("localLocal = " + localLocal + ", localDistrict = " + localDistrict);
		
		String memberId = null;
		try {
			memberId = principal.getName();
		} catch (Exception e) {
		}
		
		Map<String, Object> result = localService.getSpecialityByLocalId(localId, memberId);
		localSpecialityVO = (LocalSpecialityVO) result.get("localSpecialityVO");
		
		if(memberId != null) {
			Integer memberLike = (Integer) result.get("memberLike");
			log.info(memberLike);
		}

		model.addAttribute("localSpecialityVO", localSpecialityVO);
		model.addAttribute("localLocal", localLocal);
		model.addAttribute("localDistrict", localDistrict);
	}

}