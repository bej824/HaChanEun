package com.food.searcher.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.food.searcher.domain.ApproveResponse;
import com.food.searcher.domain.CartVO;
import com.food.searcher.domain.DirectOrderVO;
import com.food.searcher.domain.ItemAttachVO;
import com.food.searcher.domain.MemberVO;
import com.food.searcher.service.CartService;
import com.food.searcher.service.DirectOrderService;
import com.food.searcher.service.ItemAttachService;
import com.food.searcher.service.MemberService;
import com.food.searcher.util.SessionUtils;

import lombok.extern.log4j.Log4j;

@RequestMapping("/cart")
@Controller
@Log4j
public class CartController {
	
	@Autowired
	private CartService cartService;
	
	@Autowired
	private DirectOrderService directOrderService;
	
	@Autowired
	private ItemAttachService attachService;
	
	@Autowired
	private MemberService memberService;
	
	@GetMapping("/list/{memberId}")
	public String cartList (Model model, @PathVariable("memberId") String memberId) {
		log.info("cartList()");
		List<CartVO> cartVO = cartService.getCartById(memberId);
		log.info(cartVO);
		model.addAttribute("cartVO", cartVO);
		MemberVO member = memberService.getMemberById(memberId);
		model.addAttribute("member", member);
		
		List<ItemAttachVO> list = new ArrayList<ItemAttachVO>();
		for(CartVO vo : cartVO) {
			List<ItemAttachVO> attachVO = attachService.getItemById(vo.getItemId());
			log.info(attachVO);
			list.addAll(attachVO);
		}
		model.addAttribute("attachVO", list);
		return "cart/list";
	}
	
	@ResponseBody
	@PostMapping("/list/{memberId}")
	public String cartOrder(@RequestBody List<DirectOrderVO> directOrderVO) {
		log.info(directOrderVO);
		int result = directOrderService.cartOrder(directOrderVO);
		log.info(result);
		String next_redirect_pc_url = SessionUtils.getStringAttributeValue("next_redirect_pc_url");
		return next_redirect_pc_url;
	}
	
	@PostMapping("/add")
	@ResponseBody
	public String addCartPOST(CartVO cartVO) {
		int result = cartService.createCart(cartVO);
		return result + "";
	}
	
	@DeleteMapping("/delete/{cartId}")
	public ResponseEntity<Integer> deleteCart(CartVO cartVO, @PathVariable("cartId") int cartId) {
		      log.info("deleteCart()");
		      
		      return new ResponseEntity<Integer>(cartService.deleteCart(cartId), HttpStatus.OK);
	}
	
	@PutMapping("/update/{cartId}")
	public ResponseEntity<Integer> updateAmount(@PathVariable("cartId") int cartId,
											 	@RequestBody int cartAmount) {
		log.info("cartId : " + cartId);
		log.info("cartAmount : " + cartAmount);
		int result = cartService.updateAmount(cartId, cartAmount);
		return new ResponseEntity<Integer>(result, HttpStatus.OK);
	}
	
	@PutMapping("list/{memberId}/checked")
	public ResponseEntity<Integer> updateChecked(@PathVariable("memberId") String memberId, 
	                                              @RequestBody CartVO cartVO) {
	    log.info("checked");
	    
	    return new ResponseEntity<>(cartService.updateChecked(cartVO.getCartChecked(), cartVO.getCartId()), HttpStatus.OK);
	}
	
	@GetMapping("/completed")
    public String completed(@RequestParam("pg_token") String pg_token, Model model) {
    	String tid = SessionUtils.getStringAttributeValue("tid");
    	String orderId = SessionUtils.getStringAttributeValue("partner_order_id");
    	String itemName = SessionUtils.getStringAttributeValue("item_name");
        // 결제 승인 처리 API 호출
        ApproveResponse approvalResult = directOrderService.payApprove(tid, pg_token, orderId, itemName);
        
        model.addAttribute("response", approvalResult);
        
        // 결제 승인 결과 반환
        return "redirect:/item/approve?pg_token="+pg_token;
    }
	
	@GetMapping("/approve")
    public void approve() {
    	
    }
	
} //end CartController
