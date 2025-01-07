package com.food.searcher.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestTemplate;

import com.food.searcher.util.EmailAuthUtil;

@Configuration
public class RestTemplateConfig {
    @Bean
    public RestTemplate restTemplate() {
        return new RestTemplate();
    }
    
    @Bean
    public EmailAuthUtil emailAuthUtil() {
        return new EmailAuthUtil();
    }
}
