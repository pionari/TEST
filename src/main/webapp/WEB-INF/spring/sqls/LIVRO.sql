-- 멤버 테이블

DROP SEQUENCE MEMBER_NO_SEQ;
CREATE SEQUENCE MEMBER_NO_SEQ
INCREMENT BY 1 --증감숫자가 양수면 증가 음수면 감소 디폴트는 1
START WITH 1 -- 시작숫자의 디폴트값은 증가일때 MINVALUE 감소일때 MAXVALUE
NOCACHE;

DROP TABLE MEMBER;
CREATE TABLE MEMBER(
	--아이디
	MEMBER_ID VARCHAR2(20) NOT NULL,
	--비밀번호
	MEMBER_PW VARCHAR2(500) NOT NULL,
	--비밀번호 체크
	MEMBER_PWCHK VARCHAR2(500) NOT NULL,
	--회원 정렬 번호
	MEMBER_NO NUMBER NOT NULL,
	--이름
	MEMBER_NAME VARCHAR2(20) NOT NULL,
	--닉네임
	MEMBER_NICKNAME VARCHAR2(20) NOT NULL,
	--주소
	MEMBER_ADDR VARCHAR2(100) NOT NULL,
	--이메일
	MEMBER_EMAIL VARCHAR2(100) NOT NULL,
	--전화번호
	MEMBER_PHONE VARCHAR2(20) NOT NULL,
	--등급
	MEMBER_ROLE CHAR(1) NOT NULL,
	--가입여부
	MEMBER_ENABLED CHAR(1) NOT NULL,
	--가입날짜
	MEMBER_REGDATE DATE NOT NULL,
	--프로필 사진
	MEMBER_PROFILE VARCHAR2(1000), 

	CONSTRAINT MEMBER_PK PRIMARY KEY(MEMBER_ID),
	CONSTRAINT NICKNAME_MEMBER_UNQ UNIQUE(MEMBER_NICKNAME),
	CONSTRAINT PHONE_MEMBER_UNQ UNIQUE(MEMBER_PHONE),
	CONSTRAINT EMAIL_MEMBER_UNQ UNIQUE(MEMBER_EMAIL),
	--M : 관리자 A : 아티스트 U : 일반
	CONSTRAINT MEMBER_ROLE_MEMBER_CHK CHECK(MEMBER_ROLE IN('M', 'A', 'U')),
	--Y - 일반회원, N - 탈퇴한 회원, A - 신고된 회원
	CONSTRAINT ENABLED_MEMBER_CHK CHECK(MEMBER_ENABLED IN('Y','N','A'))
);

ALTER TABLE MEMBER MODIFY MEMBER_ENABLED DEFAULT 'Y' ;


INSERT INTO MEMBER
VALUES( 'admin', 'admin1234', 'admin1234', MEMBER_NO_SEQ.NEXTVAL , '관리자', '관리자1', '서울시 강남구', 'admin1@email.com', '010-1234-1234', 'M', 'Y', SYSDATE, null);

INSERT INTO MEMBER
VALUES( 'admin2', 'admin1234', 'admin1234', MEMBER_NO_SEQ.NEXTVAL , '관리자', '관리자2', '서울시 강남구', 'admin2@email.com', '010-1234-1111', 'M', 'Y', SYSDATE, null);

INSERT INTO MEMBER
VALUES( 'artist', 'artist1234', 'artist1234', MEMBER_NO_SEQ.NEXTVAL , '아티스트', '아티스트1', '서울시 강남구', 'artist1@email.com', '010-2222-2222', 'A', 'Y', SYSDATE, null);

INSERT INTO MEMBER
VALUES( 'artist3', 'artist1234', 'artist1234', MEMBER_NO_SEQ.NEXTVAL , '아티스트', '방송', '서울시 강남구', 'artist3@email.com', '010-2222-1122', 'A', 'Y', SYSDATE, 'testimage');


INSERT INTO MEMBER
VALUES( 'admin2', 'admin1234', 'admin1234', MEMBER_NO_SEQ.NEXTVAL , '관리자', '관리자2', '서울시 강남구', 'admin2@email.com', '010-1234-1111', 'M', 'Y', SYSDATE, null);

SELECT *
FROM MEMBER;

CREATE TRIGGER MEM_NICKNAME_BROAD_UPDATE
AFTER UPDATE ON MEMBER
FOR EACH ROW
BEGIN
	UPDATE BROADCAST 
	SET MEMBER_NICKNAME = :NEW.MEMBER_NICKNAME
	WHERE MEMBER_NICKNAME = :OLD.MEMBER_NICKNAME;
END;

DROP TRIGGER MEM_NICKNAME_BROAD_UPDATE;



--프로필 테이블

DROP TABLE PROFILE;
CREATE TABLE PROFILE(
	MEMBER_ID VARCHAR2(20) PRIMARY KEY,
	PROFILE_SAVEDNAME VARCHAR2(4000),
	PROFILE_REALNAME VARCHAR2(4000),
	PROFILE_PATH VARCHAR2(4000),
	PROFILE_REGDATE DATE DEFAULT SYSDATE,
	
	CONSTRAINT PROFILE_MEMBER_ID_FK FOREIGN KEY(MEMBER_ID) REFERENCES MEMBER(MEMBER_ID)
);

SELECT *
FROM PROFILE;

DROP SEQUENCE MUSIC_NO_SEQ;
CREATE SEQUENCE MUSIC_NO_SEQ
INCREMENT BY 1 --증감숫자가 양수면 증가 음수면 감소 디폴트는 1
START WITH 1 -- 시작숫자의 디폴트값은 증가일때 MINVALUE 감소일때 MAXVALUE
NOCACHE;

-- 음원 업로드
DROP TABLE MUSIC;
CREATE TABLE MUSIC(	
	--음원 번호
	MUSIC_NO NUMBER PRIMARY KEY,
	--아티스트아이디
	MEMBER_ID VARCHAR2(20) NOT NULL,
	--제목
	MUSIC_TITLE VARCHAR2(300) NOT NULL,
	--내용
	MUSIC_CONTENT VARCHAR2(1000) NOT NULL,
	--음원저장이름
	MUSIC_SAVENAME VARCHAR2(1000) NOT NULL,
	--음원기존이름
	MUSIC_REALNAME VARCHAR2(1000) NOT NULL,
	--날짜
	MUSIC_DATE DATE NOT NULL,
	
	CONSTRAINT MUSIC_MEMBER_ID_FK FOREIGN KEY(MEMBER_ID) REFERENCES MEMBER(MEMBER_ID)
);

ALTER TABLE MUSIC
RENAME COLUMN MUSIC_FILE TO MUSIC_SAVENAME


SELECT * FROM MUSIC;
DELETE FROM MUSIC;

JOIN MUSIC MU
ON = ME.MEMBER_ID = MU.MEMBER_ID

-- 아티스트별 채널 - 공연일정
DROP SEQUENCE CAL_NO_SEQ;
CREATE SEQUENCE CAL_NO_SEQ
INCREMENT BY 1 
START WITH 1
NOCACHE; 

DROP TABLE CALENDAR;
CREATE TABLE CALENDAR(
	--공연번호
	CAL_NO NUMBER PRIMARY KEY, 
	--아티스트아이디
	MEMBER_ID VARCHAR2(20) NOT NULL,
	--공연이름
	CAL_TITLE VARCHAR2(50) NOT NULL,
	--공연날짜
	CAL_DATE DATE NOT NULL,
	--공연시작시간
	CAL_START DATE NOT NULL,
	--공연끝나는시간
	CAL_END DATE NOT NULL,
	--카테고리
	CAL_CATEGORY VARCHAR2(10) DEFAULT 'time',
	
	CONSTRAINT CALENDAR_MEMBER_ID_FK FOREIGN KEY(MEMBER_ID) REFERENCES MEMBER(MEMBER_ID)
);


-- 팔로잉
DROP SEQUENCE FOLLOW_NO_SEQ;
CREATE SEQUENCE FOLLOW_NO_SEQ
INCREMENT BY 1 --증감숫자가 양수면 증가 음수면 감소 디폴트는 1
START WITH 1
NOCACHE; -- 시작숫자의 디폴트값은 증가일때 MINVALUE 감소일때 MAXVALUE

DROP TABLE FOLLOW;
CREATE TABLE FOLLOW(
	--번호
	FOLLOWING_NO NUMBER PRIMARY KEY,
	--아이디
	MEMBER_ID VARCHAR2(20) NOT NULL,
	--닉네임
	MEMBER_NICKNAME VARCHAR2(40) NOT NULL,
	--아티스트아이디
	ARTIST_ID VARCHAR2(20) NOT NULL,
	--아티스트닉네임
	ARTIST_NICKNAME VARCHAR2(40) NOT NULL,
	--팔로잉날짜
	FOLLOWING_DATE DATE NOT NULL,

	CONSTRAINT FOLLOW_FK FOREIGN KEY(MEMBER_ID) REFERENCES MEMBER(MEMBER_ID)
);


-- 팔로워 목록
DROP SEQUENCE FOLLOWER_NO_SEQ;
CREATE SEQUENCE FOLLOWER_NO_SEQ
INCREMENT BY 1 
START WITH 1
NOCACHE;

DROP TABLE FOLLOWER;
CREATE TABLE FOLLOWER(
	--번호
	FOLLOWER_NO NUMBER PRIMARY KEY,
	--아티스트 ID
	MEMBER_ID VARCHAR2(20) NOT NULL,
	--아티스트 닉네임
	MEMBER_NICKNAME VARCHAR2(40) NOT NULL,
	--팔로워 ID
	FOLLOWER_ID VARCHAR2(20) NOT NULL,
	--팔로워 닉네임
	FOLLOWER_NICKNAME VARCHAR2(40) NOT NULL,
	--팔로우한 날짜
	FOLLOWER_DATE DATE NOT NULL,

	CONSTRAINT FOLLOWER_ID_FK FOREIGN KEY(FOLLOWER_ID) REFERENCES MEMBER(MEMBER_ID),
	CONSTRAINT FOLLOWER_NICK_FK FOREIGN KEY(FOLLOWER_NICKNAME) REFERENCES MEMBER(MEMBER_NICKNAME)
);


-- 공지사항 
DROP SEQUENCE NOTICE_NO_SEQ;
CREATE SEQUENCE NOTICE_NO_SEQ
INCREMENT BY 1 
START WITH 1
NOCACHE;

DROP TABLE NOTICE_BOARD;
CREATE TABLE NOTICE_BOARD(
	--공지사항 NO
	NOTICE_NO NUMBER PRIMARY KEY,
	--작성자 ID
	MEMBER_ID VARCHAR2(20) NOT NULL,
	--공지사항 제목
	NOTICE_TITLE VARCHAR2(50) NOT NULL,	
	--공지사항 내용
	NOTICE_CONTENT VARCHAR2(3000) NOT NULL,
	--공지사항 작성시간
	NOTICE_REGDATE DATE NOT NULL,

	CONSTRAINT NOTICE_BOARD_FK FOREIGN KEY(MEMBER_ID) REFERENCES MEMBER(MEMBER_ID)
	
);

INSERT INTO NOTICE_BOARD
VALUES(NOTICE_NO_SEQ.NEXTVAL,'admin','NOTICETESTTITLE','NOTICETESTCONTEST',SYSDATE)

SELECT * FROM NOTICE_BOARD ORDER BY NOTICE_NO DESC
SELECT COUNT(*) AS LISTCNT
FROM NOTICE_BOARD

SELECT COUNT(*) AS LISTCNT
		FROM NOTICE_BOARD

SELECT COUNT(*) AS SEARCHLISTCNT
FROM ( SELECT *
	FROM NOTICE_BOARD
	WHERE NOTICE_TITLE LIKE 'dummy'
	OR NOTICE_CONTENT LIKE 'dummy' )
	
-- QnA 
DROP SEQUENCE QNA_NO_SEQ;
CREATE SEQUENCE QNA_NO_SEQ
INCREMENT BY 1 
START WITH 1
NOCACHE;

DROP TABLE QNA_BOARD;
CREATE TABLE QNA_BOARD(
	--글번호
	QNA_NO NUMBER PRIMARY KEY,
	--아이디
	MEMBER_ID VARCHAR2(20) NOT NULL,
	--글제목
	QNA_TITLE VARCHAR2(50) NOT NULL,
	--글내용
	QNA_CONTENT VARCHAR2(3000) NOT NULL,
	--작성날짜
	QNA_REGDATE DATE NOT NULL,
	--답변여부
	QNA_FLAG CHAR(1) NOT NULL,
	--답글그룹번호
	QNA_GROUPNO NUMBER NOT NULL,
	--답글번호
	QNA_GROUPSEQ NUMBER NOT NULL,
	--비밀글여부
	QNA_SECRET CHAR(1) NOT NULL,

	CONSTRAINT QNA_BOARD_FK FOREIGN KEY(MEMBER_ID) REFERENCES MEMBER(MEMBER_ID)

);

DELETE 
FROM QNA_BOARD;
SELECT * FROM QNA_BOARD;
ALTER TABLE QNA_BOARD ADD MEMBER_NICKNAME VARCHAR2(30) NOT NULL;
ALTER TABLE QNA_BOARD ADD CONSTRAINT QNA_FK_MEMBER_NIC FOREIGN KEY(MEMBER_NICKNAME) REFERENCES MEMBER(MEMBER_NICKNAME);
ALTER TABLE QNA_BOARD MODIFY MEMBER_NICKNAME CONSTRAINT QNA_NN_MEMBER_NIC NOT NULL;
ALTER TABLE QNA_BOARD DROP COLUMN MEMBER_NICKNAME;


--응원게시판
DROP SEQUENCE SUPPORT_NOSEQ;
CREATE SEQUENCE SUPPORT_NO_SEQ
INCREMENT BY 1 
START WITH 1
NOCACHE;

DROP TABLE SUPPORT_BOARD;
CREATE TABLE SUPPORT_BOARD(
	--번호
	SUPPORT_NO NUMBER PRIMARY KEY,
	--ID
	MEMBER_ID VARCHAR2(20) NOT NULL,
	--제목
	SUPPORT_TITLE VARCHAR2(50) NOT NULL,
	--내용
	SUPPORT_CONTENT VARCHAR2(3000) NOT NULL,
	--업로드 날짜
	SUPPORT_REGDATE DATE NOT NULL,
	
	CONSTRAINT MEMBER_ID FOREIGN KEY(MEMBER_ID) REFERENCES MEMBER(MEMBER_ID)

);


-- 응원댓글
DROP SEQUENCE COMM_NO_SEQ;
CREATE SEQUENCE COMM_NO_SEQ
INCREMENT BY 1 
START WITH 1
NOCACHE;

DROP TABLE SUPPORT_COMM;
CREATE TABLE SUPPORT_COMM(
	--응원댓글
	COMM_NO NUMBER PRIMARY KEY,
	--응원게시판글번호
	SUPPORT_NO NUMBER NOT NULL,
	--작성자ID
	MEMBER_ID VARCHAR2(20) NOT NULL,
	--작성자닉네임
	MEMBER_NICKNAME VARCHAR2(40) NOT NULL,
	--댓글내용
	COMM_CONTENT VARCHAR2(3000) NOT NULL,
	--댓글 작성시간
	COMM_REGDATE DATE NOT NULL,
	
	CONSTRAINT SUPPORT_COMM_NO_FK FOREIGN KEY(SUPPORT_NO) REFERENCES SUPPORT_BOARD(SUPPORT_NO),
	CONSTRAINT SUPPORT_COMM_ID_FK FOREIGN KEY(MEMBER_ID) REFERENCES MEMBER(MEMBER_ID),
	CONSTRAINT SUPPORT_COMM_NICKNAME_FK FOREIGN KEY(MEMBER_NICKNAME) REFERENCES MEMBER(MEMBER_NICKNAME)
);

--후원
DROP SEQUENCE DONA_NO_SEQ;
CREATE SEQUENCE DONA_NO_SEQ
INCREMENT BY 1 
START WITH 1
NOCACHE;

DROP TABLE DONATION
후원
CREATE TABLE DONATION (
	-- 번호
	DONA_NO NUMBER PRIMARY KEY,
	-- 아이디
	MEMBER_ VARCHAR2(20) NOT NULL,
	-- 금액
	DONA_PRICE VARCHAR2(20) NOT NULL,
	-- 결제날짜
	DONA_DATE DATE NOT NULL,
	-- 받은사람
	DONA_NICKNAME VARCHAR2(20) NOT NULL,
	
	CONSTRAINT DONATION_ID_FK FOREIGN KEY (MEMBER_ID) REFERENCES MEMBER(MEMBER_ID)
);
	ALTER TABLE DONATION DROP COLUMN DONA_ID;
    ALTER TABLE DONATION ADD DONA_NICKNAME VARCHAR2(20) NOT NULL;
 --DONA_ID -> DONA_NICKNAME으로 수정

-- 스트리밍
DROP SEQUENCE BROADCAST_NO_SEQ;
CREATE SEQUENCE BROADCAST_NO_SEQ
INCREMENT BY 1 
START WITH 1
NOCACHE;

DROP TABLE BROADCAST;
CREATE TABLE BROADCAST(
	--번호
	BROADCAST_NO NUMBER PRIMARY KEY,
	--아이디
	MEMBER_ID VARCHAR2(20) NOT NULL,
	--방송제목
	BROADCAST_TITLE VARCHAR2(300) NOT NULL,
	--방송내용
	BROADCAST_CONTENT VARCHAR2(3000) NOT NULL,
	--방송날짜
	BROADCAST_REGDATE DATE NOT NULL,
	--방송카테고리
	BROADCAST_CATEGORY VARCHAR2(20) NOT NULL,
	--썸네일
	MEMBER_PROFILE VARCHAR2(1000),

	CONSTRAINT BROADCAST_MEMBER_ID_FK FOREIGN KEY(MEMBER_ID) REFERENCES MEMBER(MEMBER_ID)	
);
--방송여부 추가함
ALTER TABLE BROADCAST ADD BROADCAST_FLAG CHAR(1) CHECK(BROADCAST_FLAG IN('Y','N'));
--NICKNAME 컬럼 다시 추가		테이블 생성부분에는 따로 추가안함 알아보기 쉽게 !!! 
ALTER TABLE BROADCAST ADD MEMBER_NICKNAME VARCHAR2(20) NOT NULL;
ALTER TABLE BROADCAST ADD CONSTRAINT BROADCAST_MEMBER_NICKNAME_FK FOREIGN KEY(MEMBER_NICKNAME) REFERENCES MEMBER(MEMBER_NICKNAME);
 
INSERT INTO BROADCAST
VALUES(BROADCAST_NO_SEQ.NEXTVAL, 'artist', 'artist1', '방송테스트1', '방송테스트 설명입니다', SYSDATE, '카테고리', 'testimage');

SELECT * 
FROM BROADCAST
ORDER BY BROADCAST_NO;

--신고
DROP SEQUENCE REPORT_NO_SEQ;
CREATE SEQUENCE REPORT_NO_SEQ
INCREMENT BY 1 
START WITH 1
NOCACHE;

--2020/11/01 드랍하고 다시 살림 -박진우-
DROP TABLE REPORT;
CREATE TABLE REPORT(
	--신고번호
	REPORT_NO NUMBER PRIMARY KEY,
	--신고자아이디
	SEND_ID VARCHAR2(20) NOT NULL,
	--아이디
	SEND_NICKNAME VARCHAR2(20) NOT NULL,
	--신고받은ID
	RECEIVE_ID VARCHAR2(20) NOT NULL,
	--신고받은닉네임
	RECEIVE_NICKNAME VARCHAR2(20) NOT NULL,
	--신고제목
	REPORT_TITLE VARCHAR2(50) NOT NULL,
	--신고내용
	REPORT_CONTENT VARCHAR2(3000) NOT NULL,
	--신고날짜 
	REPORT_REGDATE DATE NOT NULL,
	
	CONSTRAINT REPORT_SEND_ID_FK FOREIGN KEY(SEND_ID) REFERENCES MEMBER(MEMBER_ID),
	CONSTRAINT REPORT_SEND_NICKNAME_FK FOREIGN KEY(SEND_NICKNAME) REFERENCES MEMBER(MEMBER_NICKNAME),
	CONSTRAINT REPORT_RECEIVE_ID_FK FOREIGN KEY(RECEIVE_ID) REFERENCES MEMBER(MEMBER_ID),
	CONSTRAINT REPORT_RECEVE_NICKNAME_FK FOREIGN KEY(RECEIVE_NICKNAME) REFERENCES MEMBER(MEMBER_NICKNAME)
);



