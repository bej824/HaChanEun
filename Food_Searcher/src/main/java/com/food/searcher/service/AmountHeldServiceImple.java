package com.food.searcher.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.food.searcher.persistence.AmountHeldMapper;

import lombok.extern.log4j.Log4j;

@Service
@Log4j
public class AmountHeldServiceImple implements AmountHeldService {
	
	@Autowired
	AmountHeldMapper amountHeldMapper;
	
	@Autowired
	UtilityService utilityService;
	
	@Transactional
	@Override
	public int amountHeldLog(int amountHeld) {
		
		return updateMemberAmountHeld(amountHeld);
	}
	
	@Override
	public int selectAmountHeld() {
		String memberId = utilityService.loginMember();
		
		return amountHeldMapper.selectMemberAmountHeldByMemberId(
				memberId
				);
	}
	
	@Transactional
	public int updateMemberAmountHeld(int amountHeld) {
		
		String memberId = utilityService.loginMember();
		
		return amountHeldMapper.updateMemberAmountHeld(
				 memberId
				,amountHeld
				);
	}

}
