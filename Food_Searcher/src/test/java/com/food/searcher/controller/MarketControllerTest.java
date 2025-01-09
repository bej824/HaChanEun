package com.food.searcher.controller;

import static org.junit.jupiter.api.Assertions.fail;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.view;

import org.junit.jupiter.api.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.RequestBuilder;
import org.springframework.web.bind.annotation.PostMapping;
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
		
	
/*	@Test
	void testModifyGET() {
		log.info("testModifyGet()");
		RequestBuilder requestBuilder = get("/market/modify");
		
		try {
			log.info(mock.perform(requestBuilder) // mock 객체 실행
					.andReturn() // request 실행 결과 리턴
					.getModelAndView()); // ModelAndView 객체 리턴
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}

	@Test
	void testModifyPOST() {
		fail("Not yet implemented");
	}
*/
	@Test
	void testDelete() {
		/*
		@PostMapping("/delete")
		public String delete(Integer marketId) {
		log.info("delete()");
		int result = marketService.deleteMarket(marketId);
		log.info(result + "행 삭제");
		return "redirect:/market/list";
		} 
		*/
		log.info("testModifyGet()");
		RequestBuilder requestBuilder = get("/market/delete");
		try {
			log.info(mock.perform(requestBuilder) // mock 객체 실행
					.andReturn() // request 실행 결과 리턴
					.getModelAndView()); // ModelAndView 객체 리턴
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}

}
