package com.food.searcher.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.food.searcher.domain.DirectOrderVO;
import com.food.searcher.persistence.DirectOrderMapper;

import lombok.extern.log4j.Log4j;

@Service
@Log4j
public class DirectOrderServiceImple implements DirectOrderService{

	@Autowired
	private DirectOrderMapper directOrderMapper;
	
	@Override
	public List<DirectOrderVO> getAllOrder() {
		return directOrderMapper.selectAll();
	}

	@Override
	public DirectOrderVO getOrder(String deliveryStatus) {
		return directOrderMapper.selectOne(deliveryStatus);
	}

	@Override
	public int orderPurchase(DirectOrderVO directOrderVO) {
		log.info("insert()");
		log.info(directOrderVO);
		return directOrderMapper.insert(directOrderVO);
	}

	@Override
	public int changeStatus(String deliveryStatus) {
		return directOrderMapper.changeStatus(deliveryStatus);
	}

}
