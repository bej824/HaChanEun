package com.food.searcher.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import lombok.extern.log4j.Log4j;

@Log4j
@Service
public class SellerServiceImple implements SellerService {
	
	@Autowired
	AdminService adminService;
	
	@Override
	public int SellerCreate(String memberId) {
		String RoleName = "ROLE_SELLER";
		
		return adminService.createRole(memberId, RoleName);
	}

}
