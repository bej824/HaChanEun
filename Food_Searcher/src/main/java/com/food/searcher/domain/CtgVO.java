package com.food.searcher.domain;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@ToString
public class CtgVO {
	
	private String memberId;
	private String mainCtg;
	private String subCtg;
	private int ctgViewCount;
	private Date updateDate;
	
	private int localId;

}
