package com.food.searcher.domain;

import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@ToString
public class LocalSpecialityVO {
	
	private String localId;
	private String localLocal;
	private String localDistrict;
	private String localTitle;
	private String localContent;
	private String mainCtg;
	private String subCtg;

}
