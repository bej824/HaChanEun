package com.food.searcher.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.food.searcher.domain.RoleVO;
import com.food.searcher.persistence.RoleMapper;

import lombok.extern.log4j.Log4j;

@Service
@Log4j
public class RoleServiceImple implements RoleService {
	
	@Autowired
	RoleMapper roleMapper;
	
	@Override
	public int insertRole(String memberId) {
		log.info("insertRole()");
		return roleMapper.insertRole(memberId);
	}
	
	@Override
	public RoleVO selectRole(String memberId) {
		log.info("selectRole()");
		return roleMapper.selectRoleByMemberId(memberId);
	}
	
	@Override
	public int updateRole(String memberId, String roleName) {
		log.info("updateRole");
		return roleMapper.updateRoleByMemberId(memberId, roleName);
	}

}
