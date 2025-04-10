package com.food.searcher.service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.HttpServerErrorException;
import org.springframework.web.client.RestTemplate;

import com.food.searcher.domain.ApproveResponse;
import com.food.searcher.domain.DirectOrderVO;
import com.food.searcher.domain.ItemVO;
import com.food.searcher.domain.PaymentCancellationVO;
import com.food.searcher.domain.ReadyResponse;
import com.food.searcher.persistence.DirectOrderMapper;
import com.food.searcher.util.OrderUtil;
import com.food.searcher.util.Pagination;
import com.food.searcher.util.SessionUtils;

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
	private CartService cartService;
	
	@Autowired
    private RestTemplate restTemplate;
	
	@Autowired
	private OrderUtil orderUtil;
	
	private static final String KAKAO_PAY_API_ID = 
    		"TC0ONETIME";
    
    private static final String KAKAO_PAY_API_URL_READY = 
    		"https://open-api.kakaopay.com/online/v1/payment/ready";
    
    private static final String KAKAO_PAY_API_URL_APPROVE = 
    		"https://open-api.kakaopay.com/online/v1/payment/approve";
    
    private static final String KAKAO_PAY_API_URL_CANCEL = 
    		"https://open-api.kakaopay.com/online/v1/payment/cancel";
    
    private static final String REST_API_KEY = 
    		"DEV68BCC7625BFB142057D59F4EAB9E0F6FC888E"; // 카카오 개발자 사이트에서 받은 REST API 키

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

	@Transactional
	public int oneOrder(DirectOrderVO directOrderVO) {
		
		directOrderVO.setOrderId(String.format("%04d", 0));
		
		List<DirectOrderVO> orderList = new ArrayList<DirectOrderVO>();
		orderList.add(directOrderVO);
		
		return itemSearch(orderList);
	}
	
	public int cartOrder(List<DirectOrderVO> orderList) {
		
		for(int i = 0; i < orderList.size(); i++) {
			orderList.get(i).setOrderId(String.format("%04d", i));
		}
		
		return itemSearch(orderList);
	}


	@Override
	public List<DirectOrderVO> sellerList(String memberId, Pagination pagination) {

		return directOrderMapper.sellerList(memberId, pagination);
	}

	@Override
	public int getSellerTotalCount(String memberId, Pagination pagination) {
		return directOrderMapper.sellerTotalCount(memberId, pagination);
	}

	@Transactional(value = "transactionManager")
	@Override
	public int cancel(String orderId) {
		int result = directOrderMapper.cancel(orderId);
		DirectOrderVO directOrderVO = directOrderMapper.selectOne(orderId);
		
		ItemVO itemVO = itemService.getItemById(directOrderVO.getItemId());
		itemService.updateItemAmount(itemVO.getItemAmount() - directOrderVO.getTotalCount(), directOrderVO.getItemId());
		couponActiveService.updateCouponActiveByOrderId(orderId);

		return result;
	}

	@Override
	public int refundReady(String orderId) {
		return directOrderMapper.refundReady(orderId);
	}

	@Override
	public int refund(String refundReason, String refundContent, String orderId) {
		return directOrderMapper.refund(refundReason, refundContent, orderId);
	}

	@Transactional
	@Override
	public int refundOK(String orderId) {

		int result = directOrderMapper.refundOK(orderId);

		if (result == 1) {
			couponActiveService.updateCouponActiveByOrderId(orderId);
		}

		return result;
	}

	@Override
	public int deliveryReady(String deliveryCompany, String invoiceNumber, String orderId) {
		return directOrderMapper.deliveryReady(deliveryCompany, invoiceNumber, orderId);
	}

	@Override
	public int delivering(String orderId) {
		return directOrderMapper.delivering(orderId);
	}

	@Override
	public int deliveryCompleted(String orderId) {
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
		
		return directOrderMapper.orderCancel();
	}
	
	@Transactional
	public int itemSearch(List<DirectOrderVO> orderList) {
		
		for(int i = 0; i < orderList.size(); i++) {
			
			ItemVO itemVO = itemService.getItemById(orderList.get(i).getItemId());
			
			if(itemVO.getItemAmount() - orderList.get(i).getTotalCount() >= 0) {
				itemService.updateItemAmount(
						itemVO.getItemId()
						,itemVO.getItemAmount() - orderList.get(i).getTotalCount());
				
				orderList.get(i).setTotalPrice(
						itemVO.getItemPrice() * orderList.get(i).getTotalCount());
				orderList.get(i).setItemName(itemVO.getItemName());
				
			} else {
				log.warn(itemVO.getItemId() + " " + itemVO.getItemName() + "의 재고가 부족합니다.");
				return 401;
			}
			
			if(itemVO.getItemStatus() != 100) {
				return 402;
			}
			
		}
		return discountPrice(orderList);
	}
	
	@Transactional
	public int discountPrice(List<DirectOrderVO> orderList) {
		
		Integer discountPrice = 0;
		
		if(orderList.get(0).getCouponActiveId() != null) {
			discountPrice = couponActiveService.selectCouponActiveByCouponPrice(
					orderList.get(0).getCouponActiveId());			
		}
		
		if(discountPrice > 0) {
			orderList.get(0).setTotalPrice(
					orderList.get(0).getTotalPrice() - discountPrice);			
		}
		return priceInfo(orderList);
	}
	
	@Transactional
	public int priceInfo(List<DirectOrderVO> orderList) {
		
		int result = 0;
		int orderTotalPrice = 0;
		
		for(int i = 0; i < orderList.size(); i++) {
			orderTotalPrice += orderList.get(i).getTotalPrice();
		}
		
		orderTotalPrice = Math.max(orderTotalPrice, 0);
		
		ReadyResponse readyResponse = kakaoPayReady(orderList, orderTotalPrice);
		
		String tid = readyResponse.getTid();
		
		SessionUtils.addAttribute("tid", tid);
		SessionUtils.addAttribute("next_redirect_pc_url", readyResponse.getNext_redirect_pc_url());
		
		SessionUtils.addAttribute("partner_order_id", orderList.get(0).getOrderId());
		String itemName = "";		
		for(int i = 0; i < orderList.size(); i++) {
			itemName += orderList.get(i).getItemName() + " ";
				orderList.get(i).setOrderId(tid + String.format("%02d", i));
				orderList.get(i).setTid(readyResponse.getTid());
		}
		SessionUtils.addAttribute("item_name", itemName);
		
		if(tid != null) {
			orderUtil.setOrderList(orderList, tid);
			result = 1;
		}
		
		return result;
	}
	
	@Transactional
	public int acountFinal(List<DirectOrderVO> orderList) {
		
		directOrderMapper.insert(orderList);
		cartService.deleteOrderCart();
		
		if(orderList.get(0).getCouponActiveId() != null) {
			int couponUseInfo = couponActiveService.applyCoupon (
					 orderList.get(0)
					,LocalDateTime.now());
			
			if(couponUseInfo != 1) {
				return 403;
			}
			
		}
		
		return 1;
	}

	@Override
	public ReadyResponse kakaoPayReady(List<DirectOrderVO> orderList, int orderTotalPrice) {
		String itemName = "";
		for(int i = 0; i < orderList.size(); i++) {
			itemName = itemName + orderList.get(i).getItemName();
			
			if(i < orderList.size() -1) {
				itemName = itemName + ", ";
			}
		}
		
		for(DirectOrderVO order : orderList) {	
		Map<String, String> parameters = new HashMap<>();
        parameters.put("cid", KAKAO_PAY_API_ID);                                // 가맹점 코드(테스트용)
        parameters.put("partner_order_id", String.valueOf(order.getOrderId()));            // 주문번호
        parameters.put("partner_user_id", utilityService.loginMember());        // 회원 아이디
        parameters.put("item_name", itemName);                                  // 상품명
        parameters.put("quantity", "1");                                        // 단건 결제(대량 구매여도 결제는 1번만 되므로)
        parameters.put("total_amount", String.valueOf(orderTotalPrice));             // 상품 총액
        parameters.put("tax_free_amount", "0");                                 // 상품 비과세 금액
        parameters.put("approval_url", "http://localhost:13417/searcher/item/completed"); 		// 결제 성공 시 URL
        parameters.put("cancel_url", "http://localhost:13417/searcher/item/cancel");      		// 결제 취소 시 URL
        parameters.put("fail_url", "http://localhost:13417/searcher/item/fail");          		// 결제 실패 시 URL
        
        // HttpEntity : HTTP 요청 또는 응답에 해당하는 Http Header와 Http Body를 포함하는 클래스
        HttpEntity<Map<String, String>> requestEntity = new HttpEntity<>(parameters, this.getHeaders());

        // RestTemplate
        // : Rest 방식 API를 호출할 수 있는 Spring 내장 클래스
        //   REST API 호출 이후 응답을 받을 때까지 기다리는 동기 방식 (json, xml 응답)
        // RestTemplate의 postForEntity : POST 요청을 보내고 ResponseEntity로 결과를 반환받는 메소드
        try {
            ResponseEntity<ReadyResponse> responseEntity = restTemplate.postForEntity(
                KAKAO_PAY_API_URL_READY,
                requestEntity,
                ReadyResponse.class
            );
            return responseEntity.getBody();
        } catch (HttpClientErrorException | HttpServerErrorException e) {
            log.error("카카오페이 결제 준비 실패: " + e.getMessage());
            throw new RuntimeException("카카오페이 결제 준비 실패");
            
        }}
		return null;
	}
	
	private HttpHeaders getHeaders() {
        HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", "SECRET_KEY " + REST_API_KEY); // 권한
        headers.set("Content-type", "application/json");

        return headers;
    }

	@Override
	public ApproveResponse payApprove(String tid, String pgToken, String orderId, String itemName) {
		Map<String, String> parameters = new HashMap<>();
        parameters.put("cid", KAKAO_PAY_API_ID);              					// 가맹점 코드(테스트용)
        parameters.put("tid", tid);                       						// 결제 고유번호
        parameters.put("partner_order_id", String.valueOf(orderId)); 			// 주문번호
        parameters.put("partner_user_id", utilityService.loginMember());    	// 회원 아이디
        parameters.put("pg_token", pgToken);              						// 결제승인 요청을 인증하는 토큰
        parameters.put("item_name", itemName);
        
        HttpEntity<Map<String, String>> requestEntity = new HttpEntity<>(parameters, this.getHeaders());
        
        ApproveResponse approveResponse = restTemplate.postForObject(
        		 KAKAO_PAY_API_URL_APPROVE
        		,requestEntity
        		,ApproveResponse.class);
        
        List<DirectOrderVO> orderList = orderUtil.getOrderList(tid);
        
        acountFinal(orderList);
        
        return approveResponse;
	}
	
	public PaymentCancellationVO payCancel(String orderId) {
		
		directOrderMapper.cancel(orderId);
		DirectOrderVO directOrderVO = directOrderMapper.selectOne(orderId);
		
		ItemVO itemVO = itemService.getItemById(directOrderVO.getItemId());
		itemService.updateItemAmount(itemVO.getItemAmount() - directOrderVO.getTotalCount(), directOrderVO.getItemId());
		couponActiveService.updateCouponActiveByOrderId(orderId);
		
    	Map<String, String> parameters = new HashMap<>();
    	parameters.put("cid", KAKAO_PAY_API_ID);								// 가맹점 코드(테스트용)
    	parameters.put("tid", directOrderVO.getTid());												// 결제 고유번호
    	parameters.put("cancel_amount", String.valueOf(directOrderVO.getTotalPrice()));			// 상품 총액
    	parameters.put("cancel_tax_free_amount", "0");							// 취소 비과세 금액
    	
    	HttpEntity<Map<String, String>> requestEntity = new HttpEntity<>(parameters, this.getHeaders());
    	
            ResponseEntity<PaymentCancellationVO> responseEntity = restTemplate.postForEntity(
            	KAKAO_PAY_API_URL_CANCEL,
                requestEntity,
                PaymentCancellationVO.class
            );
            String tid = SessionUtils.getStringAttributeValue("tid");
            List<DirectOrderVO> orderList = orderUtil.getOrderList(tid);
            itemService.returnItemAmount(orderList);
            return responseEntity.getBody();
        
	}
	
	public PaymentCancellationVO payRefund(String orderId) {
		
		int result = directOrderMapper.refundOK(orderId);

		if (result == 1) {
			couponActiveService.updateCouponActiveByOrderId(orderId);
		}
		
		DirectOrderVO directOrderVO = directOrderMapper.selectOne(orderId);
		
		ItemVO itemVO = itemService.getItemById(directOrderVO.getItemId());
		itemService.updateItemAmount(itemVO.getItemAmount() - directOrderVO.getTotalCount(), directOrderVO.getItemId());
		couponActiveService.updateCouponActiveByOrderId(orderId);
		
    	Map<String, String> parameters = new HashMap<>();
    	parameters.put("cid", KAKAO_PAY_API_ID);								// 가맹점 코드(테스트용)
    	parameters.put("tid", directOrderVO.getTid());												// 결제 고유번호
    	parameters.put("cancel_amount", String.valueOf(directOrderVO.getTotalPrice()));			// 상품 총액
    	parameters.put("cancel_tax_free_amount", "0");							// 취소 비과세 금액
    	
    	HttpEntity<Map<String, String>> requestEntity = new HttpEntity<>(parameters, this.getHeaders());
    	
            ResponseEntity<PaymentCancellationVO> responseEntity = restTemplate.postForEntity(
            	KAKAO_PAY_API_URL_CANCEL,
                requestEntity,
                PaymentCancellationVO.class
            );
            
            List<DirectOrderVO> orderList = new ArrayList<DirectOrderVO>();
            orderList.add(directOrderVO);
            itemService.returnItemAmount(orderList);
            return responseEntity.getBody();
        
	}

}
