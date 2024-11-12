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
<title>글쓰기</title>
<script>
	$(function(){ init(); });
	function init(){
		
		var formObj = $("[name='boardRegForm']");
		formObj.find("[name='writer']").val("사오정");
		formObj.find("[name='subject']").val("제목x");
		formObj.find("[name='email']").val("zxcv@naver.com");
		formObj.find("[name='content']").val("어쩌구~저쩌구~");
		formObj.find("[name='pwd']").val("1111");
		/**/
		<%
		/*
		out.print("var formObj = $('[name=boardRegForm]');");
		out.print("formObj.find('[name=writer]').val('사오정');");
		out.print("formObj.find('[name=subject]').val('제목x');");
		out.print("formObj.find('[name=email]').val('zxcv@naver.com');");
		out.print("formObj.find('[name=content]').val('어쩌구~저쩌구~');");
		out.print("formObj.find('[name=pwd]').val('1111');");
		*/
		%>
	}
	
	
	//----------------------------------------
	// 목록보기 버튼을 클릭하면 호출되는 함수
	//----------------------------------------
	function goBoardListForm(){
		// name=boardListForm  을 가지 form 태그의 
		// action 값의 URL 주소로 WAS에 접속하기
		document.boardListForm.submit();
	}
	//----------------------------------------
	// 저장 버튼을 클릭하면 호출되는 함수
	//----------------------------------------
	function checkBoardRegForm(){
		//*******************************************
		// name='boardRegForm' 가진 form 태그를 관리하는
		// JQuery 객체 생성해서 변수 formObj 에 저장하기 
		//*******************************************
		var formObj = $("[name='boardRegForm']");

		

		inputAfterBlankDel( formObj.find("[name='writer']") );
		inputAfterBlankDel( formObj.find("[name='subject']") );
		inputAfterBlankDel( formObj.find("[name='email']") );
		inputAfterBlankDel( formObj.find("[name='pwd']") );
		inputAfterBlankDel( formObj.find("[name='content']") );

		/*
		//******************************************************
		// 게시판 입력 양식의 유효성 체크하기
		//******************************************************
		if( !checkSubject(formObj.find("[name='subject']"))  ) { return; }
		if( !checkEmail(formObj.find("[name='email']"))  )     { return; }
		if( !checkPwd(formObj.find("[name='pwd']"))  )         { return; }
		if( !checkContent(formObj.find("[name='content']"))  ) { return; }
		if( !checkWriter(formObj.find("[name='writer']"))  )   { return; }
		*/
		
		
		
		//******************************************************
		// 저장 여부를 물어보기
		//******************************************************
		if( confirm("정말 등록하시겠습니까?")==false ) { return; }
		
		//*******************************************
		// WAS 로 "/boardRegProc.do" URL 주소로 접속하고
		// 입력 실행 결과 정보가 담긴 [JSON]을 받고 
		// 이 [JSON] 저장된 데이터 따라 실행구문을 달리 실행하기
		//*******************************************
		ajax(
				//-------------------------------
				// WAS 로 접속할 주소 설정
				//-------------------------------
				"/boardRegProc.do"
				//-------------------------------
				// WAS 로 접속하는 방법 설정. get 또는 post
				//-------------------------------
				,"post"
				//-------------------------------
				// 입력 양식을 끌어안고 있는 form 태그 관리 JQuery 객체 메위주
				//-------------------------------
				,formObj
				//-------------------------------
				// WAS 와 통신이 성공했을 호출되는 익명함수 설정.
				// 현재 익명함수의 매개 변수로 JSON 이 들어온다.
				// JSON 안에 입력 실행 결과 정보 담겨 있다.
				//-------------------------------
				,function(responseJson){
					//---------------------------------
					// WAS가 응답해준 JSON 에서 
					// 경고 문구 꺼내서 변수 errorMsg 에 저장하기
					// 입력된 행의 개수 꺼내서 변수 boardRegCnt 에 저장하기
					//---------------------------------
					var errorMsg    = responseJson["errorMsg"];
					var boardRegCnt = responseJson["boardRegCnt"]; 
					//---------------------------------
					// 변수 errorMsg 안에 경고 문구가 없고 
					// 변수 boardRegCnt  입력 성공 행의 개수가 1이면, 
					// 즉 입력이 성공했으면
					//---------------------------------
					if( errorMsg=="" && boardRegCnt==1 ){
						alert("${empty param.mom_b_no?'새글':'댓글'}쓰기 성공!");
						goBoardListForm();
					}	
					//---------------------------------
					// 수정된 행의 개수가 -11 이면 (즉 업로드된 파일의 크기가 너무 큰거면)
					//---------------------------------
					else if( boardRegCnt==-11 ){
						alert("업로드된 파일의 크기는 1000kb 이하이어야 합니다.");
					}
					//---------------------------------
					// 수정된 행의 개수가 -12 이면 (즉 업로드된 파일의 확장가자 틀리며)
					//---------------------------------
					else if( boardRegCnt==-12 ){
						alert("업로드된 파일의 확장자는 jpg, png, gif 이어야 합니다.");
					}
					//---------------------------------
					// 수정된 행의 개수가 -21 이면 (즉 유효성체크시 에러가 발생했으면)
					//---------------------------------
					else if( boardRegCnt==-21 ){
						if(errorMsg.indexOf("제목") ){
							$("[name=subject]").val("")
						}
						alert(errorMsg);
					}
					else{
						alert( errorMsg + ". ${empty param.mom_b_no?'새글':'댓글'}쓰기 실패!");
					}
					
				}
		);
	}
	
	
</script>

</head>
<body>
<center>
	<form name="boardRegForm">
		<table class="tableB" > 
				<caption> 
					<!------------------------------------------------------------------------>  
					<!-- 만약 파명 "mom_b_no" 의 파값이 비었으면             -->
					<!-- "[새글쓰기]" 표현하고, 아니면 "[댓글쓰기]" 표현하기 -->
					<!------------------------------------------------------------------------>  
					${empty param.mom_b_no?"[새글쓰기]":"[댓글쓰기]"}
							<!--
							----------------------------------------------------
							EL 문법에서  달러{empty 데이터1?데이터2:데이터3} ?
							----------------------------------------------------
									 EL의 삼항 연사자 표현 형식이다. 
									 데이터1 이 null 이거나 "" 이면  
									 		데이터2  표현하고
									 아니면  
									 		데이터3 표현한다.
							----------------------------------------------------
							EL 문법에서  달러{!empty 데이터1?데이터2:데이터3} ?
							----------------------------------------------------
									 EL의 삼항 연사자 표현 형식이다. 
									 데이터1 이 null 도 아니고 ""도 아니라면 (=데이터1이 비지않았으면)
									 		데이터2  표현하고
									 아니면  
									 		데이터3 표현한다.
							----------------------------------------------------
							달러{ 와 } 안의  param.mom_b_no ?
							----------------------------------------------------
									EL 문법으로 파라미터값을 표현하는 문법이다. 
									형식은   param.파명   이다
									이 URL 주소로 접속 시 가져온 파라미터값 중에  파명 "mom_b_no" 의 파값을 표현한다.	
									만약 새글 쓰러 들어 왔다면   
												파명 "mom_b_no" 의 파값은 없을 것이고		
									만약 댓글 쓰러 들어 왔다면  
												파명 "mom_b_no" 의 파값은 있다.
									파명 "mom_b_no" 의 파값은 엄마글의 고유번호이다.
							-->
					
				</caption>
				<tr>
					<th>이 름</th>
					<td  width="300px">
					<!-------------------------------------------------------->
					<input type="text" name="writer" class="writer" size="10" maxlength="15" >
					<!-------------------------------------------------------->
					</td>
				</tr>
				<tr>
					<th>제 목</th>
					<td>
					<!--------------------------------------------------------> 
					<input type="text" name="subject" class="subject" size="40" maxlength="30">
					<!-------------------------------------------------------->
					</td>
				</tr>
				<tr>
					<th>이메일</th>
					<td>
					<!-------------------------------------------------------->
					<input type="text" name="email" class="email" size="40" maxlength="50" >
					<!-------------------------------------------------------->
					</td>
				</tr>
				<tr>
					<th>내 용</th>
					<td>
					<!-------------------------------------------------------->
					<textarea name="content"  class="content" rows="13" cols="40"  
						maxlength="500"></textarea>
					<!-------------------------------------------------------->
					</td>
				</tr>
				<tr>
					<th>비밀번호</th>
					<td>
					<!-------------------------------------------------------->
					<input type="password" name="pwd" class="pwd"  size="8"  maxlength="4">
					<!-------------------------------------------------------->
					</td>
				</tr>
				<tr>
					<th>이미지</th>
					<td>
					<!-------------------------------------------------------->
					<input type="file" name="img">
					<!-------------------------------------------------------->
					</td>
				</tr>
		</table>
			<!-------------------------------------------------------->	
			<c:if test="${!empty param.mom_b_no}">
				<input type="hidden" name="mom_b_no" value="${param.mom_b_no}">
			</c:if>
			<!-------------------------------------------------------->	
			<div style="height:5px;"></div>
			<!-------------------------------------------------------->	
			<input type="button" value="저장" onClick="checkBoardRegForm();">
			<input type="reset" value="다시작성">
			<span style="cursor:pointer" onClick="goBoardListForm();">[목록보기]</span>
			<!-------------------------------------------------------->	
	</form>
	
	<!--mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm-->
	<!-- WAS에 "/boardList.do"  URL 주소로 접속하기 위한 form 태그 선언-->
	<!--mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm-->
	<form name="boardListForm" method="post" action="/boardList.do">
	</form>
</body>
</html>



































