package com.food.searcher.service;

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

	@Transactional(value = "transactionManager")
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
	public int deleteItem(int itemId) {
		log.info("deleteItem()");
		return itemMapper.delete(itemId);
	}
	
   @Override
   public int getTotalCount(Pagination pagination) {
      return itemMapper.selectTotalCount(pagination);
   }

	@Override
	public List<ItemVO> getAllItem() {
		log.info("getAllItem()");
		List<ItemVO> list = itemMapper.selectAll();
		log.info(list);
		return list.stream().collect(Collectors.toList());
	}

	@Override
	public List<ItemVO> getPagingAllItems(Pagination pagination) {
		log.info("getPagingItems()");
		List<ItemVO> list = itemMapper.selectAllByPagination(pagination);
		log.info(list);
		return list.stream().collect(Collectors.toList());
	}

	@Override
	public List<ItemVO> getItemByStatus(int itemStatus) {
		log.info("getItemByStatus()");
		List<ItemVO> list = itemMapper.selectStatus(itemStatus);
		log.info(list);
		return list.stream().collect(Collectors.toList());
	}

	@Override
	public List<ItemVO> getPagingStatusItems(Pagination pagination) {
		log.info("getPagingStatusItems()");
		List<ItemVO> list = itemMapper.selectStatusByPagination(pagination);
		log.info(pagination);
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

	@Transactional(value = "transactionManager")
	@Override
	public int updateItem(ItemVO itemVO) {
		log.info("updateItem()");
		int updateItem = itemMapper.update(itemVO);

		List<ItemAttachVO> attachList = itemVO.getAttachList();

		int deleteResult = attachMapper.delete(itemVO.getItemId());
		log.info(deleteResult + "행 파일 정보 삭제");

		int insertAttachResult = 0;
		for (ItemAttachVO attachVO : attachList) {
			attachVO.setItemId(itemVO.getItemId());
			insertAttachResult += attachMapper.insert(attachVO);
			log.info("attachVO" + attachVO);
		}
		log.info(insertAttachResult + "행 파일 정보 등록");
		return updateItem;
	}

	@Override
	public int getStatusTotalCount(Pagination pagination) {
		return itemMapper.selectStatusTotalCount(pagination);
	}
	
	@Override
	public int updateStatus(int itemId, int itemStatus) {
		log.info("updateStatus()");
		ItemVO itemVO = new ItemVO();
		itemVO.setItemId(itemId);
		itemVO.setItemStatus(itemStatus);
		
		return itemMapper.updateStatus(itemVO);
	}


} // end ItemServiceImple
