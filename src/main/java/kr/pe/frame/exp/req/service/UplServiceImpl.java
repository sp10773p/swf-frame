package kr.pe.frame.exp.req.service;

import kr.pe.frame.adm.sys.model.UsrSessionModel;
import kr.pe.frame.cmm.core.base.BizException;
import kr.pe.frame.cmm.core.base.CommonDAO;
import kr.pe.frame.cmm.core.model.AjaxModel;
import kr.pe.frame.cmm.core.service.CommonService;
import kr.pe.frame.cmm.core.service.CommonValidatorService;
import kr.pe.frame.cmm.excel.ColumnInfo;
import kr.pe.frame.cmm.excel.ExcelReader;
import kr.pe.frame.cmm.util.StringUtil;
import kr.pe.frame.exp.req.controller.ExpDecReqValidator;

import org.apache.commons.collections.MapUtils;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * Created by jjkhj on 2017-01-09.
 */
@Service("uplService")
@SuppressWarnings({"unchecked", "rawtypes"})
public class UplServiceImpl implements UplService {
    @Resource(name = "commonDAO")
    private CommonDAO commonDAO;

    @Resource(name = "commonService")
    private CommonService commonService;
    
    @Resource(name = "commonValidator")
    private CommonValidatorService commonValidator;
    
    @Resource(name = "excelReader")
    private ExcelReader excelReader;

    @Override
    public AjaxModel selectDecExcelList(AjaxModel model) throws Exception {
        
    	Map<String, Object> param = model.getData();
        param.put("USER_ID", model.getUsrSessionModel().getUserId());
        model.setData(param);
        
    	model = commonService.selectGridPagingList(model);

        return model;
    }

	/**
	 * 엑셀업로드
	 */
	@Override
	public AjaxModel uploadDecExcel(AjaxModel model) throws Exception {
		
		// SEQ_EXCEL.NEXTVAL 
       
        UsrSessionModel usrSession = model.getUsrSessionModel();
        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
        
        // INSERT : EXP_EXPREG_EXCEL 
        Map<String, Object> param = model.getData();
        param.put("USER_ID"		, usrSession.getUserId());
        param.put("MALL_ID" 	, usrSession.getUserId());
        param.put("TIMESTAMP"	, formatter.format(new Date()));
        commonDAO.insert("upl.insertExcelMain", param);
        
        List<ColumnInfo> excelInfoList = new ArrayList<ColumnInfo>();
		/*  
		//판매자 정보
		excelInfoList.add(setColumnInfo("EOCPARTYPARTYIDID1"     , "판매자사업자등록번호"	, 13));  
		excelInfoList.add(setColumnInfo("EOCPARTYORGNAME2"       , "판매자상호"			, 28));    
		excelInfoList.add(setColumnInfo("EOCPARTYORGCEONAME"     , "판매자대표자명"		, 12));  
		excelInfoList.add(setColumnInfo("APPLICANTPARTYORGID"    , "판매자신고인부호"		, 5)); 
		excelInfoList.add(setColumnInfo("EOCPARTYPARTYIDID2"     , "판매자통관고유부호"		, 15));  
		excelInfoList.add(setColumnInfo("EOCPARTYLOCID"          , "판매자우편번호"		, 5));       
		excelInfoList.add(setColumnInfo("EOCPARTYADDRLINE"    	 , "판매자주소"			, 300));    // 판매자주소
		*/
		
		// 주문정보
		excelInfoList.add(setColumnInfo("ORDER_ID"               , "주문번호"				, 35)); // DB 컬럼 크기는 50이나 EXP_EXPDEC_REQ.REQ_NO 값을 만들 때 15자리 날짜 값과 합치기 때문에 최대값 35
		excelInfoList.add(setColumnInfo("MALL_ITEM_NO"           , "상품ID"				, 35)); // DB 컬럼 크기는 50이나 EXP_EXPDEC_REQ_ITEM.REQ_NO 값을 만들 때 15자리 날짜 값과 합치기 때문에 최대값 35
		excelInfoList.add(setColumnInfo("ITEMNAME_EN"            , "상품명 (영문)"				, 50));
		excelInfoList.add(setColumnInfo("LINEITEMQUANTITY"       , "주문수량"				, 20));
		excelInfoList.add(setColumnInfo("PAYMENTAMOUNT"          , "결제금액"				, 20));
		excelInfoList.add(setColumnInfo("PAYMENTAMOUNT_CUR"      , "결제통화코드"			, 30));
		excelInfoList.add(setColumnInfo("BUYERPARTYORGNAME"      , "구매자상호명"			, 60));
		excelInfoList.add(setColumnInfo("DESTINATIONCOUNTRYCODE" , "목적국 국가코드"		, 30));
		excelInfoList.add(setColumnInfo("CLASSIDHSID"            , "HS코드"				, 11));
		excelInfoList.add(setColumnInfo("NETWEIGHTMEASURE"       , "중량"				, 20));
		excelInfoList.add(setColumnInfo("DECLARATIONAMOUNT"      , "가격"				, 20));
		excelInfoList.add(setColumnInfo("SELL_MALL_DOMAIN"       , "도메인명"				, 50));
		
		// 환급신청을 위한 제조자 정보 추가
		excelInfoList.add(setColumnInfo("MAKER_NM"				 , "제조자"				, 28));
		excelInfoList.add(setColumnInfo("MAKER_REG_ID"			 , "제조자사업자번호"		, 13));
		excelInfoList.add(setColumnInfo("MAKER_LOC_SEQ"			 , "제조자사업장일련번호"	, 4));
		excelInfoList.add(setColumnInfo("MAKER_ORG_ID"			 , "제조자통관고유부호"		, 15));
		excelInfoList.add(setColumnInfo("MAKER_POST_CD"			 , "제조장소(우편번호)"	, 5));
		excelInfoList.add(setColumnInfo("MAKER_LOC_CD"			 , "산업단지부호"			, 3));
		
		// 신규 추가
		excelInfoList.add(setColumnInfo("AMT_COD"				 , "인도조건"				, 3));
		excelInfoList.add(setColumnInfo("FRE_KRW"			 	 , "운임원화"		    	, 12));
		excelInfoList.add(setColumnInfo("INSU_KRW"			 	 , "보험료원화"			, 12));
		excelInfoList.add(setColumnInfo("COMP"			 		 , "상품성분명"			, 70));
		excelInfoList.add(setColumnInfo("LINEITEMQUANTITY_UC"	 , "주문수량단위"			, 3));
		
		// INSERT : EXP_EXPREG_EXCEL_DETAIL 
		uploadExcelExpreg(model, excelInfoList, param);
		
		//EXP_EXPREG_EXCEL_DETAIL 테이블 공백데이터 삭제
        commonDAO.delete("upl.deleteExcelDetailEmpty", null);
        
        // 업로드 목록 조회
        List<Map<String, Object>> xlsList = commonDAO.list("upl.selectDecExcelDetailList", param);
        
        // MaxSize 체크 (MaxSize 초과건 -> INSERT : EXP_EXPREG_EXCEL_ERRMSG) 
        checkMaxSize(excelInfoList, xlsList);
        
        // Validation 체크
        checkValidation(usrSession, xlsList);
		
		return model;
	}
	
	private void checkMaxSize(List<ColumnInfo> excelInfoList, List<Map<String, Object>> xlsList) {
        for (Map<String, Object> xls : xlsList) {
            Map<String, Object> row = xls;
            String status = (String) row.get("STATUS");

            if ("E".equals(status)) {
                String statusDesc = (String) row.get("STATUS_DESC");
                String[] statusDescArray = null;
                if (statusDesc != null) {
                    statusDescArray = statusDesc.split("/");
                    Map<String, Object> errMsgMap = null;

                    for (String errorColumnName : statusDescArray) {
                        errMsgMap = new HashMap<String, Object>();
                        errMsgMap.put("SN", row.get("SN"));
                        errMsgMap.put("SEQ", row.get("SEQ"));
                        errMsgMap.put("ERROR_COLUMN_NAME", errorColumnName);
                        String headerDesc = getHeaderName(excelInfoList, errorColumnName);
                        int maxSize = getMaxColumnSize(excelInfoList, errorColumnName);
                        errMsgMap.put("ERROR_MESSAGE", headerDesc + "의 길이가 너무 깁니다. 최대바이트(" + maxSize + ")");

                        commonDAO.insert("upl.insertExpregExcelErrmsgSelect", errMsgMap);
                    }
                }
            }
        }
    }
	
	private ColumnInfo setColumnInfo(String headerId, String headerName, int maxColumnSize) {
        ColumnInfo columnInfo = new ColumnInfo();
        columnInfo.setHeaderId(headerId);
        columnInfo.setHeaderName(headerName);
        columnInfo.setMaxColumnSize(maxColumnSize);
        return columnInfo;
    }
	
	private String getHeaderName(List<ColumnInfo> list, String id) {
        for (ColumnInfo dto : list) {
            if (id.equals(dto.getHeaderId())) {
                return dto.getHeaderName();
            }
        }
        return StringUtils.EMPTY;
    }
	
	private int getMaxColumnSize(List<ColumnInfo> list, String id) {
        for (ColumnInfo dto : list) {
        	if (id.equals(dto.getHeaderId())) {
                return dto.getMaxColumnSize();
            }
        }
        return 0;
    }
	
	private void addErrorInfo(List<Map<String, Object>> errorList, String errorColumnName, String errorColumnData, String errorMessage) {
        Map<String, Object> errorInfo = new HashMap<String, Object>();
        errorInfo.put("ERROR_COLUMN_NAME", errorColumnName);
        errorInfo.put("ERROR_COLUMN_DATA", errorColumnData);
        errorInfo.put("ERROR_MESSAGE", errorMessage);

        errorList.add(errorInfo);
    }
	
	
    private void uploadExcelExpreg(AjaxModel model, List<ColumnInfo> excelInfoList, Map<String, Object> extraData) throws Exception {
        List<Map<String, Object>> dataList = null;
        Map<String, Object> fileMap = null;
        String savePath = null;
        String streFileNm = null;
        String fileSn = null;
        String orignlFileNm = null;

        File file = null;
        FileInputStream fileIn = null;

        try {
            dataList = model.getDataList();
            fileMap = dataList.get(0);
            savePath = StringUtil.null2Str(fileMap.get("FILE_STRE_COURS"));
            streFileNm = StringUtil.null2Str(fileMap.get("STRE_FILE_NM"));
            fileSn = StringUtil.null2Str(fileMap.get("FILE_SN"));
            orignlFileNm = StringUtil.null2Str(fileMap.get("ORIGNL_FILE_NM"));
            if (orignlFileNm.endsWith("xls") || orignlFileNm.endsWith("xlsx")) {
            	file = new File(savePath + streFileNm + fileSn);
            	
				Map trnMap = excelReader.parseExcelOnlyFirstSheet(file);
            	
            	InputStream inp = null;
            	try{
                    inp = new FileInputStream(file);

                    Workbook wb = WorkbookFactory.create(inp);
                    
                    Sheet sheet = wb.getSheetAt(0);
                    
                    List<Map<String, Object>> valueList = new ArrayList<Map<String, Object>>();
	                
                    List<ColumnInfo> makeExcelInfoList = new ArrayList<ColumnInfo>();
                    for(int i = 0; i <= sheet.getLastRowNum(); i++) {
	  
	                      boolean bErr = false;
	                      String sStatusDesc = "";
	  
	                      Map<String, Object> excelData = new HashMap<String, Object>();
	                      String newHeaderNm = "";
	                      List<ColumnInfo> makeExcelInfo = new ArrayList<ColumnInfo>();
	                      Row row = sheet.getRow(i);
	                      for(int j = 0; j < row.getLastCellNum(); j++) {
	                      	if(row.getRowNum() == 0){ 
	                      		newHeaderNm = excelReader.getCellTrimValue(row, j);//ExcelUtil.getValue(row.getCell(j), true).trim();
	                      		makeExcelInfo = makeColumnInfo(excelInfoList, newHeaderNm);
	                      		makeExcelInfoList.addAll(makeExcelInfo);
	                      		continue;
	                      	}
	                      	//ColumnInfo columnInfoDTO = makeExcelInfoList.get(row.getCell(j).getColumnIndex());
	                      	ColumnInfo columnInfoDTO = makeExcelInfoList.get(j);
	                        String headerId = columnInfoDTO.getHeaderId();
                            String cellData = excelReader.getCellTrimValue(row, j);//ExcelUtil.getValue(row.getCell(j), true).trim();
	                        int maxColumnSize = columnInfoDTO.getMaxColumnSize();
	                          
	                          // 소수점 3자리 반올림
	          				if("PAYMENTAMOUNT".equals(headerId) || "DECLARATIONAMOUNT".equals(headerId)){
	          					//cellData = cell.getContents();
	          					int dotIdx = cellData.indexOf(".");
	          					if(StringUtil.isNumber(cellData) && dotIdx >= 0){
	          						int pointLen = cellData.length() - ++dotIdx;
	          						// 소수점 3자리 이상
	          						if(pointLen >= 3){
	          							BigDecimal bd = new BigDecimal(cellData);
	          							bd.setScale(2, RoundingMode.HALF_UP);
	          							cellData = bd.doubleValue() + "";
	          						}
	          					}
	          				}
	          				
	          				// 사업자번호에서 "-" 제거
	          				if ("EOCPARTYPARTYIDID1".equals(headerId) || "MAKER_REG_ID".equals(headerId)) {
	          					cellData = cellData.replaceAll("-", "");
	          				}
	          				// 상품명 길이 조정, 대괄호 내 [상표명] 텍스트 제거
	          				if ("ITEMNAME_EN".equals(headerId) && cellData.length() > maxColumnSize) {
	          					// 일단 [상표명] 제거
	          					cellData = cellData.replaceFirst("\\[[^\\[\\]]*\\]", "").trim(); // '['로 시작하고 ']'로 끝나는 문자열 제거
	  
	          					if (cellData.length() > maxColumnSize) {
	          						cellData = cellData.substring(0, maxColumnSize);
	          					}
	          				}
	  
	                          // 컬럼별 최대 크기 값으로 데이터를 자른다. 최대 크기 값이 0이면 자르지 않는다.
	                          if (maxColumnSize > 0) {
	                              if (cellData.length() > 0) {
	                                  if (cellData.getBytes("MS949").length > maxColumnSize) { // 오류정보 세팅하고 데이터 자른다.
	                                      bErr = true;
	                                      sStatusDesc += headerId + "/";
	  
	                                      cellData = StringUtil.toShortenStringMB(cellData, maxColumnSize);
	                                  }
	                              }
	                          }
	  
	                          excelData.put(headerId, cellData);
	                      }
	                      excelData.putAll(extraData);
	  
	                      if (bErr) {
	                          if (sStatusDesc.endsWith("/")) {
	                              sStatusDesc = sStatusDesc.substring(0, sStatusDesc.length() - 1); // 마지막 "/" 제거
	                          }
	  
	                          excelData.put("STATUS", "E");
	                          excelData.put("STATUS_DESC", sStatusDesc);
	                      }
	  
	                      valueList.add(excelData);
	                  }
	  
	                  for (Map<String, Object> param : valueList) {
	                      try {
	                          commonDAO.insert("upl.insertExcelDetail", param);
	                      } catch (Exception e) {
	                          e.printStackTrace();
	                      }
	                  }
     			
                }finally {
                    if(inp != null) {
                        IOUtils.closeQuietly(inp);
                    }
                }
            	
            }

        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        } finally {
            if (fileIn != null) {
                IOUtils.closeQuietly(fileIn);
            }
        }
    }
		
	//엑셀업로드 Header 동적생성
	private List<ColumnInfo> makeColumnInfo(List<ColumnInfo> excelInfoList, String newHeaderNm) {
		
		 List<ColumnInfo> newExcelInfoList = new ArrayList<ColumnInfo>();
		 
		 for(int i=0; i < excelInfoList.size(); i++){
			 ColumnInfo columnInfoDTO = excelInfoList.get(i);
			 String headerId = columnInfoDTO.getHeaderId();
             String headerName = columnInfoDTO.getHeaderName();
             int maxColumnSize = columnInfoDTO.getMaxColumnSize();
             if(headerName.equals(newHeaderNm)){
            	 newExcelInfoList.add(setColumnInfo(headerId    , headerName	, maxColumnSize));
             }
		 }
						
		return newExcelInfoList;
	}

	// 오류 체크
    private void checkValidation(UsrSessionModel usrSession, List<Map<String, Object>> xlsList) throws Exception {
    	List<Map<String, Object>> rowErrorList = null;
    	int compareIndex = 0;
        for (Map<String, Object> xls : xlsList) {
            boolean bErr = false;
            rowErrorList = new ArrayList<Map<String, Object>>();
            /* 
            //몰관리자 통합에 따른 판매자정보 주석처리
            String EOCPARTYPARTYIDID1 = StringUtil.null2Str(xls.get("EOCPARTYPARTYIDID1"));   // 판매자사업자등록번호
			String EOCPARTYORGNAME2 = StringUtil.null2Str(xls.get("EOCPARTYORGNAME2"));       // 판매자상호
			String EOCPARTYORGCEONAME = StringUtil.null2Str(xls.get("EOCPARTYORGCEONAME"));   // 판매자대표자명
			String APPLICANTPARTYORGID = StringUtil.null2Str(xls.get("APPLICANTPARTYORGID")); // 판매자신고인부호
			String EOCPARTYPARTYIDID2 = StringUtil.null2Str(xls.get("EOCPARTYPARTYIDID2"));   // 판매자통관고유부호
			String EOCPARTYLOCID = StringUtil.null2Str(xls.get("EOCPARTYLOCID"));             // 판매자우편번호
			String EOCPARTYADDRLINE = StringUtil.null2Str(xls.get("EOCPARTYADDRLINE"));       // 판매자주소
			*/
			String ORDER_ID = StringUtil.null2Str(xls.get("ORDER_ID"));
			String MALL_ITEM_NO = StringUtil.null2Str(xls.get("MALL_ITEM_NO"));
			String ITEMNAME_EN = StringUtil.null2Str(xls.get("ITEMNAME_EN"));
			String LINEITEMQUANTITY = StringUtil.null2Str(xls.get("LINEITEMQUANTITY"));		//주문수량
			String PAYMENTAMOUNT = StringUtil.null2Str(xls.get("PAYMENTAMOUNT"));
			String PAYMENTAMOUNT_CUR = StringUtil.null2Str(xls.get("PAYMENTAMOUNT_CUR"));
			String BUYERPARTYORGNAME = StringUtil.null2Str(xls.get("BUYERPARTYORGNAME"));
			String DESTINATIONCOUNTRYCODE = StringUtil.null2Str(xls.get("DESTINATIONCOUNTRYCODE"));
			String CLASSIDHSID = StringUtil.null2Str(xls.get("CLASSIDHSID"));
			String NETWEIGHTMEASURE = StringUtil.null2Str(xls.get("NETWEIGHTMEASURE"));		// 중량
			String DECLARATIONAMOUNT = StringUtil.null2Str(xls.get("DECLARATIONAMOUNT"));	// 단가
			String SELL_MALL_DOMAIN = StringUtil.null2Str(xls.get("SELL_MALL_DOMAIN"));		// 도메인명
			
			String makerNm = StringUtil.null2Str(xls.get("MAKER_NM"));
			String makerRegId = StringUtil.null2Str(xls.get("MAKER_REG_ID"));
			String makerLocSeq = StringUtil.null2Str(xls.get("MAKER_LOC_SEQ"));
			String makerOrgId = StringUtil.null2Str(xls.get("MAKER_ORG_ID"));
			String makePostCd = StringUtil.null2Str(xls.get("MAKER_POST_CD"));
			String makerLocCd = StringUtil.null2Str(xls.get("MAKER_LOC_CD"));
			
			String amtCod = StringUtil.null2Str(xls.get("AMT_COD"));
			String freKrw = StringUtil.null2Str(xls.get("FRE_KRW"));
			String insuKrw = StringUtil.null2Str(xls.get("INSU_KRW"));
			String comp = StringUtil.null2Str(xls.get("COMP"));
			String LINEITEMQUANTITY_UC = StringUtil.null2Str(xls.get("LINEITEMQUANTITY_UC"));
			
			/* 몰관리자 통합에 따른 판매자정보 주석처리
			String sellerUserId = null;
			Map<String, String> param = new HashMap<String, String>();
			if (EOCPARTYPARTYIDID1 != null) {
				EOCPARTYPARTYIDID1 = EOCPARTYPARTYIDID1.trim().replaceAll("-", "");
			}
			param.put("BIZ_NO", EOCPARTYPARTYIDID1);

			try {
				if (ExpDecReqValidator.isValidRegistNo(EOCPARTYPARTYIDID1, "사업자 번호", true)) {
					// 판매자 사업자번호 기준으로 CMM_USER 테이블에서 셀러 정보를 조회
					sellerUserId = (String)commonDAO.select("upl.selectCmmUserId", param);
				}
			} catch (Exception e) {
				addErrorInfo(rowErrorList, "EOCPARTYPARTYIDID1", EOCPARTYPARTYIDID1, e.getMessage());
			}
			
			// 가입되어 있는 셀러인 경우는 오류 판매자 정보 오류 체크하지 않음, 수출신고문서 생성 시에 해당 셀러의 기초정보 사용하면 되므로
			// 가입되어 있는 셀러가 아닌 경우 판매자 정보 오류 체크한다.
			if (sellerUserId == null) {
				try {
					ExpDecReqValidator.isValidCompanyName(EOCPARTYORGNAME2, "판매업체 명", true);
				} catch (Exception e) {
					addErrorInfo(rowErrorList, "EOCPARTYORGNAME2", EOCPARTYORGNAME2, e.getMessage());
				}
				try {
					ExpDecReqValidator.isValidCeoName(EOCPARTYORGCEONAME, "대표자 명", true);
				} catch (Exception e) {
					addErrorInfo(rowErrorList, "EOCPARTYORGCEONAME", EOCPARTYORGCEONAME, e.getMessage());
				}
				try {
					ExpDecReqValidator.isValidDeclarationId(APPLICANTPARTYORGID, "신고인 부호", true);
				} catch (Exception e) {
					addErrorInfo(rowErrorList, "APPLICANTPARTYORGID", APPLICANTPARTYORGID, e.getMessage());
				}
				try {
					ExpDecReqValidator.isValidCustomsId(EOCPARTYPARTYIDID2, "통관고유부호", true);
				} catch (Exception e) {
					addErrorInfo(rowErrorList, "EOCPARTYPARTYIDID2", EOCPARTYPARTYIDID2, e.getMessage());
				}
				try {
					ExpDecReqValidator.isValidZipCode(EOCPARTYLOCID, "우편번호", true);
				} catch (Exception e) {
					addErrorInfo(rowErrorList, "EOCPARTYLOCID", EOCPARTYLOCID, e.getMessage());
				}
				try {
					ExpDecReqValidator.isValidAddress(EOCPARTYADDRLINE, "주소", true);
				} catch (Exception e) {
					addErrorInfo(rowErrorList, "EOCPARTYADDRLINE", EOCPARTYADDRLINE, e.getMessage());
				}

				if (rowErrorList.size() > 0) {
					bErr = true;
				}

				// 판매자 정보에 오류가 없고 이전 행에서 처리하지 않았으면 CMM_USER 테이블에 인서트 또는 업데이트 처리한다.
				if (!bErr && EOCPARTYPARTYIDID1 != null) {
					param.put("SELLER_NM"    , EOCPARTYORGNAME2);    // 판매자상호
					param.put("REP_NM"      , EOCPARTYORGCEONAME);  // 판매자대표자명
					param.put("APPLICANT_ID" , APPLICANTPARTYORGID); // 판매자신고인부호
					param.put("TG_NO"        , EOCPARTYPARTYIDID2);  // 판매자통관고유부호
					param.put("ZIP_CD"      , EOCPARTYLOCID);       // 판매자우편번호
					param.put("ADDRESS"      , EOCPARTYADDRLINE);    // 판매자주소
					param.put("USER_ID"      , usrSession.getUserId());
					
					commonDAO.insert("upl.insertOrUpdateCmmUser", param);
				}
			}
			*/
			try {
				ExpDecReqValidator.isValidOrderNo(ORDER_ID, "주문번호", true);

				Map<String, Object> dupParam = new HashMap<String, Object>();
				dupParam.put("ORDER_ID" , ORDER_ID);
				dupParam.put("MALL_ID"  , usrSession.getUserId());
				
				Map<String, Object> orderInfo = (Map<String, Object>)commonDAO.select("upl.selectExpDecOrderId", dupParam);
				
				
		        if(MapUtils.isNotEmpty(orderInfo)){
		        	String regDtm = "";
		        	String rptNo = "";
		        	if( StringUtils.isNotEmpty ((String)(orderInfo.get("REG_DTM"))) ){
		        		regDtm = (String) orderInfo.get("REG_DTM");
		        	}
		        	
		        	if( StringUtils.isNotEmpty((String)(orderInfo.get("RPT_NO"))) ){
		        		rptNo = (String) orderInfo.get("RPT_NO");
		        	}
		        	
					throw new BizException("동일한 주문번호로 수출신고요청 건이 이미 존재합니다. 주문번호[" + ORDER_ID + "], 등록일시[" + regDtm + "], 신고번호[" + rptNo + "]" );
		        }
				
	        	
			} catch (Exception e) {
				addErrorInfo(rowErrorList, "ORDER_ID", ORDER_ID, e.getMessage());
			}
			try {
				ExpDecReqValidator.isValidItemNo(MALL_ITEM_NO, "상품ID", true);
			} catch (Exception e) {
				addErrorInfo(rowErrorList, "MALL_ITEM_NO", MALL_ITEM_NO, e.getMessage());
			}
			try {
				ExpDecReqValidator.isValidGoodsDesc(ITEMNAME_EN, "상품명", true);
			} catch (Exception e) {
				addErrorInfo(rowErrorList, "ITEMNAME_EN", ITEMNAME_EN, e.getMessage());
			}
			try {
				ExpDecReqValidator.isValidQuantity(LINEITEMQUANTITY, "주문수량", true);
			} catch (Exception e) {
				addErrorInfo(rowErrorList, "LINEITEMQUANTITY", LINEITEMQUANTITY, e.getMessage());
			}
			try {
				commonValidator.isValidCurrencyCode(PAYMENTAMOUNT_CUR, "결제통화코드", true);
			} catch (Exception e) {
				addErrorInfo(rowErrorList, "PAYMENTAMOUNT_CUR", PAYMENTAMOUNT_CUR, e.getMessage());
			}
			try {
				ExpDecReqValidator.isValidPaymentAmount(PAYMENTAMOUNT, PAYMENTAMOUNT_CUR, "결제금액", true);	//기본 데이터 타입체크
			} catch (Exception e) {
				addErrorInfo(rowErrorList, "PAYMENTAMOUNT", PAYMENTAMOUNT, e.getMessage());
			}
			try {
				commonValidator.isValidPaymentAmount(PAYMENTAMOUNT, PAYMENTAMOUNT_CUR, "결제금액", true);	//결제금액 액수체크
			} catch (Exception e) {
				addErrorInfo(rowErrorList, "PAYMENTAMOUNT", PAYMENTAMOUNT, e.getMessage());
			}
			try {
				ExpDecReqValidator.isValidBuyerPartyEngName(BUYERPARTYORGNAME, "구매자상호명", true);
			} catch (Exception e) {
				addErrorInfo(rowErrorList, "BUYERPARTYORGNAME", BUYERPARTYORGNAME, e.getMessage());
			}
			try {
				commonValidator.isValidCountryCode(DESTINATIONCOUNTRYCODE, "목적국 국가코드", true);
			} catch (Exception e) {
				addErrorInfo(rowErrorList, "DESTINATIONCOUNTRYCODE", DESTINATIONCOUNTRYCODE, e.getMessage());
			}
			try {
				commonValidator.isValidHsCode(CLASSIDHSID, "HS코드", false);
				
			} catch (Exception e) {
				addErrorInfo(rowErrorList, "CLASSIDHSID", CLASSIDHSID, e.getMessage());
			}
			try {
				ExpDecReqValidator.isValidWeight(NETWEIGHTMEASURE, "중량", false);
			} catch (Exception e) {
				addErrorInfo(rowErrorList, "NETWEIGHTMEASURE", NETWEIGHTMEASURE, e.getMessage());
			}
			try {
				ExpDecReqValidator.isValidPrice(DECLARATIONAMOUNT, "가격", true);
			} catch (Exception e) {
				addErrorInfo(rowErrorList, "DECLARATIONAMOUNT", DECLARATIONAMOUNT, e.getMessage());
			}
			try {
				ExpDecReqValidator.isValidSellMallDomain(SELL_MALL_DOMAIN, "도메인명", false);
			} catch (Exception e) {
				addErrorInfo(rowErrorList, "SELL_MALL_DOMAIN", SELL_MALL_DOMAIN, e.getMessage());
			}

			// 제조자 정보 검증
			try {
				ExpDecReqValidator.isValidCompanyName(makerNm, "제조자", false);
			} catch (Exception e) {
				addErrorInfo(rowErrorList, "MAKER_NM", makerNm, e.getMessage());
			}
			try {
				ExpDecReqValidator.isValidRegistNo(makerRegId, "제조자사업자번호", false);
			} catch (Exception e) {
				addErrorInfo(rowErrorList, "MAKER_REG_ID", makerRegId, e.getMessage());
			}
			try {
				ExpDecReqValidator.isValidCustomsId(makerOrgId, "제조자통관고유부호", false);
			} catch (Exception e) {
				addErrorInfo(rowErrorList, "MAKER_ORG_ID", makerOrgId, e.getMessage());
			}
			try {
				ExpDecReqValidator.isValidZipCode(makePostCd, "제조장소(우편번호)", false);
			} catch (Exception e) {
				addErrorInfo(rowErrorList, "MAKER_POST_CD", makePostCd, e.getMessage());
			}
			try {
				ExpDecReqValidator.isMakeLocationCode(makerLocCd, "산업단지부호", false);
			} catch (Exception e) {
				addErrorInfo(rowErrorList, "MAKER_LOC_CD", makerLocCd, e.getMessage());
			}
			try {
				ExpDecReqValidator.isMakeLocationSequence(makerLocSeq, "제조자사업장일련번호", false);
			} catch (Exception e) {
				addErrorInfo(rowErrorList, "MAKER_LOC_SEQ", makerLocSeq, e.getMessage());
			}
			try {
				commonValidator.isValidAmtCod(amtCod, "인도조건", false);
			} catch (Exception e) {
				addErrorInfo(rowErrorList, "AMT_COD", amtCod, e.getMessage());
			}
			try {
				ExpDecReqValidator.isValidFreKrw(freKrw, "운임금액", false);
			} catch (Exception e) {
				addErrorInfo(rowErrorList, "FRE_KRW", freKrw, e.getMessage());
			}
			try {
				ExpDecReqValidator.isValidInsuKrw(insuKrw, "보험금액", false);
			} catch (Exception e) {
				addErrorInfo(rowErrorList, "INSU_KRW", insuKrw, e.getMessage());
			}
			try {
				ExpDecReqValidator.isValidComp(comp, "상품성분명", false);
			} catch (Exception e) {
				addErrorInfo(rowErrorList, "COMP", comp, e.getMessage());
			}
			try {
				commonValidator.isValidQuantityUnitCode(LINEITEMQUANTITY_UC, "주문수량단위", false);
			} catch (Exception e) {
				addErrorInfo(rowErrorList, "LINEITEMQUANTITY_UC", LINEITEMQUANTITY_UC, e.getMessage());
			}
			
			try {
				ExpDecReqValidator.isValidAmtCodInsuFre(amtCod, freKrw, insuKrw, "인도조건별 금액체크");
			} catch (Exception e) {
				addErrorInfo(rowErrorList, "AMT_COD", amtCod, e.getMessage());
			}
			//동일한 주문 번호의 합계(주문수량 * 가격) 와 결제금액 체크
			try {
				ExpDecReqValidator.checkDataByOrderNoAmt(xlsList, compareIndex);
			} catch (Exception e) {
				addErrorInfo(rowErrorList, "PAYMENTAMOUNT", PAYMENTAMOUNT, e.getMessage());
			}
			
			if (rowErrorList.size() > 0) {
				bErr = true;
			}

			// 동일 주문번호인 경우 결제금액, 구매자상호명, 목적국 국가코드 체크, 제조자 정보 추가
			try {
				ExpDecReqValidator.checkDataByOrderNo(xlsList, compareIndex);
			} catch (Exception e) {
				e.printStackTrace();
				bErr = true;

				try {
					String msg = e.getMessage();
					String[] msges = msg.split("\\{\\|\\}");
					String errorColumnNamesStr = msges[0];
					String errorColumnDataStr = msges[1];
					String errorMessagesStr = msges[2];

					String[] errorColumnNames = errorColumnNamesStr.split("\\{/\\}");
					String[] errorColumnData = errorColumnDataStr.split("\\{/\\}");
					String[] errorMessages = errorMessagesStr.split("\\{/\\}");
					for (int idx = 0; idx < errorColumnNames.length; idx++) {
						addErrorInfo(rowErrorList, errorColumnNames[idx], errorColumnData[idx], errorMessages[idx]);
					}
				} catch (Exception ex) {
					ex.printStackTrace();
				}
			}

			// 제조자 정보 체크
			try {
				ExpDecReqValidator.checkMaker(makerNm, makerRegId, makerOrgId, makePostCd, makerLocCd, makerLocSeq);
			} catch (Exception e) {
				bErr = true;

				try {
					String msg = e.getMessage();
					String[] msges = msg.split("\\{\\|\\}");
					String errorColumnNamesStr = msges[0];
					String errorColumnDataStr = msges[1];
					String errorMessagesStr = msges[2];

					String[] errorColumnNames = errorColumnNamesStr.split("\\{/\\}");
					String[] errorColumnData = errorColumnDataStr.split("\\{/\\}");
					String[] errorMessages = errorMessagesStr.split("\\{/\\}");
					for (int idx = 0; idx < errorColumnNames.length; idx++) {
						addErrorInfo(rowErrorList, errorColumnNames[idx], errorColumnData[idx], errorMessages[idx]);
					}
				} catch (Exception ex) {
					ex.printStackTrace();
				}
			}
			
			
			if (rowErrorList.size() > 0) {
                bErr = true;
            }

            if (bErr) {
                Map<String, Object> chkDaoParam = new HashMap<String, Object>();
                chkDaoParam.put("SN", xls.get("SN"));
                chkDaoParam.put("SEQ", xls.get("SEQ"));
                chkDaoParam.put("STATUS", "E");
                String sStatusDesc = "";
                for (Map<String, Object> errorInfo : rowErrorList) {
                    sStatusDesc += errorInfo.get("ERROR_COLUMN_NAME");
                    sStatusDesc += "/";
                }
                if (sStatusDesc.endsWith("/")) {
                    sStatusDesc = sStatusDesc.substring(0, sStatusDesc.length() - 1); // 마지막 "/" 제거
                }
                chkDaoParam.put("STATUS_DESC", sStatusDesc);

                // Validation 오류컬럼 업데이트
                commonDAO.update("upl.updateExpregExcelErrCheck", chkDaoParam);

                Map<String, Object> errMsgMap = null;
                for (Map<String, Object> errorInfo : rowErrorList) {
                    errMsgMap = new HashMap<String, Object>(errorInfo);
                    errMsgMap.put("SN", chkDaoParam.get("SN"));
                    errMsgMap.put("SEQ", chkDaoParam.get("SEQ"));
                    
                    try {
                        commonDAO.insert("upl.insertExpregExcelErrmsg", errMsgMap);
                    } catch (Exception e) {
                        if (e instanceof SQLException) {
                            // dup.은 무시
                            if (((SQLException) e).getErrorCode() != 1) {
                                throw e;
                            }
                        }
                    }
                }
            }
            compareIndex++;
        }//end of for
    }
	
}
