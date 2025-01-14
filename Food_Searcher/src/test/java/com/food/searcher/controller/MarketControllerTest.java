package com.food.searcher.controller;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;

import org.junit.jupiter.api.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.RequestBuilder;
import org.springframework.web.context.WebApplicationContext;

import com.food.searcher.config.ServletConfig;

import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class) // 스프링 JUnit test 연결 
@ContextConfiguration(classes = {ServletConfig.class}) // 설정 파일 연결
@WebAppConfiguration
@Log4j

class MarketControllerTest {

	@Autowired
	private WebApplicationContext wac; // 웹 애플리케이션 객체
	
	// 스프링 MVC를 테스트하는 mock-up 객체
	private MockMvc mock;
	

	@Test
	public void test() {
		testRegister();
	}
	
	private void testRegister() {
		log.info("testRegister()");
		
		RequestBuilder requestBuilder = post("/market/register")
				.param("marketTitle", "게시글 등록")
				.param("marketContent", "게시글 테스트")
				.param("marketLocal", "종로"); 
		// request parameter 데이터 적용
		
		try {
			log.info(mock.perform(requestBuilder).andReturn());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	
}
