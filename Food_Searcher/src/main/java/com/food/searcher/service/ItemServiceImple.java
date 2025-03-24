package com.food.searcher.service;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.food.searcher.domain.AskVO;
import com.food.searcher.domain.CtgVO;
import com.food.searcher.domain.ItemAttachVO;
import com.food.searcher.domain.ItemVO;
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
	UtilityService utilityService;
	
	@Autowired
	AskService askService;
	
	@Autowired
	ItemAttachService itemAttachService;

	@Transactional(value = "transactionManager", rollbackFor = Exception.class)
	@Override
	public int createItem(ItemVO itemVO) {

		int result = itemMapper.itemInsert(itemVO);
		log.info(itemVO);
		List<ItemAttachVO> attachList = itemVO.getAttachList();

		itemMapper.itemCtgInsert(itemVO);
			for (ItemAttachVO attachVO : attachList) {
				attachVO.setItemId(selectAllList().get(0).getItemId());
				itemAttachService.createAttach(attachVO);
			}

		return result;
	}
	
	@Transactional
	@Override
	public int getTotalCount(Pagination pagination) {
		return itemMapper.selectAllCount(pagination);
	}

	@Transactional
	@Override
	public List<ItemVO> getPagingAllItems(Pagination pagination) {

		List<ItemVO> list = itemMapper.selectAllByPagination(pagination);
		return list.stream().collect(Collectors.toList());
	}

	// pull 후 삭제, 컨트롤러에서 에러뜬 곳들 수정 예정
	@Override
	public List<ItemVO> getPagingStatusItems(Pagination pagination) {
		List<ItemVO> list = itemMapper.selectStatusByPagination(pagination);
		return list.stream().collect(Collectors.toList());
	}
	
	public List<ItemVO> selectSellerItem(String memberId) {
		List<ItemVO> list = itemMapper.selectSellerItem(memberId);
		return list;
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
		itemMapper.ctgUpdate(itemVO);

		List<ItemAttachVO> attachList = itemVO.getAttachList();

		int deleteResult = itemAttachService.deleteAttach(itemVO.getItemId());
		log.info(deleteResult + "행 파일 정보 삭제");

		int insertAttachResult = 0;
		for (ItemAttachVO attachVO : attachList) {
			attachVO.setItemId(itemVO.getItemId());
			insertAttachResult += itemAttachService.createAttach(attachVO);
		}
		log.info(insertAttachResult + "행 파일 정보 등록");
		return updateItem;
	}
	
	@Override
	public int updateItemStatus(int itemId, int itemStatus) {
		return itemMapper.updateStatus(itemId, itemStatus);
	}
	
	@Transactional
	   @Override
	   public int updateItemAmount(int itemId, int itemAmount) {
	      
	      if(itemAmount < 0) {
	         log.error("아이템 수량이 음수입니다. itemId: {}, itemAmount: {}");
	         return 0;
	      } else {
	         return itemMapper.updateItemAmount(itemId, itemAmount);
	      }
	   }

	@Transactional
	@Override
	public int deleteItem(int itemId) {
		log.info("deleteItem()");
		List<AskVO> askList = askService.getAsk(itemId);
		log.info("작성된 문의 : " + askList);
		for (AskVO askVO : askList) {
			log.info(askVO);
			int result = askService.deleteAsk(askVO.getAskId());
			log.info(result + "행 문의 삭제");
		}
		return itemMapper.delete(itemId);
	}

	@Override
	public List<ItemVO> getSelectCategoryList(String mainCtg, int itemId, Pagination pagination) {
		return itemMapper.selectCategoryList(mainCtg, itemId, pagination);
	}

	@Override
	public List<CtgVO> mainCtgList() {
		return itemMapper.mainCtgList();
	}

	@Override
	public List<ItemVO> selectAllList() {
		return itemMapper.selectAllList().stream().collect(Collectors.toList());
	}

	@Override
	public List<ItemAttachVO> attachAll() {
		List<ItemAttachVO> attachVO = itemAttachService.getSelectAll();
		List<ItemAttachVO> list = new ArrayList<ItemAttachVO>();
		for(ItemAttachVO vo : attachVO) {
			Path filePath = Paths.get("C:\\upload\\food" + '\\' + vo.getAttachPath(), vo.getAttachChgName());
			if (Files.exists(filePath)) {
				list.add(vo);
	        } else {
	        }
		}
		return list;
	}

	@Override
	public List<ItemAttachVO> attachById(int itemId) {
		List<ItemAttachVO> attachVO = itemAttachService.getItemById(itemId);
		List<ItemAttachVO> list = new ArrayList<ItemAttachVO>();
		for(ItemAttachVO vo : attachVO) {
			Path filePath = Paths.get("C:\\upload\\food" + '\\' + vo.getAttachPath(), vo.getAttachChgName());
			if (Files.exists(filePath)) {
				list.add(vo);
	        } else {
	        }
		}
		return list;
	}

} // end ItemServiceImple
