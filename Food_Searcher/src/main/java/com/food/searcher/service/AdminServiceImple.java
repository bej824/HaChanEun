package com.food.searcher.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.food.searcher.domain.ItemVO;

import lombok.extern.log4j.Log4j;

@Service
@Log4j
public class AdminServiceImple implements AdminService {
	
	@Autowired
	MemberService memberService;
	
	@Autowired
	ItemService itemService;
	
	@Override
	public int createRole(String memberId, String RoleName) {
		log.info("createRole()");
	
		return memberService.createRole(memberId, RoleName);
	}
	
	@Override
	public List<ItemVO> itemGetAll() {
		log.info("itemGetAll()");
		
		return itemService.getAllItem(0);
	}

}
