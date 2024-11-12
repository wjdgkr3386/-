package com.naver.erp;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface BoardDAO {
	//--------------------------------------------
	// 게시판 총 개수 리턴하는 메소드 선언.
	//--------------------------------------------
	int  getBoardListCntAll(  );
	//--------------------------------------------
	// 게시판 검색 결과 개수 리턴하는 메소드 선언.
	//--------------------------------------------
	int  getBoardListCnt( BoardSearchDTO boardSearchDTO );
	//--------------------------------------------
	// 게시판 검색 결과(n행m열) 리턴하는 메소드 선언.
	//--------------------------------------------
	List<Map<String,String>> getBoardList( BoardSearchDTO boardSearchDTO );

	//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	// 조회수를 1 증가하고 적용된 행의 개수를 얻는 메소드 선언
	//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	int updateReadcount(int b_no);	

	//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	// [1개의 게시판 정보]를 리턴하는 메소드 선언
	//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	BoardDTO getBoard(int b_no);
	
	
	
	
	//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	// 게시판의 존재 개수를 리턴하는 메소드 선언
	//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	int getBoardCnt(int b_no);

	//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	// 수정/삭제할 게시판의 비밀번호 존재 개수를 리턴하는 메소드 선언
	//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	int getBoardPwdCnt( BoardDTO boardDTO);
	
	//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	// 게시판 수정 명령한 후 수정 적용행의 개수를 리턴하는 메소드 선언
	//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	int updateBoard(BoardDTO board);
	

	
	
	
	//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	// [후손 글의 개수] 리턴하는 메소드 선언
	//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	int getBoardChildrenCnt(BoardDTO boardDTO);

	//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	// 제목과 내용을 삭제하는 메소드 선언
		// 즉 자식 있는 글의 게시판글은 삭제하지 말고
		// 제목과 내용을 "삭제물입니다" 라고 수정한 후 수정 적용행의 개수를 얻는 메소드다
	//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	int updateBoardEmpty(BoardDTO board);

	//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	// [게시판 삭제 명령한 후 삭제 적용행의 개수]를 얻는 메소드 선언
	//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	int deleteBoard(BoardDTO board);
	

	
	
	
	//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm 
	// [게시판 글 출력번호 1 증가하고 수정 행의 개수] 리턴하는 메소드 선언
	//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	int upPrintNo(BoardDTO boardDTO);

	//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	// [게시판 글 입력 후 입력 적용 행의 개수] 리턴하는 메소드 선언
	//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	int insertBoard(BoardDTO boardDTO);
	
	
}












