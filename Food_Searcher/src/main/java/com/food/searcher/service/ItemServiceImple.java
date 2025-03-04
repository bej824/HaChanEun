package com.food.searcher.service;

import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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
	ItemAttachMapper attachMapper;

	@Autowired
	UtilityService utilityService;

	@Transactional(value = "transactionManager", rollbackFor = Exception.class)
	@Override
	public int createItem(ItemVO itemVO) {

		int result = 0;
		List<ItemAttachVO> attachList = itemVO.getAttachList();

		try {
			itemMapper.itemInsert(itemVO);
			itemMapper.itemCtgInsert(itemVO);
			for (ItemAttachVO attachVO : attachList) {
				attachMapper.insert(attachVO);
			}
			result = 1;

		} catch (Exception e) {
			log.error("상품 생성 중 오류 발생", e);
		}

		return result;
	}
	
	@Transactional
	@Override
	public int getTotalCount(Pagination pagination) {
		int itemStatus = 0;
		return itemMapper.selectTotalCount(pagination, itemStatus);
	}

	@Transactional
	@Override
	public List<ItemVO> getPagingAllItems(Pagination pagination) {
		int itemStatus = 100; // pull 후 컨트롤러에서 받는 걸로 수정

		String memberId = utilityService.checkRoleSeller();
		List<ItemVO> list = itemMapper.selectAllByPagination(pagination, itemStatus, memberId);
		return list.stream().collect(Collectors.toList());
	}

	// pull 후 삭제, 컨트롤러에서 에러뜬 곳들 수정 예정
	@Override
	public List<ItemVO> getPagingStatusItems(Pagination pagination) {
		int itemStatus = 100;
		String memberId = null;
		List<ItemVO> list = itemMapper.selectAllByPagination(pagination, itemStatus, memberId);
		return list.stream().collect(Collectors.toList());
	}

	@Transactional
	@Override
	public ItemVO getItemById(int itemId) {
		ItemVO itemVO = itemMapper.selectOne(itemId);
		return itemVO;
	}
	
	@Transactional
	@Override
	public int getStatusTotalCount(Pagination pagination) {
		int itemStatus = 100;
		return itemMapper.selectTotalCount(pagination, itemStatus);
	}

	@Transactional(value = "transactionManager")
	@Override
	public int updateItem(ItemVO itemVO) {
		int updateItem = itemMapper.update(itemVO);

		List<ItemAttachVO> attachList = itemVO.getAttachList();

		int deleteResult = attachMapper.delete(itemVO.getItemId());
		log.info(deleteResult + "행 파일 정보 삭제");

		int insertAttachResult = 0;
		for (ItemAttachVO attachVO : attachList) {
			attachVO.setItemId(itemVO.getItemId());
			insertAttachResult += attachMapper.insert(attachVO);
		}
		log.info(insertAttachResult + "행 파일 정보 등록");
		return updateItem;
	}
	
	@Transactional
	@Override
	public int updateItemStatus(int itemId, int itemStatus) {

		return itemMapper.updateStatus(itemId, itemStatus);
	}
	
	@Transactional
	@Override
	public int updateItemAmount(int itemId, int itemAmount) {
		
		return itemMapper.updateItemAmount(itemId, itemAmount);
	}

	@Transactional
	@Override
	public int deleteItem(int itemId) {
		return itemMapper.delete(itemId);
	}

} // end ItemServiceImple
