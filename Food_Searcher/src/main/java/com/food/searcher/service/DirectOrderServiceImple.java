package com.food.searcher.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.food.searcher.domain.DirectOrderVO;
import com.food.searcher.domain.ItemVO;
import com.food.searcher.persistence.DirectOrderMapper;
import com.food.searcher.persistence.ItemMapper;

import lombok.extern.log4j.Log4j;

@Service
@Log4j
public class DirectOrderServiceImple implements DirectOrderService{

	@Autowired
	private DirectOrderMapper directOrderMapper;
	
	@Autowired
	private ItemMapper itemMapper;
	
	@Override
	public List<DirectOrderVO> getAllOrder() {
		return directOrderMapper.selectAll();
	}

	@Override
	public List<DirectOrderVO> getOrder(String memberId) {
		return directOrderMapper.selectMember(memberId);
	}
	
	@Override
	public DirectOrderVO getselectOne(int itemId) {
		return directOrderMapper.selectOne(itemId);
	}

	@Transactional(value = "transactionManager")
	@Override
	public int orderPurchase(DirectOrderVO directOrderVO) {
		log.info("insert()");
		log.info(directOrderVO);
		int result = directOrderMapper.insert(directOrderVO);
		log.info(result + "행 추가 완료");
		ItemVO itemVO = itemMapper.selectOne(directOrderVO.getItemId());
		int itemAmount = itemVO.getItemAmount() - directOrderVO.getTotalCount();
		int item = itemMapper.itemAmount(itemAmount, directOrderVO.getItemId());
		log.info(item + "행 업데이트 완료");
		return result;
	}

	@Override
	public int changeStatus(String deliveryStatus) {
		return directOrderMapper.changeStatus(deliveryStatus);
	}

}
