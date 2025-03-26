package com.food.searcher.util;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.security.core.context.SecurityContextHolder;

import com.food.searcher.domain.DirectOrderVO;

import lombok.extern.log4j.Log4j;

@Log4j
public class OrderUtil {
	
	private Map<String, List<DirectOrderVO>> orderListByMemberId = new HashMap<String, List<DirectOrderVO>>();
	
	public void setOrderList(List<DirectOrderVO> orderList) {
		
		String memberId = "anonymousUser".equals(SecurityContextHolder.getContext().getAuthentication().getName()) 
				? null : SecurityContextHolder.getContext().getAuthentication().getName();
		
		if(memberId != null) {
			if(orderListByMemberId.containsKey(memberId)) {
				orderListByMemberId.remove(memberId);
			}
			orderListByMemberId.put(memberId, orderList);
		} else {
			log.error("로그인하지 않은 사람의 구매 시도");
		}
		
    }
	
	public List<DirectOrderVO> getOrderList() {
		
		String memberId = SecurityContextHolder.getContext().getAuthentication().getName();
		List<DirectOrderVO> orderList = 
				orderListByMemberId.get(memberId);
		orderListByMemberId.remove(memberId);
			
			return orderList;
		}
				
	}
