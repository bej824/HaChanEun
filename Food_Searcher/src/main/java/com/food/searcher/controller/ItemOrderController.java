package com.food.searcher.controller;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

import com.food.searcher.service.DirectOrderService;

import lombok.extern.log4j.Log4j;

@RequestMapping("/item")
@Controller
@Log4j
public class ItemOrderController {
	
	@Autowired
	private DirectOrderService directOrderService;
	
	@PutMapping("/cancel/{orderId}")
	public ResponseEntity<Integer> cancel(@PathVariable("orderId") int orderId, @RequestBody Map<String, String> deliveryStatusMap) {
	    String deliveryStatus = deliveryStatusMap.get("deliveryStatus");
	    return new ResponseEntity<Integer>(directOrderService.cancel(deliveryStatus, orderId), HttpStatus.OK);
	}
	
	@PutMapping("/refundReady/{orderId}")
	public ResponseEntity<Integer> refundReady(@PathVariable("orderId") int orderId, @RequestBody Map<String, String> deliveryStatusMap) {
	    String deliveryStatus = deliveryStatusMap.get("deliveryStatus");
	    return new ResponseEntity<Integer>(directOrderService.refundReady(deliveryStatus, orderId), HttpStatus.OK);
	}

	@PutMapping("/refund/{orderId}")
	public ResponseEntity<Integer> refund(@PathVariable("orderId") int orderId, @RequestBody Map<String, String> deliveryStatusMap) {
	    String deliveryStatus = deliveryStatusMap.get("deliveryStatus");
	    String refundReason = deliveryStatusMap.get("refundReason");
	    String refundContent = deliveryStatusMap.get("refundContent");
	    return new ResponseEntity<Integer>(directOrderService.refund(deliveryStatus, refundReason, refundContent, orderId), HttpStatus.OK);
	}
	
	@PutMapping("/refundOK/{orderId}")
	public ResponseEntity<Integer> refundOK(@PathVariable("orderId") int orderId, @RequestBody Map<String, String> deliveryStatusMap) {
	    String deliveryStatus = deliveryStatusMap.get("deliveryStatus");
	    return new ResponseEntity<Integer>(directOrderService.refundOK(deliveryStatus, orderId), HttpStatus.OK);
	}
	
	@PutMapping("/ready/{orderId}")
	public ResponseEntity<Integer> ready(@PathVariable("orderId") int orderId, @RequestBody Map<String, String> deliveryStatusMap) {
	    String deliveryStatus = deliveryStatusMap.get("deliveryStatus");
	    return new ResponseEntity<Integer>(directOrderService.deliveryReady(deliveryStatus, orderId), HttpStatus.OK);
	}
	
	@PutMapping("/completed/{orderId}")
	public ResponseEntity<Integer> completed(@PathVariable("orderId") int orderId, @RequestBody Map<String, String> deliveryStatusMap) {
	    String deliveryStatus = deliveryStatusMap.get("deliveryStatus");
	    return new ResponseEntity<Integer>(directOrderService.deliveryCompleted(deliveryStatus, orderId), HttpStatus.OK);
	}
}
