package com.naver.erp;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

//MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
//개발자가 만든 SessionInterceptor 클래스를 
// [인터셉터]로 등록하기 위한 MvcConfiguration 클래스 선언하기
// 즉 설정을 위한 클래스이다.
//MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
@Configuration
	//-------------------------------------------
	// @Configuration ?
	//-------------------------------------------
		// 클래스 앞에 붙는다.
		// @Configuration 이 붙은 클래스는 자동 객체화 되어 스프링이 관리한다.
		// @Configuration 이 붙은 클래스는 설정 관련 메소드를 소유하고 있다.
		// @Configuration 이 붙은 WebMvcConfigurer 인터페이스를 구현한다.
public class MvcConfiguration implements WebMvcConfigurer{
	//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	// SessionInterceptor 객체를 인터셉터로 등록하는 코딩이 내포된 
	// addInterceptors 메서드를 오버라이딩한다
	//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	@Override
	public void addInterceptors(InterceptorRegistry registry) {
		//---------------------------------------------------
		// InterceptorRegistry 객체의 
		// addInterceptor      메소드를 호출하여 SessionInterceptor 객체를 인터셉터로 등록하고
		// excludePathPatterns 메소드를 호출하여 예외되는 URL 주소 패턴을 등록한다.
		//---------------------------------------------------
		registry.addInterceptor(new SessionInterceptor()).excludePathPatterns(
				"/loginForm.do"
				,"/loginProc.do"
				,"/js/**"
				,"/css/**"
		);
	}
}






