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
	function goBoardListForm(){
		document.boardListForm.method="post";
		document.boardListForm.action="/boardList.do";
		document.boardListForm.submit();
	}

	//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	// 수정 버튼 클릭 시 호출되는  함수 선언
	//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	function checkBoardUpForm(){

			var formObj = $("[name='boardUpDelForm']");
			
			//*******************************************
			// 게시판 입력 양식의 유효성 체크하기
			//*******************************************
			if( !checkSubject(formObj.find("[name='subject']"))  ) { return; }
			if( !checkEmail(formObj.find("[name='email']"))  )     { return; }
			if( 
					checkVal(
						formObj.find("[name='pwd']")
						,"암호입력바람"
						,new RegExp(/[^ ]+/)
					)==false
			){
				return;
			}
			if( !checkContent(formObj.find("[name='content']"))  ) { return; }
			if( !checkWriter(formObj.find("[name='writer']"))  )   { return; }
			
			//*******************************************
			// [수정 여부]를 물어보기
			//*******************************************
			if( confirm("정말 수정하시겠습니까?")==false ) { return; }

			//*******************************************
			// WAS 로 "/boardUpProc.do" URL 주소로 접속하고
			// 수정 실행 결과 정보가 담긴 [JSON 객체]을 받고 
			// 이 [JSON 객체] 저장된 데이터 따라 실행구문을 달리 실행하기
			//*******************************************
			ajax(
					//-------------------------------
					// WAS 로 접속할 주소 설정
					//-------------------------------
					"/boardUpProc.do"
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
					// JSON 안에 수정 실행 결과 정보 담겨 있다.
					//-------------------------------
					, function( responseJson ){
						//---------------------------------
						// WAS가 응답해준 JSON 에서 
							// 경고 문구 꺼내서 변수 errorMsg 에 저장하기
							// 수정된 행의 개수 꺼내서 변수 boardUpCnt 에 저장하기
						//---------------------------------
						var errorMsg   = responseJson["errorMsg"];
						var boardUpCnt = responseJson["boardUpCnt"];
						//---------------------------------
						// 경고 문구가 저장된 errorMsg 가 비어 있지 않으면
						// 경고 문구를 보이고 함수 중단하기
						//---------------------------------
						if( errorMsg!="" ){
							alert(errorMsg); return;
						}

						//---------------------------------
						// 수정된 행의 개수가 1 이면 
						//---------------------------------
						if( boardUpCnt==1 ){
							alert("수정이 성공했습니다.");
							//---------------
							// name=boardListForm 을 가진 form 태그에 있는 
							// action 속성값에 있는 URL 주소로 WAS에 접속하기
							// 이때 접속 방식은 form 태그에 있는 method 의 속성값을 따른다.
							// 즉 게시물 목록보기 화면으로 이동하기
							//---------------
							document.boardListForm.submit();
						}
						//---------------------------------
						// 수정된 행의 개수가 0 이면 (즉 수정할 게시물이 삭제 된 상황이면)
						//---------------------------------
						else if( boardUpCnt==0 ){
							alert("삭제된 게시물입니다.");
						}
						//---------------------------------
						// 수정된 행의 개수가 -1 이면 (즉 암호가 틀린 상황이면)
						//---------------------------------
						else if( boardUpCnt==-1 ){
							alert("암호가 틀립니다.재 입력 바랍니다.");
						}
						//---------------------------------
						// 수정된 행의 개수가 -11 이면 (즉 업로드된 파일의 크기가 너무 큰거면)
						//---------------------------------
						else if( boardUpCnt==-11 ){
							alert("업로드된 파일의 크기는 1000kb 이하이어야 합니다.");
						}
						//---------------------------------
						// 수정된 행의 개수가 -12 이면 (즉 업로드된 파일의 확장가자 틀리며)
						//---------------------------------
						else if( boardUpCnt==-12 ){
							alert("업로드된 파일의 확장자는 jpg, png, gif 이어야 합니다.");
						}
						else{
							alert("수정 실패! 관리자에게 문의 바랍니다.");
						}
					}
			);
	}

	//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	// 삭제 버튼 누르면 호출되는 함수 선언
	//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	function checkBoardDelForm(){
		//alert("이번주로 3일 논다...끼끼끼..........")
		//*******************************************
		// name='boardUpDelForm' 가진 form 태그를 관리하는
		// JQuery 객체 생성해서 변수 formObj 에 저장하기 
		//*******************************************
		var formObj = $("[name='boardUpDelForm']")
		//*******************************************
		// [암호]가 비었으면 경고하고 함수 중단하기
		//*******************************************
		if( !checkVal(
				formObj.find("[name='pwd']")
				,"암호 입력 바랍니다."
				,/[^ ]+/
			) 
		){return;}
		//*******************************************
		// [삭제 여부]를 물어보기
		//*******************************************
		if( confirm("정말 삭제하시겠습니까?")==false ) { return; }
		//*******************************************
		// WAS 로 "/boardDelProc.do" URL 주소로 접속하고
		// 삭제 실행 행의 개수 받고 
		// 삭제 실행 행의 개수 따라 실행구문을 달리 실행하기
		//*******************************************
		ajax(
				//-------------------------------
				// WAS 로 접속할 주소 설정
				//-------------------------------
				"/boardDelProc.do"
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
				// 현재 익명함수의 매개 변수로 삭제 실행 행의 개수가 들어온다.
				//-------------------------------
				,function( boardDelCnt ){
					//---------------------------------
					// 매개변수 boardDelCnt 에 1 이 저장되어 있으면
					// 즉 삭제가 성공 했으면 
					//---------------------------------
					if( boardDelCnt==1 ){
						alert("삭제가 성공했습니다.");
						document.boardListForm.submit();
					}
					//---------------------------------
					// 매개변수 boardDelCnt 에 2가  저장되어 있으면
					// 즉 자식글이 있어 제목,컨텐츠만 비우기가 성공 했으면 
					//---------------------------------
					else if( boardDelCnt==2 ){
						alert("자식글이 있어 삭제가 안되고 제목,컨텐츠만 비웁니다.");
						document.boardListForm.submit();
					}
					//---------------------------------
					// 매개변수 boardDelCnt 에 0이  저장되어 있으면
					// 즉 삭제된 게시물이면
					//---------------------------------
					else if( boardDelCnt==0 ){
						alert("삭제된 게시물입니다.");
						document.boardListForm.submit();
					}
					//---------------------------------
					// 매개변수 boardDelCnt 에 -1이  저장되어 있으면
					// 즉 암호가 틀리면
					//---------------------------------
					else if( boardDelCnt==-1 ){
						alert("암호가 틀립니다.재 입력 바람니다.");
						formObj.find("[name=pwd]").val("");
						formObj.find("[name=pwd]").focus();
					}
					else{
						alert("WAS 접속 실패입니다. 관리자에게 문의 바랍니다.");
					}
				}
		);
	}
</script>

</head>
<body>
<center>
		<form name="boardUpDelForm">
			<table class="tableB" > 
					<caption> [수정/삭제]</caption>
					<tr>
						<th>이 름</th>
						<td  width="300px">
						<!-------------------------------------------------------->
						<input type="text" name="writer" class="writer" size="10" maxlength="15" 
										value="${requestScope.boardDTO.writer}">
						<!-------------------------------------------------------->
						</td>
					</tr>
					<tr>
						<th>제 목</th>
						<td>
						<!--------------------------------------------------------> 
						<input type="text" name="subject" class="subject" size="40" maxlength="30" 
								value="${requestScope.boardDTO.subject}">
						<!-------------------------------------------------------->
						</td>
					</tr>
					<tr>
						<th>이메일</th>
						<td>
						<!-------------------------------------------------------->
						<input type="text" name="email" class="email" size="40" maxlength="50" 
								value="${requestScope.boardDTO.email}">
						<!-------------------------------------------------------->
						</td>
					</tr>
					<tr>
						<th>내 용</th>
						<td>
						<!-------------------------------------------------------->
						<textarea name="content"  class="content" rows="13" cols="40"  
							maxlength="500">${requestScope.boardDTO.content}</textarea>
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
						
							<c:if test="${!empty requestScope.boardDTO.img_name}">
								<img src="/img/${requestScope.boardDTO.img_name}"  height="200px"> 
								<input type="checkbox" name="isdel" value="del">기존파일삭제<br>
								<input type="hidden" name="img_name" value="${requestScope.boardDTO.img_name}">
							</c:if>
							
							<input type="file" name=img>  
						</td>
					</tr>
			</table>
				<!-------------------------------------------------------->	
				<input type="hidden" name="b_no" value="${requestScope.boardDTO.b_no}">
				<!-------------------------------------------------------->	
				<div style="height:5px;"></div>
				<!-------------------------------------------------------->	
				<input type="button" value="수정" onClick="checkBoardUpForm();">    
				<input type="button" value="삭제" onClick="checkBoardDelForm();">  
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



































