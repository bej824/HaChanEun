package com.food.searcher.domain;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@ToString
public class PaymentCancellationVO {
	private String cid; // 가맹점 코드, 10자
	private String cid_secret; // 가맹점 코드 인증키, 24자, 숫자+영문 소문자 조합
	private String tid; // 결제 고유번호, 20자
	private int cancel_amount; // 취소 금액
	private int cancel_tax_free_amount; // 취소 비과세 금액
	private int cancel_vat_amount; // 취소 부가세 금액
	private int cancel_available_amount; // 취소 가능 금액(결제 취소 요청 금액 포함)
	private String payload; // 해당 요청에 대해 저장하고 싶은 값, 최대 200자
}
