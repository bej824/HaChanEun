package com.food.searcher.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.food.searcher.domain.ItemVO;
import com.food.searcher.service.AdminService;

import lombok.extern.log4j.Log4j;

@Controller
@RequestMapping("/admin")
@Log4j
public class AdminController {
	
	@Autowired
	AdminService adminService;
	
	@GetMapping("/adminPage")
	public void adminPageGET() {
		log.info("adminPageGET()");

	}
	
	@GetMapping("/itemManagement")
	public void itemManagementGET() {
		log.info("itemManagementGET()");
	}
	
	@ResponseBody
	@GetMapping("/itemList")
	public List<ItemVO> itemListGET() {
		log.info("itemListGET()");
		
		return adminService.itemGetAll();
	}
	
	@ResponseBody
	@PostMapping("/roleUpdate")
	public int roleUpdatePOST(
					 @RequestParam("memberId") String memberId
					,@RequestParam("roleName") String roleName) {
		log.info("roleUpdatePOST()");
		
		return adminService.createRole(memberId, roleName);
	} // end roleUpdatePOST

}
