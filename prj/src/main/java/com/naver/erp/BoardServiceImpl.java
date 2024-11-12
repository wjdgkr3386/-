package com.naver.erp;

import java.io.File;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;


//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
//[BoardService 인터페이스] 선언.
//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
@Service
@Transactional
public class BoardServiceImpl implements BoardService{

	@Autowired
	private BoardDAO  boardDAO;

	//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	//  [1개 게시판 글] 검색 해 리턴하는 메소드 선언
	//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	@Override
	public BoardDTO getBoard(int b_no , boolean isBoardDetailForm ) {
		if( isBoardDetailForm ) {
			//------------------------------------------
			// [BoardDAO 인터페이스를 구현한 객체]의 updateReadcount 메소드를 호출하여
			// [조회수 증가]하고 수정한 행의 개수를 얻는다
			//------------------------------------------
			int updateCount = this.boardDAO.updateReadcount(b_no);
		}
		//------------------------------------------
		// [BoardDAO 인터페이스를 구현한 객체]의  getBoard 메소드를 호출하여
		// [1개 게시판 글]을 얻는다
		//------------------------------------------
		BoardDTO board = this.boardDAO.getBoard(b_no);
		//------------------------------------------
		// [1개 게시판 글]이 저장된 BoardDTO 객체 리턴하기
		//------------------------------------------
		return board;
	}
	
	//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	// [1개 게시판] 수정 실행하고 수정 적용행의 개수를 리턴하는 메소드 선언
	//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	@Override
	public int updateBoard(BoardDTO boardDTO)   throws Exception {

		//******************************************************
		// 게시판 수정 행의 개수 저장 변수 boardUpCnt 선언.
		// BoardDTO 객체에 저장된 MultipartFile 객체를 꺼내서 변수 img 에 저장하기
		// MultipartFile 객체가 업로드된 파일을 관리하고 있다면  
			// 변수 isFile 에 true 저장하고 아니면 false 저장하기
		// 업로드된 파일에 부여할 새 이름을 구해서 변수 newFileName 에 저장하기
		//******************************************************
		int boardUpCnt  = 0;
		MultipartFile multi =  boardDTO.getImg();
		boolean isFile      =  multi!=null && multi.isEmpty()==false;
		String newFileName  =  Util.getNewFileName(multi);
		
		String isdel  =  boardDTO.getIsdel();
		String old_img_name  =  boardDTO.getImg_name();
		
		//*********************************************
		// 업로드 파일의 크기와 확장자 검사하기
		// Util 클래스의 checkUploadFileForBoard 메소드를 호출하여
		// 리턴되는 데이터가 -11 이면 크기가 너무 큰 것이고
		//                   -12 이면 확장자가 틀린것이다.
		//*********************************************
		int checkUploadfile = Util.checkUploadFileForBoard( multi );
		if( checkUploadfile<0 ) {
			return checkUploadfile;
		}
		
		//*********************************************
		// 수정할 게시판의 존재 개수 얻기
		// 만약 수정할 게시판의 개수가 0개면(=이미 삭제되었으면) 0리턴하기
		//*********************************************
		int boardCnt = this.boardDAO.getBoardCnt( boardDTO.getB_no() );
		if( boardCnt==0 ) { return 0; }
		//*********************************************
		// 암호의 존재 개수 얻기
		// 만약 암호의 존재 개수가 0개면(=암호가 틀렸으면) -1리턴하기
		//*********************************************
		int boardPwdCnt = this.boardDAO.getBoardPwdCnt( boardDTO );
		if( boardPwdCnt==0 ) { return -1; }

		//******************************************************
		// 업로드된 파일이 있다면
		//******************************************************
		if( isFile ) {
			//******************************************************
			//  BoardDTO 객체 안의 멤버변수 img_name 에 새로은 파일명을 저장하기
			//******************************************************
			boardDTO.setImg_name(newFileName);
		}
		//******************************************************
		// 업로드된 파일이 없다면, 즉 새로운 파일을 선택 안했으면
		//******************************************************
		else {
			//***********************
			// 변수 isdel 이 null 이 아니라면, 즉 파일 삭제 의도가 있다면
			//***********************
			if( isdel!=null ) {
				// BoardDTO 객체의 멤버변수 img_name 에 null 저장하기
				boardDTO.setImg_name(null);
			}
		}
		//*********************************************
		// 수정 실행하고 수정 적용행의 개수 얻기
		//*********************************************
		boardUpCnt = this.boardDAO.updateBoard( boardDTO );
		//******************************************************
		// 업로드된 파일이 있다면
		//******************************************************
		if( isFile ) {
			//---------------------------------------------------
			// 새파일을 만들고 이 파일을 관리하는 
			// File 객체 생성하고 이 객체의 메위주를 변수 file 에 저장하기
			//---------------------------------------------------
			File file = new File(  Util.uploadDirForBoard()  + newFileName );
			//---------------------------------------------------
			// MultipartFile 객체의 transferTo 메소드를 호출하여
			// MultipartFile 객체가 관리하는 업로드 파일을 위에서 만든 새 파일에 덮어쓰기     
			//---------------------------------------------------
			multi.transferTo(file);
		}
		//******************************************************
		// 만약에 변수 old_img_name 에 문자 있으면
		// 즉 수정전에 기존에 파일이 있었다면
		//******************************************************
		if(  old_img_name!=null && old_img_name.length()>0 ) {
			//------------------------
			// 변수 isdel 에 문자가 있거나 또는 변수 isFile 이 true면
			// 즉 삭제 체크박스를 선택했거나 새로운 업로드 파일이 있다면
			//------------------------
			if(  isdel!=null && isdel.length()>0 || isFile ) {
				//------------------------
				// 변수 old_img_name 에 저장된 이미지 이름에 해당하는 파일 삭제하기
				//------------------------
				Util.delBoardImg(old_img_name);
			}
		}
		//******************************************************
		// 변수 boardUpCnt 안의 데이터 리턴하기ㄴ
		//******************************************************
		return boardUpCnt;
		
		
		/*
		//*********************************************
		// 수정할 게시판의 존재 개수 얻기
		// 만약 수정할 게시판의 개수가 0개면(=이미 삭제되었으면) 0리턴하기
		//*********************************************
		int boardCnt = this.boardDAO.getBoardCnt( boardDTO.getB_no() );
		if( boardCnt==0 ) { return 0; }
		
		//*********************************************
		// 암호의 존재 개수 얻기
		// 만약 암호의 존재 개수가 0개면(=암호가 틀렸으면) -1리턴하기
		//*********************************************
		int boardPwdCnt = this.boardDAO.getBoardPwdCnt( boardDTO );
		if( boardPwdCnt==0 ) { return -1; }
		
		//*********************************************
		// 수정 실행하고 수정 적용행의 개수 얻기
		//*********************************************
		int updateBoardCnt = this.boardDAO.updateBoard( boardDTO );
		
		//*********************************************
		// 수정 실행하고 수정 적용행의 개수 리턴하기
		//*********************************************
		return updateBoardCnt;
		*/
	}

	//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	// [1개 게시판] 삭제 후 삭제 적용행의 개수를 리턴하는 메소드 선언
	//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	@Override
	public int deleteBoard(BoardDTO boardDTO) {
		//*********************************************
		// BoardDTO 객체에서 멤버변수 img_name 안의 데이터 꺼내서 변수 img_name 에 저장하기
		//*********************************************
		String img_name = boardDTO.getImg_name();
		//*********************************************
		// 삭제 적용행의 개수를 저장할 변수 deleteBoardCnt 선언하기 
		//*********************************************
		int deleteBoardCnt = 0;
		//*********************************************
		// 삭제 예정인 게시판의 존재 개수 얻어서 변수 boardCnt 에 저장하기.
		// 만약 삭제할 게시판의 개수가 0개면(=이미 삭제되었으면) 0리턴하기
		//*********************************************
		int boardCnt = this.boardDAO.getBoardCnt( boardDTO.getB_no() );
		if( boardCnt==0 ) {
			return 0;
		}
		//*********************************************
		// 암호의 존재 개수 얻기
		// 만약 암호의 존재 개수가 0개면(=암호가 틀렸으면) -1리턴하기
		//*********************************************
		int boardPwdCnt = this.boardDAO.getBoardPwdCnt( boardDTO );
		if( boardPwdCnt==0 ) {
			return -1;
		}
		//*********************************************
		// 삭제 예정인 게시판의 자식글의 존재 개수 얻어서 변수 boardChildrenCnt 에 저장하기.
		// 만약 자식글의 존재 개수가 1개 이상이면(=자식글이 있으면)
		//*********************************************
		int boardChildrenCnt = this.boardDAO.getBoardChildrenCnt(boardDTO);
		if( boardChildrenCnt>0 ) {
			// 삭제 예정인 게시판글의 제목,내용을 비우기
			deleteBoardCnt = this.boardDAO.updateBoardEmpty( boardDTO );
			//*********************************************
			// 변수 img_name 에 저장된 이미지 이름에 해당하는 파일 삭제하기
			//*********************************************
			Util.delBoardImg(img_name);
			// 2 리턴하기.
			return 2;
		}
		//*********************************************
		// 게시판 글을 삭제하고 삭제 행의 개수를 변수 deleteBoardCnt 에 저장하기
		// 즉 삭제되지도 않았고, 암호도 맞고, 자식글도 없으니 삭제한다
		//*********************************************
		deleteBoardCnt = this.boardDAO.deleteBoard( boardDTO );
		//*********************************************
		// 변수 img_name 에 저장된 이미지 이름에 해당하는 파일 삭제하기
		//*********************************************
		Util.delBoardImg(img_name);
		//*********************************************
		// 변수 deleteBoardCnt 안의 데이터를 리턴하긴
		//*********************************************
		return deleteBoardCnt;
	}

	

	//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	// [1개 게시판 글 입력 후 입력 적용 행의 개수] 리턴하는 메소드 선언
	//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	@Override
	public int insertBoard( BoardDTO boardDTO )  throws Exception {
		//******************************************************
		// 게시판 입력 행의 개수 저장 변수 boardRegCnt 선언.
		// 출력순서 번호 1 증가 적용 행 개수 저장 변수 선언.
		// BoardDTO 객체에 저장된 MultipartFile 객체를 꺼내서 변수 img 에 저장하기
		// MultipartFile 객체가 업로드된 파일을 관리하고 있다면  
			// 변수 isFile 에 true 저장하고 아니면 false 저장하기
		// 업로드된 파일의 새 이름을 구해서 변수 newFileName 에 저장하기
		//******************************************************
		int boardRegCnt  = 0;
		int upPrintNoCnt = 0;
		
		MultipartFile multi   =  boardDTO.getImg();
		boolean isFile      =  multi!=null && multi.isEmpty()==false;
		String newFileName  =  Util.getNewFileName(multi);
		
		//*********************************************
		// 업로드 파일의 크기와 확장자 검사하기
		// Util 클래스의 checkUploadFileForBoard 메소드를 호출하여
		// 리턴되는 데이터가 -11 이면 크기가 너무 큰 것이고
		//                   -12 이면 확장자가 틀린것이다.
		//*********************************************
		int checkUploadfile = Util.checkUploadFileForBoard( multi );
		if( checkUploadfile<0 ) {
			return checkUploadfile;
		}

		
		//******************************************************
		//  만약 BoardDTO 객체 안의 엄마글의 글 번호가 있으면 댓글쓰기 이므로
		//  엄마 글 이후의 게시판 글에 대해 출력순서번호를 1 증가 시키기.
		//******************************************************
		if( boardDTO.getMom_b_no()>0 ){
			upPrintNoCnt = this.boardDAO.upPrintNo(boardDTO);
		}
		
		//******************************************************
		//  BoardDTO 객체 안의 멤버변수 img_name 에 새로은 파일명을 저장하기
		//******************************************************
		boardDTO.setImg_name(newFileName);
		
		//******************************************************
		// BoardDAO 인터페이스를 구현한 객체의  
			// insertBoard 메소드 호출하여 
			// 게시판 글 입력 후 입력 적용 행의 개수 얻기
		//******************************************************
		boardRegCnt = this.boardDAO.insertBoard(boardDTO);
		

		//******************************************************
		// 업로드 파일을 WAS 내부에 저장하기
		//******************************************************
		
		// 만약에 BoardDTO 객체의 멤버변수 img 가 null 이 아니면
		// 즉 파일업로드가 되었다면
		if( isFile ) {
			//---------------------------------------------------
			// 새파일을 만들고 이 파일을 관리하는 
			// File 객체 생성하고 이 객체의 메위주를 변수 file 에 저장하기
			//---------------------------------------------------
			File file = new File(  Util.uploadDirForBoard()  + newFileName );

			//---------------------------------------------------
			// MultipartFile 객체의 transferTo 메소드를 호출하여
			// MultipartFile 객체가 관리하는 업로드 파일을 위에서 만든 새 파일에 덮어쓰기     String xxx = "사\"오\"정";
			//---------------------------------------------------
			multi.transferTo(file);
		}
		
		
		//******************************************************
		// 1개 게시판 글 입력 적용 행의 개수 리턴하기
		//******************************************************
		return boardRegCnt;
	}

	
}






















