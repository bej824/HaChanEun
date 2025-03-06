package com.food.searcher.service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.food.searcher.domain.CartVO;
import com.food.searcher.domain.CouponActiveVO;
import com.food.searcher.domain.DirectOrderVO;
import com.food.searcher.domain.ItemListVO;
import com.food.searcher.domain.ItemVO;
import com.food.searcher.persistence.CartMapper;
import com.food.searcher.persistence.DirectOrderMapper;
import com.food.searcher.persistence.ItemMapper;
import com.food.searcher.util.Pagination;

import lombok.extern.log4j.Log4j;

@Service
@Log4j
public class DirectOrderServiceImple implements DirectOrderService {

	@Autowired
	private DirectOrderMapper directOrderMapper;

	@Autowired
	private CouponActiveService couponActiveService;

	@Autowired
	private UtilityService utilityService;

	@Autowired
	private ItemService itemService;

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
		log.info("insert()");

		LocalDateTime now = LocalDateTime.now();
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
		directOrderVO.setOrderId(now.format(formatter));

		log.info(directOrderVO);

		List<ItemVO> list = new ArrayList<>();
		ItemVO itemVO = itemService.getItemById(directOrderVO.getItemId());
		itemVO.setItemCount(directOrderVO.getTotalCount());
		list.add(itemVO);
		
		if(list.get(0).getItemAmount() - directOrderVO.getTotalCount() >= 0) {
			itemService.updateItemAmount(
					directOrderVO.getItemId()
					,list.get(0).getItemAmount() - directOrderVO.getTotalCount());
		} else {
			log.warn(list.get(0).getItemId() + " " + list.get(0).getItemName() + "의 재고가 부족합니다.");
			return 0;
		}
		
		Integer discountPrice = couponActiveService.selectCouponActiveByCouponPrice(directOrderVO, now);

		Map<String, Integer> totalPrice = calculateTotalPrice(
				 list
				,discountPrice
				,directOrderVO.getMemberId());
		
		directOrderVO.setTotalPrice(totalPrice.get(directOrderVO.getMemberId()));

		return directOrderMapper.insert(directOrderVO);
	}

	@Transactional
	@Override
	public int cartPurchase(List<DirectOrderVO> directOrderVO) {
	    
	    log.info("cartInsert()");
	    log.info(directOrderVO);
	    List<ItemListVO> itemList = new ArrayList<>();
	    for (DirectOrderVO vo : directOrderVO) {
	    	LocalDateTime now = LocalDateTime.now();
	    	DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
	    	vo.setOrderId(now.format(formatter));
	    	
	    	List<CartVO> cartVO = cartMapper.cartOrder(vo.getMemberId());
	    	
	    	
		    for (CartVO cartOne : cartVO) {
		    	ItemListVO item = new ItemListVO();
		    	item.setOrderId(now.format(formatter));
		    	item.setMemberId(vo.getMemberId());
		        item.setItemId(cartOne.getItemId());
		        item.setTotalPrice(cartOne.getItemPrice() * cartOne.getCartAmount());
		        item.setTotalCount(cartOne.getCartAmount());
		        item.setDeliveryAddress(vo.getDeliveryAddress());
		        itemList.add(item);
		    }
		    
		    log.info("directOrderVO" + vo);
		    directOrderMapper.insert(vo);
		    
		    for (CartVO cartDelete : cartVO) {
		        cartMapper.cartDelete(cartDelete.getCartId());
		    }
	    }
	    
	    return 1;
	}


	@Override
	public List<DirectOrderVO> sellerList(String memberId, Pagination pagination) {
		log.info("sellerList()");

		return directOrderMapper.sellerList(memberId, pagination);
	}

	@Override
	public int getSellerTotalCount(String memberId, Pagination pagination) {
		return directOrderMapper.sellerTotalCount(memberId, pagination);
	}

	@Transactional(value = "transactionManager")
	@Override
	public int cancel(String orderId) {
		log.info("cancel()");
		int result = directOrderMapper.cancel(orderId);
		log.info(result + "행 업데이트 완료");
		couponActiveService.updateCouponActiveByOrderId(orderId);
		DirectOrderVO directOrderVO = directOrderMapper.selectOne(orderId);

		ItemVO itemVO = itemService.getItemById(directOrderVO.getItemId());
		itemService.updateItemAmount(itemVO.getItemAmount() - directOrderVO.getTotalCount(), directOrderVO.getItemId());

		return result;
	}

	@Override
	public int refundReady(String orderId) {
		log.info("환불 하기");
		return directOrderMapper.refundReady(orderId);
	}

	@Override
	public int refund(String refundReason, String refundContent, String orderId) {
		log.info("환불 신청");
		return directOrderMapper.refund(refundReason, refundContent, orderId);
	}

	@Transactional
	@Override
	public int refundOK(String orderId) {
		log.info("환불 승인");

		int result = directOrderMapper.refundOK(orderId);

		if (result == 1) {
			couponActiveService.updateCouponActiveByOrderId(orderId);
		}

		return result;
	}

	@Override
	public int deliveryReady(String deliveryCompany, String invoiceNumber, String orderId) {
		log.info("배송 준비중");
		return directOrderMapper.deliveryReady(deliveryCompany, invoiceNumber, orderId);
	}

	@Override
	public int delivering(String orderId) {
		log.info("배송 중");
		return directOrderMapper.delivering(orderId);
	}

	@Override
	public int deliveryCompleted(String orderId) {
		log.info("배송 완료");
		return directOrderMapper.deliveryCompleted(orderId);
	}

	@Override
	public List<DirectOrderVO> getPagingBoards(Pagination pagination) {
		return directOrderMapper.selectListByPagination(pagination);
	}

	@Override
	public int getTotalCount(Pagination pagination) {
		return directOrderMapper.selectTotalCount(pagination);
	}

	@Override
	public List<DirectOrderVO> getPagingmemberList(String memberId, Pagination pagination) {
		return directOrderMapper.memberList(memberId, pagination);
	}

	@Override
	public int getMemberTotalCount(String memberId) {
		return directOrderMapper.selectMemberTotalCount(memberId);
	}

	public Map<String, Integer> calculateTotalPrice(
			 List<ItemVO> list
			,Integer discountPrice
			,String memberId) {
		Map<String, Integer> acount = new HashMap<String, Integer>();
		int totalCost = 0;

		for (int i = 0; i < list.size(); i++) {
			totalCost += list.get(i).getItemPrice() * list.get(i).getItemCount();
		}

		acount.put(memberId, totalCost - discountPrice);

		return acount;
	}

}
