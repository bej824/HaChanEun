package com.food.searcher.domain;

import java.util.Date;

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
public class DirectOrderVO {
	private String orderId;
	private String memberId;
	private int totalPrice;
	private String deliveryAddress;
	private String deliveryStatus;
	private Date deliveryDate;
	private int itemId;
	private int totalCount;
	private Date deliveryCompletedDate;
	private Date deliveryRefund;
	private String refundReason;
	private String refundContent;
	private String deliveryCompany;
	private String invoiceNumber;
	private int orderCount;
	private int couponActiveId;
}
