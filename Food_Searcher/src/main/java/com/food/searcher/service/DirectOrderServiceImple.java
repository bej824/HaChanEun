package com.food.searcher.service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.food.searcher.domain.CartVO;
import com.food.searcher.domain.DirectOrderVO;
import com.food.searcher.domain.ItemVO;
import com.food.searcher.persistence.CartMapper;
import com.food.searcher.persistence.DirectOrderMapper;
import com.food.searcher.persistence.ItemMapper;
import com.food.searcher.util.Pagination;

import lombok.extern.log4j.Log4j;

@Service
@Log4j
public class DirectOrderServiceImple implements DirectOrderService{

	@Autowired
	private DirectOrderMapper directOrderMapper;
	
	@Autowired
	private ItemMapper itemMapper;
	
	@Autowired
	private CartMapper cartMapper;
	
	@Override
	public List<DirectOrderVO> getAllOrder() {
		return directOrderMapper.selectAll();
	}

	@Override
	public List<DirectOrderVO> getOrder(String memberId) {
		return directOrderMapper.selectMember(memberId);
	}
	
	@Override
	public DirectOrderVO getselectOne(String itemId) {
		return directOrderMapper.selectOne(itemId);
	}

	@Transactional(value = "transactionManager")
	@Override
	public int orderPurchase(DirectOrderVO directOrderVO) {
		LocalDateTime now = LocalDateTime.now();
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
		directOrderVO.setOrderId(now.format(formatter) + directOrderVO.getMemberId());
		
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

	@Transactional(value = "transactionManager")
	@Override
	public int cancel(String deliveryStatus, String orderId) {
		log.info("cancel()");
		int result = directOrderMapper.cancel(deliveryStatus, orderId);
		log.info(result + "행 업데이트 완료");
		DirectOrderVO directOrderVO = directOrderMapper.selectOne(orderId);
		ItemVO itemVO = itemMapper.selectOne(directOrderVO.getItemId());
		int itemAmount = itemVO.getItemAmount() + directOrderVO.getTotalCount();
		int item = itemMapper.itemAmount(itemAmount, directOrderVO.getItemId());
		log.info(item + "행 업데이트 완료");
		return result;
	}
	
	@Override
	public int refundReady(String deliveryStatus, String orderId) {
		log.info("환불 하기");
		return directOrderMapper.refundReady(deliveryStatus, orderId);
	}
	
	@Override
	public int refund(String deliveryStatus, String refundReason, String refundContent, String orderId) {
		log.info("환불 신청");
		return directOrderMapper.refund(deliveryStatus, refundReason, refundContent, orderId);
	}
	
	@Override
	public int refundOK(String deliveryStatus, String orderId) {
		log.info("환불 승인");
		return directOrderMapper.refundOK(deliveryStatus, orderId);
	}
	
	@Override
	public int deliveryReady(String deliveryStatus, String deliveryCompany, String invoiceNumber, String orderId) {
		log.info("배송 준비중");
		return directOrderMapper.deliveryReady(deliveryStatus, deliveryCompany, invoiceNumber, orderId);
	}
	
	@Override
	public int delivering(String deliveryStatus, String orderId) {
		log.info("배송 중");
		return directOrderMapper.delivering(deliveryStatus, orderId);
	}
	
	@Override
	public int deliveryCompleted(String deliveryStatus, String orderId) {
		log.info("배송 완료");
		return directOrderMapper.deliveryCompleted(deliveryStatus, orderId);
	}
	
	@Override
	public List<DirectOrderVO> getPagingBoards(Pagination pagination) {
		return directOrderMapper.selectListByPagination(pagination);
	}

	@Override
	public int cartPurchase(DirectOrderVO directOrderVO) {
		LocalDateTime now = LocalDateTime.now();
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
		directOrderVO.setOrderId(now.format(formatter) + directOrderVO.getMemberId());
		
		log.info("cartInsert()");
		log.info(directOrderVO);
		int result = directOrderMapper.cartInsert(directOrderVO);
		log.info(result + "행 추가 완료");
		ItemVO itemVO = itemMapper.selectOne(directOrderVO.getItemId());
		int itemAmount = itemVO.getItemAmount() - directOrderVO.getTotalCount();
		int item = itemMapper.itemAmount(itemAmount, directOrderVO.getItemId());
		log.info(item + "행 업데이트 완료");
		
		List<CartVO> cartVO = cartMapper.cartOrder(directOrderVO.getMemberId());
		for(CartVO vo : cartVO) {
			cartMapper.cartDelete(vo.getCartId());
		}
		return result;
	}

}
