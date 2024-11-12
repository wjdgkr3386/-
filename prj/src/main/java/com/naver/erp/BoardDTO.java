package com.naver.erp;

import java.util.List;
import java.util.Map;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Pattern;
import javax.validation.constraints.Size;

import org.springframework.web.multipart.MultipartFile;

//MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
// BoardDTO 클래스 선언
// 1개의 게시판 글 정보가 저장되는 클래스이다.
//MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
public class BoardDTO {

	//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	// 파명 "b_no" 에 대응하는 파값이 저장되는 멤버변수 선언하기
	// 파명 "subject" 에 대응하는 파값이 저장되는 멤버변수 선언하기
	// 파명 "content" 에 대응하는 파값이 저장되는 멤버변수 선언하기
	// 파명 "writer" 에 대응하는 파값이 저장되는 멤버변수 선언하기
	// 파명 "email" 에 대응하는 파값이 저장되는 멤버변수 선언하기
	// 파명 "pwd" 에 대응하는 파값이 저장되는 멤버변수 선언하기
	// 파명 "readcount" 에 대응하는 파값이 저장되는 멤버변수 선언하기
	// 파명 "reg_date" 에 대응하는 파값이 저장되는 멤버변수 선언하기
	// 파명 "group_no" 에 대응하는 파값이 저장되는 멤버변수 선언하기
	// 파명 "print_no" 에 대응하는 파값이 저장되는 멤버변수 선언하기
	// 파명 "print_level" 에 대응하는 파값이 저장되는 멤버변수 선언하기
	// 파명 "mom_b_no" 에 대응하는 파값이 저장되는 멤버변수 선언하기
	//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	private int b_no;
	

	//--------------------------------------
	// 멤버변수 subject 에 저장된 파라미터값의 
	// 유효성 체크 실행 어노테이션 선언하기
	// <주의>유효성 체크 실행 결과 메시지는 BindingResult 객체가 관리한다.
	//--------------------------------------
	@NotEmpty(message="제목은 필수 입력입니다.")
	@NotNull(message="제목은 필수 입력입니다.")
	@NotBlank(message="제목은 공백으로 구성되면 안됩니다.")
	@Size(min=2, max=30, message="제목은  2~30자 입니다.")
	@Pattern(regexp="^[^><]{2,30}$", message = "제목은  2~30자 이고 < 또는 > 단어가 들어갈수 없습니다. 재입력 요망")
	private String subject;
	

	//--------------------------------------
	// 멤버변수 content 에 저장된 파라미터값의 유효성 체크 실행 어노테이션 선언하기
	// <주의>유효성 체크 실행 결과 메시지는 BindingResult 객체가 관리한다.
	//--------------------------------------
	@NotEmpty(message="내용은 필수 입력입니다.")
	@NotNull(message="내용은 필수 입력입니다.")
	@NotBlank(message="내용은 공백으로 구성되면 안됩니다.")
	@Size(min=1, max=500, message="내용은  1~500자 입니다.")
	@Pattern(regexp="^[^><]{1,500}$", message = "내용은  1~500자 이고 < 또는 > 단어가 들어갈수 없습니다. 재입력 요망")
	private String content;

	//--------------------------------------
	// 멤버변수 writer 에 저장된 파라미터값의 유효성 체크 실행 어노테이션 선언하기
	// <주의>유효성 체크 실행 결과 메시지는 BindingResult 객체가 관리한다.
	//--------------------------------------
	@NotEmpty(message="[작성자명]은 필수 입력입니다.")
	@NotNull(message="[작성자명]은 필수 입력입니다.")
	@NotBlank(message="[작성자명]은 공백으로 구성되면 안됩니다.")
	@Size(min=2, max=15, message="작성자명은 2~15자 입니다.")
	@Pattern(regexp="^[가-힣a-zA-Z]{2,15}$"
			, message = "작성자명은 2~15자 이고 영소대문자,한글 로 만 구성되야 합니다.")
	private String writer;
	
	//--------------------------------------
	// 멤버변수 email 에 저장된 파라미터값의 유효성 체크 실행 어노테이션 선언하기
	// <주의>유효성 체크 실행 결과 메시지는 BindingResult 객체가 관리한다.
	//--------------------------------------
	@NotEmpty(message="이메일은 필수 입력입니다.")
	@NotNull(message="이메일은 필수 입력입니다.")
	@NotBlank(message="이메일은 공백으로 구성되면 안됩니다.")
	@Pattern(regexp="^([0-9a-zA-Z_-]+)@([0-9a-zA-Z_-]+)(\\.[0-9a-zA-Z_-]+){1,2}$"
							, message = "이메일 형식에 맞지 않습니다. 재입력 요망!")
	private String email;

	//--------------------------------------
	// 멤버변수 pwd에 저장된 파라미터값의 유효성 체크 실행 어노테이션 선언하기
	// <주의>유효성 체크 실행 결과 메시지는 BindingResult 객체가 관리한다.
	//--------------------------------------
	@NotEmpty(message="암호는 필수 입력입니다.")
	@NotNull(message="암호는 필수 입력입니다.")
	@NotBlank(message="암호는 공백으로 구성되면 안됩니다.")
	@Pattern(regexp="^[0-9a-z]{4}$"
				, message = "암호는 영소문 또는 숫자로 구성되고 4자 입력 해야합니다.")
	//--------------------------------------
	private String pwd;

	private int readcount;
	private String reg_date;
	private int group_no;
	private int print_no;
	private int print_level;

	
	
	
	private int mom_b_no;
	
	//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	//파일업로드 관련 멤버변수 들 선언
	//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
		// 파일업로드된 파일을 관리하는 MultipartFile 객체 저장 매개변수 img 선언
		// 파일업로드된 파일의 새 이름을 저장할 img_name 멤버변수 선언
	private MultipartFile img;
	private String img_name;

	private String isdel;
	
	

	//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	
	public int getB_no() {
		return b_no;
	}
	public void setB_no(int b_no) {
		this.b_no = b_no;
	}
	public String getSubject() {
		return subject;
	}
	public void setSubject(String subject) {
		this.subject = subject;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getWriter() {
		return writer;
	}
	public void setWriter(String writer) {
		this.writer = writer;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getPwd() {
		return pwd;
	}
	public void setPwd(String pwd) {
		this.pwd = pwd;
	}
	public int getReadcount() {
		return readcount;
	}
	public void setReadcount(int readcount) {
		this.readcount = readcount;
	}
	public String getReg_date() {
		return reg_date;
	}
	public void setReg_date(String reg_date) {
		this.reg_date = reg_date;
	}
	public int getGroup_no() {
		return group_no;
	}
	public void setGroup_no(int group_no) {
		this.group_no = group_no;
	}
	public int getPrint_no() {
		return print_no;
	}
	public void setPrint_no(int print_no) {
		this.print_no = print_no;
	}
	public int getPrint_level() {
		return print_level;
	}
	public void setPrint_level(int print_level) {
		this.print_level = print_level;
	}
	public int getMom_b_no() {
		return mom_b_no;
	}
	public void setMom_b_no(int mom_b_no) {
		this.mom_b_no = mom_b_no;
	}
	public MultipartFile getImg() {
		return img;
	}
	public void setImg(MultipartFile img) {
		this.img = img;
	}
	public String getImg_name() {
		return img_name;
	}
	public void setImg_name(String img_name) {
		this.img_name = img_name;
	}
	

	public String getIsdel() {
		return isdel;
	}
	public void setIsdel(String isdel) {
		this.isdel = isdel;
	}
	
	
	
	
	
	
	
}
