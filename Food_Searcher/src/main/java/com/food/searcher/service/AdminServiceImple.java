package com.food.searcher.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import lombok.extern.log4j.Log4j;

@Service
@Log4j
public class AdminServiceImple implements AdminService {
	
	@Autowired
	MemberService memberService;
	
	@Override
	public int createRole(String memberId, String RoleName) {
		log.info("createRole()");
	
		return memberService.createRole(memberId, RoleName);
	}

}
