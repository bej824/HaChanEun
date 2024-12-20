package com.food.searcher.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.sql.Date;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.food.searcher.domain.HeaderReplyVO;
import com.food.searcher.domain.LocalReplyVO;
import com.food.searcher.domain.LocalSpecialityVO;
import com.food.searcher.domain.RecipeCommentVO;
import com.food.searcher.domain.RecipeVO;
import com.food.searcher.domain.RoleVO;
import com.food.searcher.service.LocalReplyService;
import com.food.searcher.service.LocalService;
import com.food.searcher.service.RoleService;
import com.food.searcher.util.PageMaker;
import com.food.searcher.util.Pagination;

import lombok.extern.log4j.Log4j;

@Controller
@RequestMapping("/local")
@Log4j
public class LocalController {
	
	@Autowired
	private LocalService localService;
	
	@Autowired
	private RoleService RoleService;
	
	@Autowired
	private LocalReplyService LocalReplyService;
	
	
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
	
	@PostMapping("update")
	public String localUpdatePOST(@RequestParam("Id") String localId,
			@RequestParam("localContent") String localContent,
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
			HttpSession session, Model model) {
		log.info("localDetailGET()");
		LocalSpecialityVO LocalSpecialityVO= localService.getSpecialityByLocalId(localId);
		log.info(LocalSpecialityVO);
		
		String memberId = (String) session.getAttribute("memberId");
		try {
			RoleVO roleVO = RoleService.selectRole(memberId);
			log.info(roleVO.getRoleName());
			if(roleVO.getRoleName().equals("admin")) {
				model.addAttribute("roleName",roleVO.getRoleName());
			}
		} catch (Exception e) {

		}
		
		model.addAttribute("LocalSpecialityVO", LocalSpecialityVO);
	}
	
	@ResponseBody
	@PostMapping("/replyAdd")
	public void replyAddPOST(@RequestBody HeaderReplyVO headerReplyVO,
			HttpSession session)
			throws ServletException, IOException {
		log.info("replyAddPOST()");
		log.info(headerReplyVO);
		String memberId = (String) session.getAttribute("memberId");
		
	}
	
	@ResponseBody
	@GetMapping("/replyAll")
	public List<LocalReplyVO> replyAllGET(@RequestParam("localId") int localId) {
		log.info("replyAllGET()");
		List<LocalReplyVO> list = LocalReplyService.getAllReply(localId);
		
		return list;
	}
	
}
