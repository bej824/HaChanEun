package com.food.searcher.util;

import java.util.ArrayList;
import java.util.List;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

// 페이지 번호와 페이지 사이즈를 바탕으로 시작 번호와 끝 번호를 생성해주는 클래스
@Getter
@Setter
@ToString
public class Pagination {
	private int pageNum; // 현재 페이지 번호
	private int pageSize; // 현재 페이지 사이즈
	private List<String> type = new ArrayList<String>(); // 검색 항목
	private List<String> keyword = new ArrayList<String>(); // 검색 키워드

	public Pagination() {
		this.pageNum = 1; // 기본 페이지 번호 설정
		this.pageSize = 10; // 기본 페이지 사이즈 설정
	}

	public Pagination(int page, int pageSize) {
		this.pageNum = page;
		this.pageSize = pageSize;
	}

	// 선택된 페이지의 시작 글 일련번호(rn) - #{start}
	public int getStart() {
		
		if(this.pageNum <= 0) { 
			this.pageNum = 1;
		}
		if(this.pageSize <= 0) {
			this.pageSize = 5;
		}
		
		return (this.pageNum - 1) * this.pageSize + 1;
	}

	// 선택된 페이지의 마지막 글 일련번호(rn) - #{end}
	public int getEnd() {
		
		if(this.pageNum <= 0) {
			this.pageNum = 1;
		}
		if(this.pageSize <= 0) {
			this.pageSize = 5;
		}
		
		return this.pageNum * this.pageSize;
	}

} // end Pagination
