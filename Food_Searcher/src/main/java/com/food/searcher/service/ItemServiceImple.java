package com.food.searcher.service;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;

import com.food.searcher.domain.ItemAttachVO;
import com.food.searcher.domain.ItemVO;
import com.food.searcher.persistence.ItemAttachMapper;
import com.food.searcher.persistence.ItemMapper;
import com.food.searcher.util.Pagination;

import lombok.extern.log4j.Log4j;

@Repository
@Service
@Log4j

public class ItemServiceImple implements ItemService {
	
	@Autowired
	ItemMapper itemMapper;
	
	@Autowired
	private ItemAttachMapper attachMapper;
	
	@Override
	public int createItem(ItemVO itemVO) {
		log.info("createItem()");
		log.info("ItemVO : " + itemVO);
		int itemResult = itemMapper.insert(itemVO);
		log.info(itemResult + "행 상품 등록");
		
		List<ItemAttachVO> attachList = itemVO.getAttachList();
		int insertAttachResult = 0;
		for (ItemAttachVO attachVO : attachList) {
			attachVO.setItemId(getAllItem().get(0).getItemId()); // 수정 필요 전체 리스트를 가져와야 함
			insertAttachResult += attachMapper.insert(attachVO);
		}
		log.info(insertAttachResult + "행 파일 정보 등록");
		
		return itemResult;
	}
	
	@Override
	public List<ItemVO> getAllItem() {
		return itemMapper.selectListAll();
	}

	@Override
	public List<ItemVO> getAllItem(int itemStatus) {
		log.info("getAllItem()");
		List<ItemVO> list = itemMapper.selectList(itemStatus);
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

	@Override
	public List<ItemVO> getPagingItems(Pagination pagintaion) {
		List<ItemVO> list = itemMapper.selectListByPagination(pagintaion);
		return list.stream().collect(Collectors.toList());
	}

	@Override
	public int getTotalCount(Pagination pagination) {
		return itemMapper.selectTotalCount(pagination);
	}

	
} // end ItemServiceImple
