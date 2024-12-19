package com.food.searcher.service;

import java.util.List;

import com.food.searcher.domain.RoleVO;

public interface RoleService {
	
	int insertRole(String memberId);
	RoleVO selectRole(String memberId);
	int updateRole(String memberId, String roleName);
}
