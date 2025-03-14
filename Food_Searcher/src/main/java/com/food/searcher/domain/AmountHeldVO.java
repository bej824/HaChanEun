package com.food.searcher.domain;

import java.time.LocalDateTime;

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
public class AmountHeldVO {
	
	private int logId;
	private String memberId;
	private int amountHeld;
	private String logMsg;
	private LocalDateTime logDate;
	private int orderId;

}
