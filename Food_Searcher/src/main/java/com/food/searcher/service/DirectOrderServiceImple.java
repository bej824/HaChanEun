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
import com.food.searcher.persistence.MemberMapper;
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
	
	@Autowired
	private MemberMapper memberMapper;
	
	@Autowired
	private MemberService memberService;

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

//	@Transactional(value = "transactionManager")
//	@Override
//	public int orderPurchase(DirectOrderVO directOrderVO) {
//		log.info("orderPurchase()");
//		
//		LocalDateTime now = LocalDateTime.now();
//		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
//		directOrderVO.setOrderId(now.format(formatter));
//
//		log.info(directOrderVO);
//
//		List<ItemVO> list = new ArrayList<>();
//		ItemVO itemVO = itemService.getItemById(directOrderVO.getItemId());
//		itemVO.setItemCount(directOrderVO.getTotalCount());
//		list.add(itemVO);
//		
//		if(list.get(0).getItemAmount() - directOrderVO.getTotalCount() >= 0) {
//			itemService.updateItemAmount(
//					directOrderVO.getItemId()
//					,list.get(0).getItemAmount() - directOrderVO.getTotalCount());
//		} else {
//			log.warn(list.get(0).getItemId() + " " + list.get(0).getItemName() + "의 재고가 부족합니다.");
//			return 401;
//		}
//		
//		if(itemVO.getItemStatus() != 100) {
//			return 402;
//		}
//		
//		Integer discountPrice = couponActiveService.selectCouponActiveByCouponPrice(directOrderVO, now);
//		
//
//		int totalPrice = calculateTotalPrice(
//				 list
//				,discountPrice);
//		
//		directOrderVO.setTotalPrice(totalPrice);
//
//		if(amountHeldService.selectAmountHeld() >= totalPrice) {
//		directOrderMapper.insert(directOrderVO);
//		memberService.updateAmountHeld(totalPrice, 0);
//		
//		if(discountPrice != 0) {
//			int couponUseInfo = couponActiveService.applyCoupon(directOrderVO, now, discountPrice);			
//			if(couponUseInfo != 1) {
//				return 403;
//			}
//		}
//		return 1;
//		} else {
//			return 404;
//		}
//	}
//
//	@Transactional
//	@Override
//	public int cartPurchase(List<DirectOrderVO> directOrderVO) {
//	    log.info("cartInsert()");
//	    LocalDateTime now = LocalDateTime.now();
//	    
//	    int totalPrice = 0;
//	    for (DirectOrderVO vo : directOrderVO) {
//	    	DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
//	    	vo.setOrderId(now.format(formatter));
//	    	
//	    	List<CartVO> cartVO = cartMapper.cartOrder(vo.getMemberId());
//		    
//		    directOrderMapper.insert(vo);
//		    totalPrice += vo.getTotalPrice();
//		    
//		    for (CartVO cartDelete : cartVO) {
//		        cartMapper.cartDelete(cartDelete.getCartId());
//		    }
//	    }
//	    
////	    Integer discountPrice = couponActiveService.selectCouponActiveByCouponPrice(directOrderVO, now);
//	    
//	    if(amountHeldService.selectAmountHeld() >= totalPrice) {
//	    memberService.updateAmountHeld(totalPrice, 0);
//	    return 1;
//	    } else {
//			return 404;
//		}
//	}


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
		DirectOrderVO directOrderVO = directOrderMapper.selectOne(orderId);
		
		memberMapper.updateAmountHeld(directOrderVO.getMemberId(), directOrderVO.getTotalPrice());
		ItemVO itemVO = itemService.getItemById(directOrderVO.getItemId());
		itemService.updateItemAmount(itemVO.getItemAmount() - directOrderVO.getTotalCount(), directOrderVO.getItemId());
		couponActiveService.updateCouponActiveByOrderId(orderId);

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

		DirectOrderVO directOrderVO = directOrderMapper.selectOne(orderId);
		memberMapper.updateAmountHeld(directOrderVO.getMemberId(), directOrderVO.getTotalPrice());
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
	public int getMemberTotalCount(String memberId, Pagination pagination) {
		return directOrderMapper.selectMemberTotalCount(memberId, pagination);
	}

	public int calculateTotalPrice(
			 List<ItemVO> list
			,Integer discountPrice) {
		
		int totalCost = 0;

		for (int i = 0; i < list.size(); i++) {
			totalCost += list.get(i).getItemPrice() * list.get(i).getItemCount();
		}

		return Math.max(totalCost - discountPrice, 0);
	}

	@Override
	public int orderCancel() {
		List<DirectOrderVO> directOrderVO = directOrderMapper.orderCancelList();
		for (DirectOrderVO vo : directOrderVO) {
			memberMapper.updateAmountHeld(vo.getMemberId(), vo.getTotalPrice());
		}
		return directOrderMapper.orderCancel();
	}

}
