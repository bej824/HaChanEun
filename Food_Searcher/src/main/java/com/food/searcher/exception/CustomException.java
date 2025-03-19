package com.food.searcher.exception;

public class CustomException extends RuntimeException {
	private String errorCode;
	
	public CustomException (String msg, String errorCode) {
		super(msg);
		this.errorCode = errorCode;
	}
	
	public String getErrorCode() {
		return errorCode;
	}
	
	
}
