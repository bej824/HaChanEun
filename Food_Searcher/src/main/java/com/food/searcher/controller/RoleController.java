package com.food.searcher.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.food.searcher.domain.RoleVO;
import com.food.searcher.service.RoleService;

import lombok.extern.log4j.Log4j;

@Controller
@RequestMapping("/access")
@Log4j
public class RoleController {
	
	@Autowired
	private RoleService RoleService;
	
	@GetMapping("/admin")
	public String adminGET(HttpSession session, Model model) {
		log.info("adminGET()");
		String memberId = (String) session.getAttribute("memberId");
		try {
			RoleVO roleVO = RoleService.selectRole(memberId);
			log.info(roleVO);
			log.info("권한 : " + roleVO.getRoleName());
			if(roleVO.getRoleName().equals("ROLE_ADMIN")) {
				model.addAttribute(roleVO);
				return "access/admin";
			} else {
				return "redirect:/home";
			}
			
		} catch (Exception e) {
			return "redirect:/home";
		}

	} // end adminGET()
	
	@PostMapping("/roleUpdate")
	public String roleUpdatePOST(@RequestParam("memberId") String memberId) {
		log.info("roleUpdate");
		String roleName = "ROLE_ADMIN";
		int result = RoleService.updateRole(memberId, roleName);
		log.info(result + "행 수정");
		
		return "../home";
	} // end roleUpdatePOST

}
