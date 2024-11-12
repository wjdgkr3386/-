<!--mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm-->
<!-- JSP 기술의 한 종류인 [Page Directive]를 이용하여 현 JSP 페이지 처리 방식 선언하기 -->
<!--mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm-->
	<!-- 현재 이 JSP 페이지 실행 후 생성되는 문서는 HTML 이고,이 문서 안의 데이터는 UTF-8 방식으로 인코딩한다 라고 설정함 -->
	<!-- 현재 이 JSP 페이지를 저장할때는 UTF-8 방식으로 인코딩 한다 -->
	<!-- 모든 JSP 페이지 상단에 무조건 아래 설정이 들어간다. -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!--mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm-->
<!-- JSP 기술의 한 종류인 [Include Directive]를 이용하여 -->
<!-- common.jsp 파일 내의 소스를 삽입하기 -->	
<!--mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm-->   
<%@include file="/WEB-INF/views/common.jsp" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>

<script>
	//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	// body 태그 안의 모든 내용을 읽어들인 이후 init 함수 호출하기
	//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	$(function(){   init();  })
	//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	// body 태그 안의 모든 내용을 읽어들인 이후 호출할 자스 코딩 설정하기
	//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	function init(){	
		//-----------------------------------------------------
		// class=loginBtn 가진 태그에 클릭 이벤트가 
		// 발생하면 checkLoginForm() 함수 호출하기
		//-----------------------------------------------------
		$(".loginBtn").bind("click",function(){
			checkLoginForm();			
		});
		//-----------------------------------------------------
		// 접속한 클라이언트가 가져온 쿠키중에 쿠키명 "mid" 에 대응하는  쿠키값을 
		//		EL 문법으로 꺼내서 
		//		아이디 입력란에 삽입하기.
		// 접속한 클라이언트가 가져온 쿠키중에 쿠키명 "pwd" 에 대응하는  쿠키값을 
		//		EL 문법으로 꺼내서 
		//		아이디 입력란에 삽입하기.
		//-----------------------------------------------------
		$("[name='mid']").val("${cookie.mid.value}");
		$("[name='pwd']").val("${cookie.pwd.value}");
	
		//-----------------------------------------------------
		// 접속한 클라이언트가 가져온 쿠키중에 쿠키명 "mid" 에 대응하는  
		//		쿠키값이 있으면
		//				name='autoLogin' 가진 checkbox 체크하기
		//		쿠키값이 없으면
		//				name='autoLogin' 가진 checkbox 체크풀기
		//-----------------------------------------------------
		$("[name='autoLogin']").prop("checked", ${empty cookie.mid.value?false:true} );

	}
	
	//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	// 입력한 아이디와 암호의 유효성 체크하는 함수 선언하기
	// 로그인 버튼을 클릭하면 호출되는 함수
	//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	function checkLoginForm(){	
		//-----------------------------------------------------
		// 입력한 아이디 읽어와서 변수 mid 에 저장하기
		// 만약에 변수 mid 에 문자가 아닌 데이터가 있다면 "" 로 갱신하기
		// 변수 mid 안의 앞뒤 공백제거 하기
		//-----------------------------------------------------
		var mid = $("[name='mid']").val();
		if( typeof(mid)!="string" ) { mid=""; }
		mid = $.trim(mid);
		//mid = mid.trim() 도 같은건데 구익스플로러에서는 안돌아가서 위 코드를 쓴다.
		

		//-----------------------------------------------------
		// 입력한 암호 읽어와서 변수 pwd 에 저장하기
		// 만약에 변수 pwd 에 문자가 아닌 데이터가 있다면 "" 로 갱신하기
		// 변수 pwd 안의 앞뒤 공백제거 하기
		// 로그인할때 아이디,비번을 친절하게 설명해주지 않는다. 예// 아이디는 2~15자 사이여야하고~...
		//-----------------------------------------------------
		var pwd = $("[name='pwd']").val();
		if( typeof(pwd)!="string" ) { pwd=""; }
		pwd = $.trim(pwd);
		//-----------------------------------------------------
		// 만약에 아이디가 비어 있으면 경고하고 함수 중단하기
		//-----------------------------------------------------
		if( mid=="" ){
			alert("아이디가 비어 있음! 입력 바람");
			return;
		}
		//-----------------------------------------------------
		// 만약에 암호가 비어 있으면 경고하고 함수 중단하기
		//-----------------------------------------------------
		if( pwd=="" ){
			alert("암호가 비어 있음! 입력 바람");
			return;
		}

		//*******************************************************
		// 개발자 정의 함수인 ajax 함수 호출하여 
		// 			WAS 에   /loginProc.do  로 접속하여
		// 			아이디, 암호의 존재 개수를 얻는다.
		// 			존재 개수가 1이면 
		// 				WAS 에   /boardList.do  로 접속하여 게시판 검색 화면 HTML 을 연다.
		// 			존재 개수가 0이면 
		// 				경고 창이 뜬다.
		//*******************************************************
		ajax(
				//------------------------------------------
				// WAS 에 접속할 떄 사용할 URL 주소 지정
				//------------------------------------------
				"/loginProc.do"
				//------------------------------------------
				// WAS 에 전송할 파라미터값 을 보내는 방법 지정
				//------------------------------------------
				,"post"
				//------------------------------------------
				// form 태그 관리하는  JQuery 객체 메위주
				// 아래 form태그 안에 있는 모든 네임값과 밸류값을 WAS로 전송한다.
				//------------------------------------------
				,$("[name='loginForm']")
				//----------------------------------------------------------
				// WAS 와 통신한 후 WAS의 응답을 성공적으로 받았을 경우 실행할 익명함수 설정.
				// 익명함수의 매개변수에는 WAS 가 보내온 [아이디 암호의 존재 개수]가 들어온다
				// 응답을 받으면 실행되는 익명함수이다.
				// 저쪽에서 어떻게 돌아가는지는 신경쓰지말고 보낼값과 리턴값만 생각하기
				//----------------------------------------------------------
				,function(idCnt){
					// 만약에 매개변수 idCnt 에 1이 있으면
					// 즉 아이디와 암호가 DB에 존재하면
					// 즉 로그인 성공했으면
					if( idCnt==1 ){
						//-----------------------------------------------------
						// WAS 에  "/boardList.do" URL 주소로 접속 시도하기
						//-----------------------------------------------------
						location.replace("/boardList.do");
								// ---------------------------------------------------------------------
								// location.replace("/boardList.do"); 명령어로 WAS 로 접속할 때 특징
								// ---------------------------------------------------------------------
									//  get 방식으로 접속함.
									//  파라미터값은 전혀 없음
									//  만약 파라미터값은 보내고 싶다면
										//  location.replace("/boardList.do?xxx=yyy"); 꼐 해야함
					}
					// 만약에 매개변수 idCnt 에 1이 아니면
					// 즉 아이디와 암호가 DB 에 존재하지 않으면
					// 즉 로그인이 실패 했으면
					// 즉 입력한 아이디와 암호가 DB 에 없으면
					else{
						alert("로그인 실패! 아이디 또는 암호가 틀립니다. 재입력해 주십시요!");
					}
				}
		);
	}			
	
</script>

</head>
<body>
	<center>
		<form name="loginForm">
			<table class="tableA11" >
				<caption><b>[로그인]</b></caption>
				<tr>
					<th bgcolor="lightgray">아이디</th> 
					<td>
						<!------------------------------->
						<input type="text" name="mid">
						<!------------------------------->
					</td> 
				</tr> 
				<tr>
					<th bgcolor="lightgray">암 호</th> 
					<td>
						<!------------------------------->
						<input type="password" name="pwd">
						<!------------------------------->
					</td> 
				</tr> 
			</table>
			<div style="height:5px"></div>
			<!------------------------------->
			<input type="checkbox" name="autoLogin" value="yes" class="autoLogin">아이디/암호 자동입력<br>
			<!------------------------------->
			<div style="height:5px"></div>
			<input type="button" value="로그인" class="loginBtn">
		</form>
	</center>
</body>
</html>














