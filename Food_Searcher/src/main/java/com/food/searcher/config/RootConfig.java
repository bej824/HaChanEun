package com.food.searcher.config;

import java.util.Properties;

import javax.sql.DataSource;

import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.EnableAspectJAutoProxy;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.concurrent.ThreadPoolTaskScheduler;
import org.springframework.transaction.PlatformTransactionManager;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

// root-context.xml과 동일
@Configuration
@EnableScheduling
@ComponentScan(basePackages = {"com.food.searcher.service"})
@MapperScan(basePackages = {"com.food.searcher.persistence"})
@ComponentScan(basePackages = {"com.food.searcher.aspect"})
@EnableAspectJAutoProxy
// 패키지 경로로 Mapper 스캐닝
public class RootConfig {
	
	@Bean // 스프링 bean으로 설정. xml의 <bean>태그와 동일
	public DataSource dataSource() { // DataSource 객체 리턴 메소드
		// HikariConfig : DBCP 라이브러리
		HikariConfig config = new HikariConfig(); // 설정 객체
		config.setDriverClassName("oracle.jdbc.OracleDriver");
		config.setJdbcUrl("jdbc:oracle:thin:@192.168.0.155:1521:xe");
		config.setUsername("STUDY"); // DB 사용자 아이디
		config.setPassword("1234"); // DB 사용자 비밀번호
		
		config.setMaximumPoolSize(10); // 최대 풀(pool) 크기 설정
		config.setConnectionTimeout(30000); // Connection 타임 아웃 설정(30초)
		HikariDataSource ds = new HikariDataSource(config);
		
		return ds; // ds 객체 리턴
	}
	
	@Bean
	public SqlSessionFactory sqlSessionFactory() throws Exception {
		SqlSessionFactoryBean sqlSessionFactoryBean = new SqlSessionFactoryBean();
		sqlSessionFactoryBean.setDataSource(dataSource());
		return (SqlSessionFactory) sqlSessionFactoryBean.getObject();
	}
	
	// 트랜잭션 매니저 객체를 빈으로 등록
	@Bean
	public PlatformTransactionManager transactionManager() {
		return new DataSourceTransactionManager(dataSource());
	}
	
	// 이메일 인증
	 @Bean
	    public JavaMailSender mailSender() {
	        JavaMailSenderImpl mailSender = new JavaMailSenderImpl();
	        
	        // SMTP 서버 설정
	        mailSender.setHost("smtp.gmail.com");
	        mailSender.setPort(587);
	        mailSender.setUsername("hachaneun3@gmail.com");
	        mailSender.setPassword("ywrvbyzicdmfouni");
	        mailSender.setDefaultEncoding("utf-8");

	        /// JavaMailProperties 설정
	        Properties javaMailProperties = new Properties();
	        javaMailProperties.put("mail.smtp.auth", "true");  // SMTP 인증 사용
	        javaMailProperties.put("mail.smtp.starttls.enable", "true");  // TLS 사용
	        javaMailProperties.put("mail.debug", "false");  // 디버그 모드 (옵션)

	        mailSender.setJavaMailProperties(javaMailProperties);
	        
	        return mailSender;
	    }
	 
	    // ThreadPoolTaskScheduler를 사용하여 스케줄러 빈 설정
	    @Bean
	    public ThreadPoolTaskScheduler taskScheduler() {
	        ThreadPoolTaskScheduler scheduler = new ThreadPoolTaskScheduler();
	        scheduler.setPoolSize(10); // 스레드 풀의 크기 설정
	        scheduler.setThreadNamePrefix("scheduled-task-"); // 스레드 이름 접두어 설정
	        scheduler.initialize();
	        return scheduler;
	    }
	
} // end RootConfig
