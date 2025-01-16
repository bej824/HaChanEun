package com.food.searcher;

import java.text.DateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;


import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.food.searcher.domain.MarketVO;
import com.food.searcher.domain.MemberVO;
import com.food.searcher.domain.RecipeVO;
import com.food.searcher.service.MarketService;
import com.food.searcher.service.RecipeService;
import com.food.searcher.util.PageMaker;
import com.food.searcher.util.Pagination;

import lombok.extern.log4j.Log4j;

/**
 * Handles requests for the application home page.
 */
@Controller
@Log4j
public class HomeController {
	
	@Autowired
	private RecipeService recipeService;
	
	@Autowired
	private MarketService marketService;
	
	MemberVO memberVO = null;
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	/**
	 * Simply selects the home view to render by returning its name.
	 */
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Locale locale, Model model) {
		logger.info("Welcome home! The client locale is {}.", locale);
		
		Date date = new Date();
		DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.LONG, locale);
		
		String formattedDate = dateFormat.format(date);
		
		model.addAttribute("serverTime", formattedDate );
		
		return "home";
	}
	
	@GetMapping("/home")
	public void main(Model model, Pagination pagination) {
		log.info("home()");
		log.info("pagination" + pagination);
		List<RecipeVO> recipeList = recipeService.getPagingBoards(pagination);
		log.info("페이징 : " + recipeList);
		
		PageMaker pageMaker = new PageMaker();
		pageMaker.setPagination(pagination);
		pageMaker.setTotalCount(recipeService.getTotalCount(pagination));
		
		model.addAttribute("pageMaker", pageMaker);
		model.addAttribute("recipeList", recipeList);
		
		List<MarketVO> marketList = marketService.getPagingMarkets(pagination);
		
		model.addAttribute("marketList", marketList);
	}
	
}
