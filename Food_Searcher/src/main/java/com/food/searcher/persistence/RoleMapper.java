package com.food.searcher.persistence;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.web.bind.annotation.RequestParam;

import com.food.searcher.domain.RoleVO;

public interface RoleMapper {
	
	int insertRole(@RequestParam("memberId") String memberId);
	RoleVO selectRoleByMemberId(@RequestParam("memberId") String memberId);
	int updateRoleByMemberId(@RequestParam("memberId") String memberId, @RequestParam("roleName") String roleName);

}
