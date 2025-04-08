package com.food.searcher.util;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

import org.springframework.beans.factory.annotation.Autowired;

import com.food.searcher.domain.DirectOrderVO;
import com.food.searcher.service.ItemService;

import lombok.extern.log4j.Log4j;

@Log4j
public class OrderUtil {
	
	@Autowired
	private ItemService itemService;
	
	private Map<String, List<DirectOrderVO>> orderListByMemberId = new HashMap<String, List<DirectOrderVO>>();
	private static final ScheduledExecutorService scheduler = Executors.newScheduledThreadPool(1);
	
	public void setOrderList(List<DirectOrderVO> orderList, String tid) {
		
			if(orderListByMemberId.containsKey(tid)) {
				orderListByMemberId.remove(tid);
			}
			orderListByMemberId.put(tid, orderList);
			
			scheduler.schedule(() -> {
	            orderTimeLimit(tid);
	        }, 15, TimeUnit.MINUTES);
			
		}
	
	public List<DirectOrderVO> getOrderList(String tid) {
		List<DirectOrderVO> orderList = 
				orderListByMemberId.get(tid);
		orderListByMemberId.remove(tid);
			
			return orderList;
		}
	
	private void orderTimeLimit(String tid) {
		itemService.returnItemAmount(orderListByMemberId.get(tid));
		orderListByMemberId.remove(tid);
	}
	
	}
