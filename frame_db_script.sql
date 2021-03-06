CREATE TABLE "CMM_USER" 
   (	"USER_ID" VARCHAR2(35) NOT NULL ENABLE, 
	"USER_NM" VARCHAR2(60), 
	"USER_PW" VARCHAR2(100), 
	"AUTH_CD" VARCHAR2(20), 
	"TEL_NO" VARCHAR2(25), 
	"HP_NO" VARCHAR2(50), 
	"EMAIL" VARCHAR2(100), 
	"LOGIN_START" DATE, 
	"LOGIN_LAST" DATE, 
	"LOGIN_ERROR" NUMBER(18,0), 
	"PW_PRIOR" VARCHAR2(100), 
	"PW_CHANGE" DATE, 
	"PW_UPDATE" NUMBER(18,0), 
	"PW_PERIOD" VARCHAR2(50), 
	"USE_CHK" VARCHAR2(1), 
	"EXPIRE_DT" VARCHAR2(8), 
	"USER_DIV" VARCHAR2(1), 
	"APPLICANT_ID" VARCHAR2(5), 
	"BIZ_NO" VARCHAR2(13), 
	"BIZ_DIV" VARCHAR2(1), 
	"CHARGE_NM" VARCHAR2(20), 
	"DEPT" VARCHAR2(20), 
	"POS" VARCHAR2(20), 
	"BIZ_CONDITION" VARCHAR2(20), 
	"BIZ_LINE" VARCHAR2(20), 
	"CO_NM_ENG" VARCHAR2(50), 
	"REP_NM" VARCHAR2(26), 
	"REP_NM_ENG" VARCHAR2(50), 
	"ZIP_CD" VARCHAR2(5), 
	"ADDRESS" VARCHAR2(100), 
	"ADDRESS2" VARCHAR2(100), 
	"ADDRESS_EN" VARCHAR2(100), 
	"TG_NO" VARCHAR2(15), 
	"ATCH_FILE_ID" VARCHAR2(20), 
	"USER_STATUS" VARCHAR2(1), 
	"WITHDRAW_DT" VARCHAR2(8), 
	"WITHDRAW_PROC_DTM" DATE, 
	"WITHDRAW_REASON" VARCHAR2(50), 
	"FAX_NO" VARCHAR2(20), 
	"HS_MNG_OPERATE" VARCHAR2(1), 
	"AUTO_SEND_YN" VARCHAR2(1), 
	"ITEM_SEND_YN" VARCHAR2(1), 
	"REG_MALL_ID" VARCHAR2(35), 
	"UTH_USER_ID" VARCHAR2(20), 
	"SIGN_VALUE" VARCHAR2(10), 
	"IS_NEW" VARCHAR2(1), 
	"APPROVAL_DTM" DATE, 
	"REG_ID" VARCHAR2(35), 
	"REG_DTM" DATE, 
	"MOD_ID" VARCHAR2(35), 
	"MOD_DTM" DATE, 
	 CONSTRAINT "PK_CMM_USER" PRIMARY KEY ("USER_ID")
  );
  
COMMENT ON TABLE "CMM_USER" IS '사용자';
COMMENT ON COLUMN "CMM_USER"."UTH_USER_ID" IS 'UTH사용자ID';
COMMENT ON COLUMN "CMM_USER"."AUTO_SEND_YN" IS '자동신고여부';
COMMENT ON COLUMN "CMM_USER"."ITEM_SEND_YN" IS '품목별신고여부';
COMMENT ON COLUMN "CMM_USER"."REG_MALL_ID" IS '등록몰ID';
COMMENT ON COLUMN "CMM_USER"."APPROVAL_DTM" IS '승인일자';
COMMENT ON COLUMN "CMM_USER"."SIGN_VALUE" IS '전자서명';
COMMENT ON COLUMN "CMM_USER"."USER_ID" IS '사용자ID';
COMMENT ON COLUMN "CMM_USER"."USER_NM" IS '사용자명업체명';
COMMENT ON COLUMN "CMM_USER"."USER_PW" IS '패스워드';
COMMENT ON COLUMN "CMM_USER"."AUTH_CD" IS '권한코드';
COMMENT ON COLUMN "CMM_USER"."TEL_NO" IS '전화번호';
COMMENT ON COLUMN "CMM_USER"."HP_NO" IS '휴대폰번호';
COMMENT ON COLUMN "CMM_USER"."EMAIL" IS '이메일';
COMMENT ON COLUMN "CMM_USER"."LOGIN_START" IS '최초로그인시간';
COMMENT ON COLUMN "CMM_USER"."LOGIN_LAST" IS '최종로그인시간';
COMMENT ON COLUMN "CMM_USER"."LOGIN_ERROR" IS '로그인오류';
COMMENT ON COLUMN "CMM_USER"."PW_PRIOR" IS '이전패스워드';
COMMENT ON COLUMN "CMM_USER"."PW_CHANGE" IS '패스워드변경일시';
COMMENT ON COLUMN "CMM_USER"."PW_UPDATE" IS '패스워드변경주기';
COMMENT ON COLUMN "CMM_USER"."PW_PERIOD" IS '패스워드사용기간';
COMMENT ON COLUMN "CMM_USER"."USE_CHK" IS '사용여부';
COMMENT ON COLUMN "CMM_USER"."EXPIRE_DT" IS '만료일자';
COMMENT ON COLUMN "CMM_USER"."USER_DIV" IS '사용자구분(S:셀러, M:몰, G:관세사, E:특송사, A:어드민, C:콜센터)';
COMMENT ON COLUMN "CMM_USER"."REG_ID" IS '등록자ID';
COMMENT ON COLUMN "CMM_USER"."REG_DTM" IS '등록일시';
COMMENT ON COLUMN "CMM_USER"."MOD_ID" IS '수정자ID';
COMMENT ON COLUMN "CMM_USER"."MOD_DTM" IS '수정일시';
COMMENT ON COLUMN "CMM_USER"."APPLICANT_ID" IS '신고인부호';
COMMENT ON COLUMN "CMM_USER"."BIZ_NO" IS '사업자등록번호';
COMMENT ON COLUMN "CMM_USER"."BIZ_DIV" IS '사업자구분';
COMMENT ON COLUMN "CMM_USER"."CHARGE_NM" IS '담당자명';
COMMENT ON COLUMN "CMM_USER"."DEPT" IS '부서';
COMMENT ON COLUMN "CMM_USER"."POS" IS '직위';
COMMENT ON COLUMN "CMM_USER"."BIZ_CONDITION" IS '업태';
COMMENT ON COLUMN "CMM_USER"."BIZ_LINE" IS '종목';
COMMENT ON COLUMN "CMM_USER"."CO_NM_ENG" IS '업체영문명';
COMMENT ON COLUMN "CMM_USER"."REP_NM" IS '대표자명';
COMMENT ON COLUMN "CMM_USER"."REP_NM_ENG" IS '대표자영문명';
COMMENT ON COLUMN "CMM_USER"."ZIP_CD" IS '우편번호';
COMMENT ON COLUMN "CMM_USER"."ADDRESS" IS '주소';
COMMENT ON COLUMN "CMM_USER"."ADDRESS2" IS '상세주소';
COMMENT ON COLUMN "CMM_USER"."ADDRESS_EN" IS '영문주소';
COMMENT ON COLUMN "CMM_USER"."TG_NO" IS '통관고유부호';
COMMENT ON COLUMN "CMM_USER"."ATCH_FILE_ID" IS '첨부파일';
COMMENT ON COLUMN "CMM_USER"."USER_STATUS" IS '가입상태';
COMMENT ON COLUMN "CMM_USER"."WITHDRAW_DT" IS '탈퇴일자';
COMMENT ON COLUMN "CMM_USER"."WITHDRAW_PROC_DTM" IS '탈퇴처리일시';
COMMENT ON COLUMN "CMM_USER"."WITHDRAW_REASON" IS '탈퇴사유';
COMMENT ON COLUMN "CMM_USER"."FAX_NO" IS '팩스번호';
COMMENT ON COLUMN "CMM_USER"."HS_MNG_OPERATE" IS '상품HS분류권한';
COMMENT ON COLUMN "CMM_USER"."UTH_USER_ID" IS 'UTH사용자ID';
COMMENT ON COLUMN "CMM_USER"."AUTO_SEND_YN" IS '자동신고여부';
COMMENT ON COLUMN "CMM_USER"."ITEM_SEND_YN" IS '품목별신고여부';
COMMENT ON COLUMN "CMM_USER"."REG_MALL_ID" IS '등록몰ID';
COMMENT ON COLUMN "CMM_USER"."APPROVAL_DTM" IS '승인일자';
COMMENT ON COLUMN "CMM_USER"."SIGN_VALUE" IS '전자서명';
COMMENT ON COLUMN "CMM_USER"."USER_ID" IS '사용자ID';
COMMENT ON COLUMN "CMM_USER"."USER_NM" IS '사용자명업체명';
COMMENT ON COLUMN "CMM_USER"."USER_PW" IS '패스워드';
COMMENT ON COLUMN "CMM_USER"."AUTH_CD" IS '권한코드';
COMMENT ON COLUMN "CMM_USER"."TEL_NO" IS '전화번호';
COMMENT ON COLUMN "CMM_USER"."HP_NO" IS '휴대폰번호';
COMMENT ON COLUMN "CMM_USER"."EMAIL" IS '이메일';
COMMENT ON COLUMN "CMM_USER"."LOGIN_START" IS '최초로그인시간';
COMMENT ON COLUMN "CMM_USER"."LOGIN_LAST" IS '최종로그인시간';
COMMENT ON COLUMN "CMM_USER"."LOGIN_ERROR" IS '로그인오류';
COMMENT ON COLUMN "CMM_USER"."PW_PRIOR" IS '이전패스워드';
COMMENT ON COLUMN "CMM_USER"."PW_CHANGE" IS '패스워드변경일시';
COMMENT ON COLUMN "CMM_USER"."PW_UPDATE" IS '패스워드변경주기';
COMMENT ON COLUMN "CMM_USER"."PW_PERIOD" IS '패스워드사용기간';
COMMENT ON COLUMN "CMM_USER"."USE_CHK" IS '사용여부';
COMMENT ON COLUMN "CMM_USER"."EXPIRE_DT" IS '만료일자';
COMMENT ON COLUMN "CMM_USER"."USER_DIV" IS '사용자구분(S:셀러, M:몰, G:관세사, E:특송사, A:어드민, C:콜센터)';
COMMENT ON COLUMN "CMM_USER"."REG_ID" IS '등록자ID';
COMMENT ON COLUMN "CMM_USER"."REG_DTM" IS '등록일시';
COMMENT ON COLUMN "CMM_USER"."MOD_ID" IS '수정자ID';
COMMENT ON COLUMN "CMM_USER"."MOD_DTM" IS '수정일시';
COMMENT ON COLUMN "CMM_USER"."APPLICANT_ID" IS '신고인부호';
COMMENT ON COLUMN "CMM_USER"."BIZ_NO" IS '사업자등록번호';
COMMENT ON COLUMN "CMM_USER"."BIZ_DIV" IS '사업자구분';
COMMENT ON COLUMN "CMM_USER"."CHARGE_NM" IS '담당자명';
COMMENT ON COLUMN "CMM_USER"."DEPT" IS '부서';
COMMENT ON COLUMN "CMM_USER"."POS" IS '직위';
COMMENT ON COLUMN "CMM_USER"."BIZ_CONDITION" IS '업태';
COMMENT ON COLUMN "CMM_USER"."BIZ_LINE" IS '종목';
COMMENT ON COLUMN "CMM_USER"."CO_NM_ENG" IS '업체영문명';
COMMENT ON COLUMN "CMM_USER"."REP_NM" IS '대표자명';
COMMENT ON COLUMN "CMM_USER"."REP_NM_ENG" IS '대표자영문명';
COMMENT ON COLUMN "CMM_USER"."ZIP_CD" IS '우편번호';
COMMENT ON COLUMN "CMM_USER"."ADDRESS" IS '주소';
COMMENT ON COLUMN "CMM_USER"."ADDRESS2" IS '상세주소';
COMMENT ON COLUMN "CMM_USER"."ADDRESS_EN" IS '영문주소';
COMMENT ON COLUMN "CMM_USER"."TG_NO" IS '통관고유부호';
COMMENT ON COLUMN "CMM_USER"."ATCH_FILE_ID" IS '첨부파일';
COMMENT ON COLUMN "CMM_USER"."USER_STATUS" IS '가입상태';
COMMENT ON COLUMN "CMM_USER"."WITHDRAW_DT" IS '탈퇴일자';
COMMENT ON COLUMN "CMM_USER"."WITHDRAW_PROC_DTM" IS '탈퇴처리일시';
COMMENT ON COLUMN "CMM_USER"."WITHDRAW_REASON" IS '탈퇴사유';
COMMENT ON COLUMN "CMM_USER"."FAX_NO" IS '팩스번호';
COMMENT ON COLUMN "CMM_USER"."HS_MNG_OPERATE" IS '상품HS분류권한';

CREATE TABLE "CMM_MENU_MAS" 
   (	"MENU_ID" VARCHAR2(20) NOT NULL ENABLE, 
	"PMENU_ID" VARCHAR2(20), 
	"MENU_NM" VARCHAR2(50), 
	"MENU_DC" VARCHAR2(500), 
	"MENU_PATH" VARCHAR2(100), 
	"MENU_URL" VARCHAR2(100), 
	"MENU_LEVEL" VARCHAR2(1), 
	"MENU_DIV" VARCHAR2(1), 
	"LINK_YN" VARCHAR2(1), 
	"MENU_ORDR" NUMBER(10,0), 
	"REG_ID" VARCHAR2(35), 
	"REG_DTM" DATE, 
	"MOD_ID" VARCHAR2(35), 
	"MOD_DTM" DATE, 
	"DASH_PATH" VARCHAR2(100), 
	"DASH_URL" VARCHAR2(100), 
	 CONSTRAINT "PK_CMM_MENU_MAS" PRIMARY KEY ("MENU_ID")
  );
  
COMMENT ON TABLE "CMM_MENU_MAS" IS '메뉴';  
COMMENT ON COLUMN "CMM_MENU_MAS"."MENU_ID" IS '메뉴코드';
COMMENT ON COLUMN "CMM_MENU_MAS"."PMENU_ID" IS '상위메뉴코드';
COMMENT ON COLUMN "CMM_MENU_MAS"."MENU_NM" IS '메뉴명';
COMMENT ON COLUMN "CMM_MENU_MAS"."MENU_DC" IS '메뉴설명';
COMMENT ON COLUMN "CMM_MENU_MAS"."MENU_PATH" IS '경로';
COMMENT ON COLUMN "CMM_MENU_MAS"."MENU_URL" IS '주소';
COMMENT ON COLUMN "CMM_MENU_MAS"."MENU_LEVEL" IS '레벨';
COMMENT ON COLUMN "CMM_MENU_MAS"."MENU_DIV" IS '구분';
COMMENT ON COLUMN "CMM_MENU_MAS"."LINK_YN" IS '링크여부';
COMMENT ON COLUMN "CMM_MENU_MAS"."MENU_ORDR" IS '순서';
COMMENT ON COLUMN "CMM_MENU_MAS"."REG_ID" IS '등록자ID';
COMMENT ON COLUMN "CMM_MENU_MAS"."REG_DTM" IS '등록일시';
COMMENT ON COLUMN "CMM_MENU_MAS"."MOD_ID" IS '수정자ID';
COMMENT ON COLUMN "CMM_MENU_MAS"."MOD_DTM" IS '수정일시';
COMMENT ON COLUMN "CMM_MENU_MAS"."DASH_PATH" IS '대시보드 경로';
COMMENT ON COLUMN "CMM_MENU_MAS"."DASH_URL" IS '대시보드 URL';

  CREATE TABLE "CMM_AUTH" 
   (	"AUTH_CD" VARCHAR2(20), 
	"AUTH_NM" VARCHAR2(50), 
	"AUTH_EXPLAIN" VARCHAR2(100), 
	"USE_YN" VARCHAR2(1), 
	"REG_ID" VARCHAR2(35), 
	"REG_DTM" DATE, 
	"MOD_ID" VARCHAR2(35), 
	"MOD_DTM" DATE, 
	"AUTH_DIV" VARCHAR2(1), 
	 CONSTRAINT "PK_CMM_AUTH" PRIMARY KEY ("AUTH_CD")
  );

COMMENT ON TABLE "CMM_AUTH" IS '권한';
COMMENT ON COLUMN "CMM_AUTH"."AUTH_CD" IS '권한코드';
COMMENT ON COLUMN "CMM_AUTH"."AUTH_NM" IS '권한명';
COMMENT ON COLUMN "CMM_AUTH"."AUTH_EXPLAIN" IS '권한설명';
COMMENT ON COLUMN "CMM_AUTH"."USE_YN" IS '사용여부';
COMMENT ON COLUMN "CMM_AUTH"."REG_ID" IS '등록자ID';
COMMENT ON COLUMN "CMM_AUTH"."REG_DTM" IS '등록일시';
COMMENT ON COLUMN "CMM_AUTH"."MOD_ID" IS '수정자ID';
COMMENT ON COLUMN "CMM_AUTH"."MOD_DTM" IS '수정일시';
COMMENT ON COLUMN "CMM_AUTH"."AUTH_DIV" IS '권한구분(''W'': 업무사용, ''M'' 어드민)';

  CREATE TABLE "CMM_MESSAGE" 
   (	"TYPE" VARCHAR2(1) NOT NULL ENABLE, 
	"CODE" VARCHAR2(8) NOT NULL ENABLE, 
	"MESSAGE" VARCHAR2(500), 
	"USE_YN" VARCHAR2(1) DEFAULT 'Y', 
	 CONSTRAINT "BT_MESSAGE_PK" PRIMARY KEY ("TYPE", "CODE")
  );

COMMENT ON TABLE "CMM_MESSAGE" IS '알림메시지';

COMMENT ON COLUMN "CMM_MESSAGE"."TYPE" IS '메세지유형(I:안내메세지, W:경고메세지, E:에러메세지, C:확인메세지)';
COMMENT ON COLUMN "CMM_MESSAGE"."CODE" IS '메세지코드';
COMMENT ON COLUMN "CMM_MESSAGE"."MESSAGE" IS '메세지내용';
COMMENT ON COLUMN "CMM_MESSAGE"."USE_YN" IS '사용여부';

  CREATE TABLE "CMM_MENU_AUTH" 
   (	"AUTH_CD" VARCHAR2(20) NOT NULL ENABLE, 
	"MENU_ID" VARCHAR2(20) NOT NULL ENABLE, 
	"REG_ID" VARCHAR2(35), 
	"REG_DTM" DATE, 
	"MOD_ID" VARCHAR2(35), 
	"MOD_DTM" DATE, 
	 CONSTRAINT "PK_CMM_MENU_AUTH" PRIMARY KEY ("AUTH_CD", "MENU_ID")
  );

COMMENT ON TABLE "CMM_MENU_AUTH" IS '메뉴권한';
COMMENT ON COLUMN "CMM_MENU_AUTH"."AUTH_CD" IS '권한코드';
COMMENT ON COLUMN "CMM_MENU_AUTH"."MENU_ID" IS '메뉴구분';
COMMENT ON COLUMN "CMM_MENU_AUTH"."REG_ID" IS '등록자ID';
COMMENT ON COLUMN "CMM_MENU_AUTH"."REG_DTM" IS '등록일시';
COMMENT ON COLUMN "CMM_MENU_AUTH"."MOD_ID" IS '수정자ID';
COMMENT ON COLUMN "CMM_MENU_AUTH"."MOD_DTM" IS '수정일시';

CREATE TABLE "CMM_MENU_BTN_AUTH" 
   (	"AUTH_CD" VARCHAR2(20) NOT NULL ENABLE, 
	"MENU_ID" VARCHAR2(20) NOT NULL ENABLE, 
	"BTN_ID" VARCHAR2(15) NOT NULL ENABLE, 
	"REG_DTM" DATE, 
	"REG_ID" VARCHAR2(35), 
	"MOD_DTM" DATE, 
	"MOD_ID" VARCHAR2(35), 
	 CONSTRAINT "PK_CMM_MENU_BTN_AUTH" PRIMARY KEY ("AUTH_CD", "MENU_ID", "BTN_ID")
  );

  CREATE TABLE "CMM_MENU_BTN" 
   (	"MENU_ID" VARCHAR2(20) NOT NULL ENABLE, 
	"BTN_ID" VARCHAR2(15) NOT NULL ENABLE, 
	"BTN_NM" VARCHAR2(20) NOT NULL ENABLE, 
	"REG_ID" VARCHAR2(35), 
	"REG_DTM" DATE, 
	"MOD_ID" VARCHAR2(35), 
	"MOD_DTM" DATE, 
	 CONSTRAINT "PK_CMM_MENU_BTN" PRIMARY KEY ("MENU_ID", "BTN_ID")
  );
CREATE INDEX "IX_CMM_MENU_BTN_AUTH" ON "CMM_MENU_BTN_AUTH" ("AUTH_CD", "MENU_ID") ;

COMMENT ON TABLE "CMM_MENU_BTN" IS '메뉴별 버튼';
COMMENT ON TABLE "CMM_MENU_BTN_AUTH" IS '메뉴별 버튼 권한';

COMMENT ON COLUMN "CMM_MENU_BTN"."MENU_ID" IS '메뉴코드';
COMMENT ON COLUMN "CMM_MENU_BTN"."BTN_ID" IS '버튼아이디';
COMMENT ON COLUMN "CMM_MENU_BTN"."BTN_NM" IS '버튼명';
COMMENT ON COLUMN "CMM_MENU_BTN"."REG_ID" IS '등록자ID';
COMMENT ON COLUMN "CMM_MENU_BTN"."REG_DTM" IS '등록일시';
COMMENT ON COLUMN "CMM_MENU_BTN"."MOD_ID" IS '수정자ID';
COMMENT ON COLUMN "CMM_MENU_BTN"."MOD_DTM" IS '수정일시';
COMMENT ON COLUMN "CMM_MENU_BTN_AUTH"."AUTH_CD" IS '';
COMMENT ON COLUMN "CMM_MENU_BTN_AUTH"."MENU_ID" IS '';
COMMENT ON COLUMN "CMM_MENU_BTN_AUTH"."BTN_ID" IS '';
COMMENT ON COLUMN "CMM_MENU_BTN_AUTH"."REG_DTM" IS '';
COMMENT ON COLUMN "CMM_MENU_BTN_AUTH"."REG_ID" IS '';
COMMENT ON COLUMN "CMM_MENU_BTN_AUTH"."MOD_DTM" IS '';
COMMENT ON COLUMN "CMM_MENU_BTN_AUTH"."MOD_ID" IS '';

CREATE TABLE "CMM_STD_CLASS" 
   (	"CLASS_ID" VARCHAR2(50) NOT NULL ENABLE, 
	"CLASS_NM" VARCHAR2(50), 
	"USE_CHK" VARCHAR2(1), 
	"USER_REF1" VARCHAR2(100), 
	"USER_REF2" VARCHAR2(100), 
	"USER_REF3" VARCHAR2(100), 
	"USER_REF4" VARCHAR2(100), 
	"USER_REF5" VARCHAR2(100), 
	"UPDATE_YN" VARCHAR2(1), 
	"REG_ID" VARCHAR2(35), 
	"REG_DTM" DATE, 
	"MOD_ID" VARCHAR2(35), 
	"MOD_DTM" DATE, 
	 CONSTRAINT "PK_CMM_STD_CLASS" PRIMARY KEY ("CLASS_ID")
  );

COMMENT ON TABLE "CMM_STD_CLASS" IS '표준코드클래스';
COMMENT ON COLUMN "CMM_STD_CLASS"."CLASS_ID" IS '클래스ID';
COMMENT ON COLUMN "CMM_STD_CLASS"."CLASS_NM" IS '클래스명';
COMMENT ON COLUMN "CMM_STD_CLASS"."USE_CHK" IS '사용여부';
COMMENT ON COLUMN "CMM_STD_CLASS"."USER_REF1" IS '사용자항목1';
COMMENT ON COLUMN "CMM_STD_CLASS"."USER_REF2" IS '사용자항목2';
COMMENT ON COLUMN "CMM_STD_CLASS"."USER_REF3" IS '사용자항목3';
COMMENT ON COLUMN "CMM_STD_CLASS"."USER_REF4" IS '사용자항목4';
COMMENT ON COLUMN "CMM_STD_CLASS"."USER_REF5" IS '사용자항목5';
COMMENT ON COLUMN "CMM_STD_CLASS"."UPDATE_YN" IS '업데이트여부';
COMMENT ON COLUMN "CMM_STD_CLASS"."REG_ID" IS '등록자ID';
COMMENT ON COLUMN "CMM_STD_CLASS"."REG_DTM" IS '등록일시';
COMMENT ON COLUMN "CMM_STD_CLASS"."MOD_ID" IS '수정자ID';
COMMENT ON COLUMN "CMM_STD_CLASS"."MOD_DTM" IS '수정일시';

  CREATE TABLE "CMM_STD_CODE" 
   (	"CLASS_ID" VARCHAR2(50) NOT NULL ENABLE, 
	"CODE" VARCHAR2(30) NOT NULL ENABLE, 
	"SEQ" NUMBER(4,0), 
	"CODE_NM" VARCHAR2(300), 
	"CODE_SHT" VARCHAR2(50), 
	"USE_CHK" VARCHAR2(1), 
	"USER_REF1" VARCHAR2(100), 
	"USER_REF2" VARCHAR2(100), 
	"USER_REF3" VARCHAR2(100), 
	"USER_REF4" VARCHAR2(100), 
	"USER_REF5" VARCHAR2(100), 
	"REG_ID" VARCHAR2(35), 
	"REG_DTM" DATE, 
	"MOD_ID" VARCHAR2(35), 
	"MOD_DTM" DATE, 
	 CONSTRAINT "PK_CMM_STD_CODE" PRIMARY KEY ("CLASS_ID", "CODE")
  );

COMMENT ON TABLE "CMM_STD_CODE" IS '표준코드';
COMMENT ON COLUMN "CMM_STD_CODE"."USER_REF3" IS '사용자항목3';
COMMENT ON COLUMN "CMM_STD_CODE"."USER_REF4" IS '사용자항목4';
COMMENT ON COLUMN "CMM_STD_CODE"."USER_REF5" IS '사용자항목5';
COMMENT ON COLUMN "CMM_STD_CODE"."REG_ID" IS '등록자ID';
COMMENT ON COLUMN "CMM_STD_CODE"."REG_DTM" IS '등록일시';
COMMENT ON COLUMN "CMM_STD_CODE"."MOD_ID" IS '수정자ID';
COMMENT ON COLUMN "CMM_STD_CODE"."MOD_DTM" IS '수정일시';
COMMENT ON COLUMN "CMM_STD_CODE"."CLASS_ID" IS '클래스ID';
COMMENT ON COLUMN "CMM_STD_CODE"."CODE" IS '코드';
COMMENT ON COLUMN "CMM_STD_CODE"."SEQ" IS '순서';
COMMENT ON COLUMN "CMM_STD_CODE"."CODE_NM" IS '코드명';
COMMENT ON COLUMN "CMM_STD_CODE"."CODE_SHT" IS '코드설명';
COMMENT ON COLUMN "CMM_STD_CODE"."USE_CHK" IS '사용여부';
COMMENT ON COLUMN "CMM_STD_CODE"."USER_REF1" IS '사용자항목1';
COMMENT ON COLUMN "CMM_STD_CODE"."USER_REF2" IS '사용자항목2';

CREATE TABLE "CMM_IP_ACCESS" 
   (	"USER_ID" VARCHAR2(35) NOT NULL ENABLE, 
	"IP" VARCHAR2(19) NOT NULL ENABLE, 
	"AUTH_YN" VARCHAR2(1), 
	"REG_ID" VARCHAR2(35), 
	"REG_DTM" DATE, 
	"MOD_ID" VARCHAR2(35), 
	"MOD_DTM" DATE, 
	 CONSTRAINT "PK_CMM_IP_ACCESS" PRIMARY KEY ("USER_ID", "IP")
  );

COMMENT ON TABLE "CMM_IP_ACCESS" IS 'IP 접속관리';
COMMENT ON COLUMN "CMM_IP_ACCESS"."USER_ID" IS '';
COMMENT ON COLUMN "CMM_IP_ACCESS"."IP" IS '';
COMMENT ON COLUMN "CMM_IP_ACCESS"."AUTH_YN" IS '';
COMMENT ON COLUMN "CMM_IP_ACCESS"."REG_ID" IS '';
COMMENT ON COLUMN "CMM_IP_ACCESS"."REG_DTM" IS '';
COMMENT ON COLUMN "CMM_IP_ACCESS"."MOD_ID" IS '';
COMMENT ON COLUMN "CMM_IP_ACCESS"."MOD_DTM" IS '';

CREATE TABLE "CMM_LOG_MNG" 
   (	"KEY" VARCHAR2(32), 
	"SCREEN_ID" VARCHAR2(50), 
	"URI" VARCHAR2(500), 
	"RMK" VARCHAR2(1000), 
	"REG_ID" VARCHAR2(35), 
	"REG_DTM" DATE
   ) ;

COMMENT ON TABLE "CMM_LOG_MNG" IS '로그필터관리';
COMMENT ON COLUMN "CMM_LOG_MNG"."KEY" IS 'KEY(UUID)';
COMMENT ON COLUMN "CMM_LOG_MNG"."SCREEN_ID" IS '사용화면ID';
COMMENT ON COLUMN "CMM_LOG_MNG"."URI" IS 'URI';
COMMENT ON COLUMN "CMM_LOG_MNG"."RMK" IS '비고';
COMMENT ON COLUMN "CMM_LOG_MNG"."REG_ID" IS '등록자';
COMMENT ON COLUMN "CMM_LOG_MNG"."REG_DTM" IS '등록일자';

CREATE TABLE "CMM_LOG" 
   (	"SID" VARCHAR2(30) NOT NULL ENABLE, 
	"SESSION_ID" VARCHAR2(50), 
	"LOG_DIV" VARCHAR2(2), 
	"USER_ID" VARCHAR2(35), 
	"LOGIN_IP" VARCHAR2(30), 
	"SCREEN_ID" VARCHAR2(50), 
	"SCREEN_NM" VARCHAR2(50), 
	"API_ID" VARCHAR2(50), 
	"API_KEY" VARCHAR2(200), 
	"DETAIL_CNT" NUMBER(*,0), 
	"URI" VARCHAR2(500), 
	"RMK" VARCHAR2(1000), 
	"PARAM" CLOB, 
	"LOG_DTM" TIMESTAMP (6) DEFAULT sysdate, 
	 CONSTRAINT "PK_CMM_LOG" PRIMARY KEY ("SID")
  );

CREATE INDEX "IX_CMM_LOG" ON "CMM_LOG" ("LOG_DIV") ;
COMMENT ON TABLE "CMM_LOG" IS '접속로그';
COMMENT ON COLUMN "CMM_LOG"."SID" IS '로그ID';
COMMENT ON COLUMN "CMM_LOG"."SESSION_ID" IS '세션ID';
COMMENT ON COLUMN "CMM_LOG"."LOG_DIV" IS '로그구분(W:사용자, M:어드민, B:스케쥴, S:모바일)';
COMMENT ON COLUMN "CMM_LOG"."USER_ID" IS '사용자ID';
COMMENT ON COLUMN "CMM_LOG"."LOGIN_IP" IS '사용자IP';
COMMENT ON COLUMN "CMM_LOG"."SCREEN_ID" IS '사용화면ID';
COMMENT ON COLUMN "CMM_LOG"."SCREEN_NM" IS '사용화면명';
COMMENT ON COLUMN "CMM_LOG"."API_ID" IS 'API명';
COMMENT ON COLUMN "CMM_LOG"."API_KEY" IS 'APIKey';
COMMENT ON COLUMN "CMM_LOG"."DETAIL_CNT" IS '상세건수';
COMMENT ON COLUMN "CMM_LOG"."URI" IS 'URI';
COMMENT ON COLUMN "CMM_LOG"."RMK" IS '비고';
COMMENT ON COLUMN "CMM_LOG"."PARAM" IS '파라미터';
COMMENT ON COLUMN "CMM_LOG"."LOG_DTM" IS '로그일시';

