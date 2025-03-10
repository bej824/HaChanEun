package com.food.searcher.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import lombok.extern.log4j.Log4j;

@Service
@Log4j
public class KakaoPayService {

    @Autowired
    private RestTemplate restTemplate;

    private static final String KAKAO_PAY_API_URL = "https://kapi.kakao.com/v1/payment/ready";
    private static final String REST_API_KEY = "8c6c98ec9612e8d3b4936d3ba36b726b"; // 카카오 개발자 사이트에서 받은 REST API 키

    // 카카오페이 결제 준비 API 호출
    public String preparePayment() {
        // 결제 준비 API 요청 파라미터 설정
        String requestBody = "cid=TC0ONETIME" // 가맹점 코드
                            + "&partner_order_id=1234" // 가맹점 주문 번호
                            + "&partner_user_id=abcd1234" // 가맹점 사용자 ID
                            + "&item_name=테스트 상품" // 상품명
                            + "&quantity=1"  // 상품 수량
                            + "&total_amount=1000"  // 총 결제 금액
                            + "&tax_free_amount=0"  // 면세 금액
                            + "&approval_url=localhost:8080/searcher/kakaoPay/success" // 결제 승인 후 리디렉션 URL
                            + "&cancel_url=localhost:8080/searcher/kakaoPay/cancel"  // 결제 취소 후 리디렉션 URL
                            + "&fail_url=localhost:8080/searcher/kakaoPay/fail";  // 결제 실패 후 리디렉션 URL

        log.info("requestBody : " + requestBody);
        
        // HTTP 헤더 설정
        HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", "Bearer " + REST_API_KEY);
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
        log.info("headers : " + headers);

        // 요청 엔티티 생성
        HttpEntity<String> entity = new HttpEntity<>(requestBody, headers);
        log.info("entity : " + entity);

        // API 호출 (POST 요청, 응답은 String 형태로 받음)
        String responseBody = restTemplate.postForObject(KAKAO_PAY_API_URL, entity, String.class);
        log.info("response : " + responseBody);

        // 응답에서 결제 승인 페이지 URL 추출
        String redirectUrl = extractRedirectUrl(responseBody);

        // 결제 승인 페이지 URL 반환
        return redirectUrl;
    }


    // 응답에서 결제 승인 페이지 URL 추출
    private String extractRedirectUrl(String responseBody) {
        // 응답 본문에서 "next_redirect_pc_url"을 추출
        // 이 부분은 JSON 파싱을 위해 라이브러리(Jackson 등)을 사용하는 것이 좋습니다
        // 예시로 간단히 substring으로 처리
        int startIdx = responseBody.indexOf("next_redirect_pc_url\":\"") + 23;
        int endIdx = responseBody.indexOf("\"", startIdx);
        return responseBody.substring(startIdx, endIdx);
    }
    
    public String approvePayment(String pgToken) {
        String requestBody = "cid=TC0ONETIME&tid=1234567890&partner_order_id=1234&partner_user_id=abcd1234&pg_token=" + pgToken;

        HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", "KakaoAK " + REST_API_KEY);
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

        HttpEntity<String> entity = new HttpEntity<>(requestBody, headers);

        ResponseEntity<String> response = restTemplate.exchange("https://kapi.kakao.com/v1/payment/approve", HttpMethod.POST, entity, String.class);

        return response.getBody();
    }

}

