package com.food.searcher.domain;

import java.util.Date;

import org.springframework.web.multipart.MultipartFile;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@NoArgsConstructor
@Getter 
@Setter
@ToString 

public class MarketAttachVO {
	private int attachId;
	private int marketId;
	private String attachPath;
	private String attachRealName;
	private String attachChgName;
	private String attachExtension;
	private Date attachDateCreated;
		
}
