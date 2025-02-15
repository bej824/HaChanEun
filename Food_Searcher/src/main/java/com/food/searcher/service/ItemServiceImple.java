package com.food.searcher.service;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;

import com.food.searcher.domain.ItemVO;
import com.food.searcher.persistence.ItemMapper;

import lombok.extern.log4j.Log4j;

@Repository
@Service
@Log4j

public class ItemServiceImple implements ItemService {
	
	@Autowired
	ItemMapper itemMapper;
	
	
	@Override
	public int createItem(ItemVO itemVO) {
		log.info("createItem()");
		log.info("ItemVO : " + itemVO);
		int itemResult = itemMapper.insert(itemVO);
		log.info(itemResult + "행 상품 등록");
		
		return itemResult;
	}

	@Override
	public List<ItemVO> getAllItem() {
		log.info("getAllItem()");
		List<ItemVO> list = itemMapper.selectList();
		log.info(list);
		return list.stream().collect(Collectors.toList());
	}

	@Override
	public ItemVO getItemById(int itemId) {
		log.info("getItemById()");
		log.info("itemId : " + itemId);
		ItemVO itemVO = itemMapper.selectOne(itemId);
		return itemVO;
	}

	@Override
	public int updateItem(ItemVO itemVO) {
		log.info("updateItem()");
		return itemMapper.update(itemVO);
	}

	@Override
	public int deleteItem(int itemId) {
		log.info("deleteItem()");
		return itemMapper.delete(itemId);
	}

	
} // end ItemServiceImple
