package com.food.searcher.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.food.searcher.service.AdminService;

import lombok.extern.log4j.Log4j;

@Controller
@RequestMapping("/admin")
@Log4j
public class AdminController {
	
	@Autowired
	AdminService adminService;
	
	@GetMapping("/adminPage")
	public void adminPageGET(Model model) {
		log.info("adminPageGET()");

	} // end adminGET()
	
	@ResponseBody
	@PostMapping("/roleUpdate")
	public int roleUpdatePOST(@RequestParam("memberId") String memberId) {
		log.info("roleUpdate");
		String roleName = "ROLE_ADMIN";
		int result = adminService.createRole(memberId, roleName);
		
		return result;
	} // end roleUpdatePOST

}
