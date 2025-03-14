package com.food.searcher.service;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.HttpServerErrorException;
import org.springframework.web.client.RestTemplate;

import com.food.searcher.domain.ApproveResponse;
import com.food.searcher.domain.ReadyResponse;

import lombok.extern.log4j.Log4j;

@Service
@Log4j
public class KakaoPayService {

    @Autowired
    private RestTemplate restTemplate;
    
    @Autowired
    private UtilityService utilityService;
    
    private static final String KAKAO_PAY_API_ID = 
    		"TC0ONETIME";
    
    private static final String KAKAO_PAY_API_URL_READY = 
    		"https://open-api.kakaopay.com/online/v1/payment/ready";
    
    private static final String KAKAO_PAY_API_URL_APPROVE = 
    		"https://open-api.kakaopay.com/online/v1/payment/approve";
    
    private static final String REST_API_KEY = 
    		"DEV68BCC7625BFB142057D59F4EAB9E0F6FC888E"; // 카카오 개발자 사이트에서 받은 REST API 키

    // 카카오페이 결제창 연결
    public ReadyResponse payReady(String orderId, String itemName, int totalPrice) {
    
        Map<String, String> parameters = new HashMap<>();
        parameters.put("cid", KAKAO_PAY_API_ID);                                // 가맹점 코드(테스트용)
        parameters.put("partner_order_id", String.valueOf(orderId));            // 주문번호
        parameters.put("partner_user_id", utilityService.loginMember());        // 회원 아이디
        parameters.put("item_name", String.valueOf(itemName));                                  // 상품명
        parameters.put("quantity", "1");                                        // 단건 결제(대량 구매여도 결제는 1번만 되므로)
        parameters.put("total_amount", String.valueOf(totalPrice));             // 상품 총액
        parameters.put("tax_free_amount", "0");                                 // 상품 비과세 금액
        parameters.put("approval_url", "http://localhost:8080/searcher/pay/completed"); 		// 결제 성공 시 URL
        parameters.put("cancel_url", "http://localhost:8080/searcher/pay/cancel");      		// 결제 취소 시 URL
        parameters.put("fail_url", "http://localhost:8080/searcher/pay/fail");          		// 결제 실패 시 URL

        log.info(parameters);
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
            log.info("결제준비 응답객체: " + responseEntity.getBody());
            return responseEntity.getBody();
        } catch (HttpClientErrorException | HttpServerErrorException e) {
            log.error("카카오페이 결제 준비 실패: " + e.getMessage());
            throw new RuntimeException("카카오페이 결제 준비 실패");
        }
    }

    // 카카오페이 결제 승인
    // 사용자가 결제 수단을 선택하고 비밀번호를 입력해 결제 인증을 완료한 뒤,
    // 최종적으로 결제 완료 처리를 하는 단계
    public ApproveResponse payApprove(String tid, String pgToken, String orderId) {
    	log.info("approve");
        Map<String, String> parameters = new HashMap<>();
        parameters.put("cid", KAKAO_PAY_API_ID);              					// 가맹점 코드(테스트용)
        parameters.put("tid", tid);                       						// 결제 고유번호
        parameters.put("partner_order_id", String.valueOf(orderId)); 			// 주문번호
        parameters.put("partner_user_id", utilityService.loginMember());    	// 회원 아이디
        parameters.put("pg_token", pgToken);              						// 결제승인 요청을 인증하는 토큰

        log.info(parameters);
        HttpEntity<Map<String, String>> requestEntity = new HttpEntity<>(parameters, this.getHeaders());
        log.info(requestEntity);
        
        RestTemplate template = new RestTemplate();
        ApproveResponse approveResponse = template.postForObject(
        		 KAKAO_PAY_API_URL_APPROVE
        		,requestEntity
        		,ApproveResponse.class);
        log.info("결제승인 응답객체: " + approveResponse);

        return approveResponse;
    }
    
//    public int payCancle() {
//    	PaymentCancelRequest request = new PaymentCancelRequest();
//    	request.setTid("exampleTid");
//    	request.setCancelAmount(10000);    	
//    }
    
    // 카카오페이 측에 요청 시 헤더부에 필요한 값
    private HttpHeaders getHeaders() {
        HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", "SECRET_KEY " + REST_API_KEY); // 권한
        headers.set("Content-type", "application/json");
//        headers.setContentType(MediaType.APPLICATION_JSON);

        return headers;
    }

}

