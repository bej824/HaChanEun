package com.food.searcher.config;

import javax.sql.DataSource;

import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.EnableAspectJAutoProxy;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.transaction.PlatformTransactionManager;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

// root-context.xml과 동일
@Configuration
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
		config.setJdbcUrl("jdbc:oracle:thin:@localhost:1521:xe");
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
} // end RootConfig
