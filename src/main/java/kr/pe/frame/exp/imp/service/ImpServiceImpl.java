package kr.pe.frame.exp.imp.service;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;

import kr.pe.frame.adm.sys.model.UsrSessionModel;
import kr.pe.frame.cmm.core.base.BizException;
import kr.pe.frame.cmm.core.base.CommonDAO;
import kr.pe.frame.cmm.core.base.Constant;
import kr.pe.frame.cmm.core.model.AjaxModel;
import kr.pe.frame.cmm.core.service.CommonService;
import kr.pe.frame.cmm.core.service.FileCommonService;
import kr.pe.frame.cmm.util.DocUtil;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFPalette;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.util.CellRangeAddress;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

/**
 * 반품수입 처리 Service
 * @author jinhokim
 * @since 2017. 3. 14. 
 * @version 1.0
 *
 * <pre>
 * == 개정이력(Modification Information) ==
 *
 * 수정일      수정자  수정내용
 * ----------- ------- ---------------------------
 * 2017. 3. 14.    jinhokim  최초 생성
 *
 * </pre>
 */
@Service("impService")
@SuppressWarnings({"rawtypes", "unchecked"})
public class ImpServiceImpl implements ImpService {
    Logger logger = LoggerFactory.getLogger(this.getClass());
    
    @Resource(name = "commonDAO")
    private CommonDAO dao;

    @Resource(name = "commonService")
    private CommonService commonService;

    @Resource(name = "fileCommonService")
    private FileCommonService fileCommonService;
    
	@Override
	public AjaxModel selectImpReqList(AjaxModel model) {
		return commonService.selectGridPagingList(model);
	}

	@Override
	public AjaxModel selectImpReq(AjaxModel model) {
		return commonService.select(model);
	}
	
	@Override
	public AjaxModel deleteImpReqs(AjaxModel model) throws Exception {
		List<Map<String, Object>> rows = model.getDataList();
		List<String> fileIds = new ArrayList<String>();
		for(Map item : rows) {
			int delCnt = dao.delete("imp.deleteImpReq", item);
			if(!StringUtils.isEmpty((String) item.get("ATCH_FILE_ID"))) {
				fileIds.add((String) item.get("ATCH_FILE_ID"));
			}
				
			AjaxModel itemModel = new AjaxModel();
			if(delCnt == 0) {
				item.put("qKey", "imp.selectImpReq");
				item.put("STATUS", "RR");
				itemModel.setData(item);
				AjaxModel rst  = commonService.select(itemModel);
				
				if(rst.getData() != null) {
					model.setCode("W00000041"); // 삭제요청건중에 수리건이 있습니다.
					throw new BizException(model);
				}
			}
			dao.delete("imp.deleteImpReqItem", item);
		}
		
		fileCommonService.deleteAttachFileId(fileIds);

        return model;
	}
    
	@Override
	public AjaxModel selectImpReqItemList(AjaxModel model) {
		return commonService.selectGridPagingList(model);
	}

	@Override
	public AjaxModel deleteImpReqItems(AjaxModel model) throws Exception {
		List<Map<String, Object>> rows = model.getDataList();
		for(Map item : rows) {
			@SuppressWarnings("unused")
			int delCnt = dao.delete("imp.deleteImpReqItem", item);
		}

        return model;
	}

	@Override
	public AjaxModel createImpReqItems(AjaxModel model) throws Exception {
		List<Map<String, Object>> rows = model.getDataList();
		for(Map item : rows) {
			@SuppressWarnings("unused")
			int insCnt = dao.insert("imp.insertImpReqItem", item);
		}

        return model;
	}

	@Override
	public AjaxModel saveImpReq(AjaxModel model) throws Exception {
		Map<String, Object> param = model.getData();
		
		AjaxModel itemModel = new AjaxModel();
		if(!StringUtils.isEmpty((String) param.get("REQ_NO"))) {	// 수정불가 체크
			param.put("qKey", "imp.selectImpReq");
			param.put("STATUS", "RR");
			
			itemModel.setData(param);
			
			AjaxModel rst  = commonService.select(itemModel);
			
			if(rst.getData() != null) {
				model.setMsg((String) param.get("ERR_MSG"));
				throw new BizException(model);
			}
			
			param.put("qKey", "imp.selectImpReqDupChk");
			itemModel.setData(param);
			
			if(commonService.select(itemModel).getData() != null) {
				model.setCode("W00000054"); // 이미 추가된 주문번호입니다.
				throw new BizException(model);
			}
			
			param.put("qKey", "imp.updateImpReq");
			itemModel.setData(param);

			commonService.update(model);
		} else {
			param.put("qKey", "imp.selectImpReqDupChk");
			itemModel.setData(param);
			
			if(commonService.select(itemModel).getData() != null) {
				model.setCode("W00000054"); // 이미 추가된 주문번호입니다.
				model.setMsg(commonService.getMessage(model.getCode()));	// OPEN API에서 사용하기 위해서 처리함
				throw new BizException(model);
			}
			Map<String, String> docId = commonService.createDocId("IMPREQ");
			param.put("REQ_NO", docId.get("DOCNM") + docId.get("RGSTTM") + StringUtils.leftPad(docId.get("SQN"), 4, "0"));
			
			param.put("qKey", "imp.insertImpReq");
			itemModel.setData(param);

			commonService.insert(model);
		}
		
		List modelItems = (List) param.get("MODEL_ITEMS");
		for(int i = 0; modelItems != null && i < modelItems.size(); i++) {
			Map item = (Map) modelItems.get(i);
			item.put("qKey", "imp.updateImpReqItem");
			itemModel.setData(item);
			
			commonService.insert(itemModel);
		}
		
        return model;
	}

	@Override
	public void saveImpReqApi(Map req) throws Exception {
		if(dao.select("imp.selectImpReqDupChk", req) != null) {
			throw new BizException(commonService.getMessage("W00000054"));
		}
		
		Map<String, String> docId = commonService.createDocId("IMPREQ");
		req.put("REQ_NO", docId.get("DOCNM") + docId.get("RGSTTM") + StringUtils.leftPad(docId.get("SQN"), 4, "0"));
		
		dao.insert("imp.insertImpReq", req);
		
		List<Map<String, Object>> rows = (List<Map<String, Object>>) req.get("ItemList");
		for(Map item : rows) {
			item.put("REQ_NO", req.get("REQ_NO"));
			int insCnt = dao.insert("imp.insertImpReqItem_Api", item);
			
			if(insCnt != 1) {
				throw new BizException(commonService.getMessage("W00000058", new String[]{(String) item.get("EXP_RPT_NO"), (String) item.get("EXP_RAN_NO"), (String) item.get("EXP_SIL")}));
			}
		}
	}
	
	@Override
	public AjaxModel sendImpReq(AjaxModel model) throws Exception {
		Map<String, Object> param = model.getData();
		
		param.put("qKey", "imp.selectImpReq");
		param.put("STATUS", "RR");
		model.setData(param);
		
		AjaxModel rst  = commonService.select(model);
		
		if(rst.getData() != null) {
			model.setMsg((String) param.get("ERR_MSG"));
			throw new BizException(model);
		}
		
        String title    = "goGlobal 의뢰관리번호[" + param.get("REQ_NO") + "]의 반품수입신고 의뢰합니다.";
        String vmName   = "req_impreq_mail.html";
        
        Map cus = (Map) dao.select("imp.selectCustoms", param.get("RPT_MARK"));
        commonService.sendSimpleEMail(DocUtil.decrypt(StringUtils.defaultIfEmpty((String) cus.get("EMAIL"), "")), title, vmName, param);
        
        model.setCode("I00000037");
        
        return model;
	}

    @Override
    public AjaxModel downloadImpReq(String reqNo) throws Exception {
    	Map mst = null;
    	
    	Map param = new HashMap();
    	param.put("REQ_NO", reqNo);
    	param.put("STATUS", "RR");
    	param.put("qKey", "imp.selectImpReq");
    	
    	AjaxModel model = new AjaxModel();
    	model.setData(param);
		
    	commonService.select(model);
    	
		if(model.getData() != null) {
			model.setMsg(commonService.getMessage("W00000045", "수출신고 의뢰파일다운로드"));
			throw new BizException(model);
		}
		
		param.clear();
    	param.put("REQ_NO", reqNo);
		param.put("qKey", "imp.selectImpReq");
		
    	model.setData(param);
    	
		commonService.select(model);
		mst = new HashMap(model.getData());
		
		List<Map<String, Object>> rans = new ArrayList();
		mst.put("RANS", rans);
    	
    	model.getData().put("qKey", "imp.selectImpReqRan");
    	rans = commonService.selectList(model).getDataList();
    	
		List<Map<String, Object>> ranItems = new ArrayList();
		mst.put("RAN_ITEMS", ranItems);
		
    	for(Map item : rans) {
    		param.clear();
    		param.putAll(item);
    		param.put("qKey", "imp.selectImpReqRanItem");
    		model.setData(param);
    		
    		ranItems.addAll(commonService.selectList(model).getDataList());
    	}
    	
		List<Map<String, Object>> ranExps = new ArrayList();
		mst.put("RAN_EXPS", ranExps);
		
    	for(Map item : rans) {
    		param.clear();
    		param.putAll(item);
    		param.put("qKey", "imp.selectImpReqRanExp");
    		model.setData(param);
    		
    		ranExps.addAll(commonService.selectList(model).getDataList());
    	}
    	
    	StringBuffer stBuffer = new StringBuffer();
    	
    	String ruleStr = CUSDEC929Rule.getRuleStr(CUSDEC929Rule.IHDR, CUSDEC929Rule.DOWN);
		
		if(ruleStr == null) {
			model.setMsg(commonService.getMessage("W00000047", "존재하지 않는 내역코드[IHDR]")); 
			throw new BizException(model);
		}
		
		String[] rule = ruleStr.split("\\^", -1);
		for(int i = 0; i < rule.length -1; i++) {
			String[] vA = rule[i].split("#", -1);

			if(StringUtils.isEmpty(vA[0])) {
				stBuffer.append(vA[1]).append("^");
			} else {
				if(mst.get(vA[0]) != null) {
					stBuffer.append(mst.get(vA[0]).toString()).append("^");
				} else {
					stBuffer.append(vA[1]).append("^");
				}
			}
		}
		
		stBuffer.append(System.getProperty("line.separator"));
    	
    	ruleStr = CUSDEC929Rule.getRuleStr(CUSDEC929Rule.IDTL, CUSDEC929Rule.DOWN);
		
		if(ruleStr == null) {
			model.setMsg(commonService.getMessage("W00000047", "존재하지 않는 내역코드[IDTL]")); 
			throw new BizException(model);
		}
		
		rule = ruleStr.split("\\^", -1);
		
    	for(Map item : rans) {
			for(int i = 0; i < rule.length -1; i++) {
				String[] vA = rule[i].split("#", -1);
	
				if(StringUtils.isEmpty(vA[0])) {
					stBuffer.append(vA[1]).append("^");
				} else {
					if(item.get(vA[0]) != null) {
						stBuffer.append(item.get(vA[0]).toString()).append("^");
					} else {
						stBuffer.append(vA[1]).append("^");
					}
				}
			}
			
			stBuffer.append(System.getProperty("line.separator"));
    	}
    	
    	ruleStr = CUSDEC929Rule.getRuleStr(CUSDEC929Rule.IMDL, CUSDEC929Rule.DOWN);
		
		if(ruleStr == null) {
			model.setMsg(commonService.getMessage("W00000047", "존재하지 않는 내역코드[IMDL]")); 
			throw new BizException(model);
		}
		
		rule = ruleStr.split("\\^", -1);
		
    	for(Map item : ranItems) {
			for(int i = 0; i < rule.length -1; i++) {
				String[] vA = rule[i].split("#", -1);
	
				if(StringUtils.isEmpty(vA[0])) {
					stBuffer.append(vA[1]).append("^");
				} else {
					if(item.get(vA[0]) != null) {
						stBuffer.append(item.get(vA[0]).toString()).append("^");
					} else {
						stBuffer.append(vA[1]).append("^");
					}
				}
			}
			
			stBuffer.append(System.getProperty("line.separator"));
    	}
    	
    	ruleStr = CUSDEC929Rule.getRuleStr(CUSDEC929Rule.IEXP, CUSDEC929Rule.DOWN);
		
		if(ruleStr == null) {
			model.setMsg(commonService.getMessage("W00000047", "존재하지 않는 내역코드[IEXP]")); 
			throw new BizException(model);
		}
		
		rule = ruleStr.split("\\^", -1);
		
    	for(Map item : ranExps) {
			for(int i = 0; i < rule.length -1; i++) {
				String[] vA = rule[i].split("#", -1);
	
				if(StringUtils.isEmpty(vA[0])) {
					stBuffer.append(vA[1]).append("^");
				} else {
					if(item.get(vA[0]) != null) {
						stBuffer.append(item.get(vA[0]).toString()).append("^");
					} else {
						stBuffer.append(vA[1]).append("^");
					}
				}
			}
			
			stBuffer.append(System.getProperty("line.separator"));
    	}
    	
		model.setMsg(stBuffer.toString());
		model.setData(mst);
		
		updateImpReqDownload(reqNo);
		
        return model;
    }

	private void updateImpReqDownload(String reqNo) throws Exception {
		dao.update("imp.updateImpReqDownload", reqNo);
	}	

	@Override
	public AjaxModel saveImpReqFile(AjaxModel model) throws Exception {
		model.getData().put("qKey", "imp.updateImpReqFileAttchId");

		commonService.update(model);
		
		return model;
	}	
    
	@Override
	public AjaxModel selectExpItemList(AjaxModel model) {
		return commonService.selectGridPagingList(model);
	}
	
    // 수입신고결과 조회    
	@Override
	public AjaxModel selectImpResList(AjaxModel model) {
		return commonService.selectGridPagingList(model);
	}
	
	@Override
	public AjaxModel selectImpResRanList(AjaxModel model) {
		return commonService.selectGridPagingList(model);
	}	
	
	@Override
	public AjaxModel selectImpResRanItemList(AjaxModel model) {
		return commonService.selectGridPagingList(model);
	}	

	@Override
	public AjaxModel selectImpRes(AjaxModel model) {
		return commonService.select(model);
	}

	@Override
	public AjaxModel uploadResFile(HttpServletRequest request) throws Exception {
		UsrSessionModel sessionModel = (UsrSessionModel) request.getSession(true).getAttribute(Constant.SESSION_KEY_USR.getCode());
		String applicationId = sessionModel.getApplicantId();
		
        MultipartHttpServletRequest multipartHttpServletRequest = (MultipartHttpServletRequest)request;
        Iterator<String> iterator = multipartHttpServletRequest.getFileNames();

        Map<String, Object> retMap = new HashMap<>();

        AjaxModel model = new AjaxModel();
        while(iterator.hasNext()){
            String fileName = iterator.next();
            if(multipartHttpServletRequest.getFile(fileName).isEmpty()){
                continue;
            }

            List<MultipartFile> fileList = multipartHttpServletRequest.getFiles(fileName);
            for(MultipartFile multipartFile : fileList){
                InputStream in = multipartFile.getInputStream();
                
                if(in != null) {
                	List<String> txts = null;
                	try{ 
                		txts = IOUtils.readLines(in, "MS949");
                	} finally {
                		IOUtils.closeQuietly(in);
                	}                		
                	
                	List<String[]> dataAll = new ArrayList<String[]>(); 
            		for(int i = 0; i < txts.size(); i++) {
            			String[] item = txts.get(i).split("\\^", -1);
            			String ruleStr = CUSDEC929Rule.getRuleStr(item[0], CUSDEC929Rule.UP);
            			
            			if(ruleStr == null) {
            				logger.debug(commonService.getMessage("W00000047", "존재하지 않는 내역코드[" + item[0] + "]"));
            				continue;
            			}
            			
            			dataAll.add(item);
            		}

            		boolean isExistIHDR = false;
            		boolean isExistIDTL = false;
            		boolean isExistIMDL = false;
            		
            		String prtNo = "";
            		for(String[] data :  dataAll) {
            			String ruleStr = CUSDEC929Rule.getRuleStr(data[0], CUSDEC929Rule.UP);
            			
            			String[] rule = ruleStr.split("\\^", -1);
            			if(rule.length != data.length) {	// 스펙 체크
            				model.setMsg(commonService.getMessage("W00000047", "룰파일[" + rule.length + "]과 데이터[" + data.length + "] 길이 불일치[" + data[0] + "]")); 
	    					throw new BizException(model);
            			}
            			
            			if(data[0].equals("IHDR")) isExistIHDR = true;
            			if(data[0].equals("IDTL")) isExistIDTL = true;
            			if(data[0].equals("IMDL")) isExistIMDL = true;
            			
            			if(prtNo.equals("")) {
            				prtNo = data[2];
            			}
            			
            			if(!prtNo.startsWith(applicationId) || !prtNo.equals(data[2])) {	// 신고번호 불일치
            				model.setMsg(commonService.getMessage("W00000047", "파일내 신고번호 불일치"));
	    					throw new BizException(model);
            			}
            		}
            		
            		if(!isExistIHDR || !isExistIDTL || !isExistIMDL) {	// 최소 1건의 항목이 존재 해야 함
            			model.setMsg(commonService.getMessage("W00000047", "필수 세그먼크 미존재"));
    					throw new BizException(model);
            		}

            		Map mst = new HashMap<String,Object>();
            		List<Map<String,String>> ran = new ArrayList();
            		mst.put("RAN", ran);
            		List<Map<String,String>> ranItem = new ArrayList();
            		mst.put("RAN_ITEM", ranItem);
            		for(String[] data :  dataAll) {
            			String[] rule = CUSDEC929Rule.getRuleStr(data[0], CUSDEC929Rule.UP).split("\\^", -1);
            			
            			if(data[0].equals("IHDR")) {	// 중복시 최종 데이터로 처리됨
                			for(int i = 1; i < rule.length; i++) {
                				String[] vA = rule[i].split("#", -1);

                				if(!StringUtils.isEmpty(vA[0])) {
                					mst.put(vA[0], data[i]);
                				}
                			}
            			} else {
            				Map item = new HashMap<String,String>();
            				if(data[0].equals("IDTL")) {
            					ran.add(item);
            				} else if(data[0].equals("IMDL")) {
            					ranItem.add(item);
            				}
                			for(int i = 1; i < rule.length; i++) {
                				String[] vA = rule[i].split("#", -1);

                				if(!StringUtils.isEmpty(vA[0])) {
                					item.put(vA[0], data[i]);
                				}
                			}
            			}
            		}
        		
        			dao.delete("imp.deleteImpResRanItem", mst);
        			dao.delete("imp.deleteImpResRan", mst);
        			dao.delete("imp.deleteImpRes", mst);
        			
        			dao.insert("imp.insertImpRes", mst);
        			for(Map item : ran) {
        				dao.insert("imp.insertImpResRan", item);
        			}
        			for(Map item : ranItem) {
        				dao.insert("imp.insertImpResRanItem", item);
        			}
                } 
            }
        }

        model.setCode("I00000017"); // 파일업로드 되었습니다.
        model.setData(retMap);

        return model;
	}
    
	@Override
	public AjaxModel selectImpKotraList(AjaxModel model) {
		return commonService.selectGridPagingList(model);
	}

	@Override
	@SuppressWarnings("resource")
	public void downloadImpKotra(List<String> regNos, ServletOutputStream out) throws Exception {
		HSSFWorkbook wb = new HSSFWorkbook();
		Sheet sheet = wb.createSheet("KOTRA WMS");
		HSSFPalette palette = wb.getCustomPalette();
		
		Font font = wb.createFont();
		font.setFontHeight((short) 280);
		font.setColor((short) 8);
		font.setBoldweight((short) 700);
		font.setCharSet(129);
		font.setFontName("맑은 고딕");
		CellStyle style = wb.createCellStyle();
		style.setFont(font);
		style.setAlignment(CellStyle.ALIGN_LEFT);
		style.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
		style.setWrapText(true);
		
        int rowIdx = 0;
    	int cIdx = 0;
		Row titlerow = sheet.createRow(rowIdx++);
		titlerow.setHeight((short) 1125);
    	createCellWithStyle(titlerow, cIdx, style).setCellValue("※ 반품센터 주문양식 ( 16년 11월 15일 Version )");
    	sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, 9));    	
    	
		font = wb.createFont();
		font.setFontHeight((short) 220);
		font.setColor((short) 8);
		font.setBoldweight((short) 700);
		font.setCharSet(129);
		font.setFontName("맑은 고딕");
		style = wb.createCellStyle();
		style.setFont(font);
		style.setAlignment(CellStyle.ALIGN_CENTER);
		style.setBorderTop(CellStyle.BORDER_THIN);		
		style.setBorderBottom(CellStyle.BORDER_THIN);
		style.setBorderLeft(CellStyle.BORDER_THIN);
		style.setBorderRight(CellStyle.BORDER_THIN);
		style.setFillForegroundColor(palette.findSimilarColor(255, 255, 0).getIndex());
		style.setFillPattern(CellStyle.SOLID_FOREGROUND);
		style.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
		style.setWrapText(true);
		
    	cIdx = 0;
    	
    	titlerow = sheet.createRow(rowIdx++);
    	titlerow.setHeight((short) 735);
    	createCellWithStyle(titlerow, cIdx++, style).setCellValue("필수 정보 값(화주 입력)");
    	createCellWithStyle(titlerow, cIdx++, style);
    	createCellWithStyle(titlerow, cIdx++, style);
    	createCellWithStyle(titlerow, cIdx++, style);
    	createCellWithStyle(titlerow, cIdx++, style);
    	createCellWithStyle(titlerow, cIdx++, style);
    	createCellWithStyle(titlerow, cIdx++, style);
    	createCellWithStyle(titlerow, cIdx++, style);
    	createCellWithStyle(titlerow, cIdx++, style);
    	createCellWithStyle(titlerow, cIdx++, style);
    	sheet.addMergedRegion(new CellRangeAddress(1, 2, 0, 9));    	
    	
		style = wb.createCellStyle();
		style.setFont(font);
		style.setAlignment(CellStyle.ALIGN_CENTER);
		style.setBorderTop(CellStyle.BORDER_THIN);		
		style.setBorderBottom(CellStyle.BORDER_THIN);
		style.setBorderLeft(CellStyle.BORDER_THIN);
		style.setBorderRight(CellStyle.BORDER_THIN);
		style.setFillForegroundColor(palette.findSimilarColor(220, 230, 241).getIndex());
		style.setFillPattern(CellStyle.SOLID_FOREGROUND);
		style.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
		style.setWrapText(true);
		
    	createCellWithStyle(titlerow, cIdx++, style).setCellValue("선택 값(화주 입력)");
    	createCellWithStyle(titlerow, cIdx++, style);
    	sheet.addMergedRegion(new CellRangeAddress(1, 2, 10, 11));    
    	
    	createCellWithStyle(titlerow, cIdx++, style).setCellValue("수출통관형태");
    	createCellWithStyle(titlerow, cIdx++, style);
    	createCellWithStyle(titlerow, cIdx++, style);
    	createCellWithStyle(titlerow, cIdx++, style);
    	sheet.addMergedRegion(new CellRangeAddress(1, 1, 12, 15));      
    	
		style = wb.createCellStyle();
		style.setFont(font);
		style.setAlignment(CellStyle.ALIGN_CENTER);
		style.setBorderTop(CellStyle.BORDER_THIN);		
		style.setBorderBottom(CellStyle.BORDER_THIN);
		style.setBorderLeft(CellStyle.BORDER_THIN);
		style.setBorderRight(CellStyle.BORDER_THIN);
		style.setFillForegroundColor(palette.findSimilarColor(217, 217, 217).getIndex());
		style.setFillPattern(CellStyle.SOLID_FOREGROUND);
		style.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
		style.setWrapText(true);
		
    	createCellWithStyle(titlerow, cIdx++, style).setCellValue("간이 수출 신고 DATA에서 취합 하는 부분");
    	createCellWithStyle(titlerow, cIdx++, style);
    	createCellWithStyle(titlerow, cIdx++, style);
    	createCellWithStyle(titlerow, cIdx++, style);
    	createCellWithStyle(titlerow, cIdx++, style);
    	createCellWithStyle(titlerow, cIdx++, style);
    	createCellWithStyle(titlerow, cIdx++, style);
    	createCellWithStyle(titlerow, cIdx++, style);
    	createCellWithStyle(titlerow, cIdx++, style);
    	createCellWithStyle(titlerow, cIdx++, style);
    	createCellWithStyle(titlerow, cIdx++, style);
    	createCellWithStyle(titlerow, cIdx++, style);
    	createCellWithStyle(titlerow, cIdx++, style);
    	createCellWithStyle(titlerow, cIdx++, style);
    	sheet.addMergedRegion(new CellRangeAddress(1, 1, 16, 29));        	
    	
		style = wb.createCellStyle();
		style.setFont(font);
		style.setAlignment(CellStyle.ALIGN_CENTER);
		style.setBorderTop(CellStyle.BORDER_THIN);		
		style.setBorderBottom(CellStyle.BORDER_THIN);
		style.setBorderLeft(CellStyle.BORDER_THIN);
		style.setBorderRight(CellStyle.BORDER_THIN);
		style.setFillForegroundColor(palette.findSimilarColor(220, 230, 241).getIndex());
		style.setFillPattern(CellStyle.SOLID_FOREGROUND);
		style.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
		style.setWrapText(true);
		
    	cIdx = 0;
    	titlerow = sheet.createRow(rowIdx++);
    	createCellWithStyle(titlerow, cIdx++, style);
    	createCellWithStyle(titlerow, cIdx++, style);
    	createCellWithStyle(titlerow, cIdx++, style);
    	createCellWithStyle(titlerow, cIdx++, style);
    	createCellWithStyle(titlerow, cIdx++, style);
    	createCellWithStyle(titlerow, cIdx++, style);
    	createCellWithStyle(titlerow, cIdx++, style);
    	createCellWithStyle(titlerow, cIdx++, style);
    	createCellWithStyle(titlerow, cIdx++, style);
    	createCellWithStyle(titlerow, cIdx++, style);
    	createCellWithStyle(titlerow, cIdx++, style);
    	createCellWithStyle(titlerow, cIdx++, style);
    	createCellWithStyle(titlerow, cIdx++, style).setCellValue("일반\n수출통관");
    	createCellWithStyle(titlerow, cIdx++, style).setCellValue("목록\n수출통관");
    	createCellWithStyle(titlerow, cIdx++, style).setCellValue("전자상거래\n간이수출통관");
    	createCellWithStyle(titlerow, cIdx++, style).setCellValue("EMS");
    	
		style = wb.createCellStyle();
		style.setFont(font);
		style.setAlignment(CellStyle.ALIGN_CENTER);
		style.setBorderTop(CellStyle.BORDER_THIN);		
		style.setBorderBottom(CellStyle.BORDER_THIN);
		style.setBorderLeft(CellStyle.BORDER_THIN);
		style.setBorderRight(CellStyle.BORDER_THIN);
		style.setFillForegroundColor(palette.findSimilarColor(217, 217, 217).getIndex());
		style.setFillPattern(CellStyle.SOLID_FOREGROUND);
		style.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
		style.setWrapText(true);
		
    	createCellWithStyle(titlerow, cIdx++, style).setCellValue("전체정보");
    	createCellWithStyle(titlerow, cIdx++, style);
    	createCellWithStyle(titlerow, cIdx++, style);
    	sheet.addMergedRegion(new CellRangeAddress(2, 2, 16, 18));       
    	
    	createCellWithStyle(titlerow, cIdx++, style).setCellValue("란 정보");
    	createCellWithStyle(titlerow, cIdx++, style);
    	createCellWithStyle(titlerow, cIdx++, style);
    	createCellWithStyle(titlerow, cIdx++, style);
    	createCellWithStyle(titlerow, cIdx++, style);
    	createCellWithStyle(titlerow, cIdx++, style);
    	createCellWithStyle(titlerow, cIdx++, style);
    	createCellWithStyle(titlerow, cIdx++, style);
    	createCellWithStyle(titlerow, cIdx++, style);
    	createCellWithStyle(titlerow, cIdx++, style);
    	createCellWithStyle(titlerow, cIdx++, style);
    	sheet.addMergedRegion(new CellRangeAddress(2, 2, 19, 29)); 
    	
		style = wb.createCellStyle();
		style.setFont(font);
		style.setAlignment(CellStyle.ALIGN_CENTER);
		style.setBorderTop(CellStyle.BORDER_THIN);		
		style.setBorderBottom(CellStyle.BORDER_THIN);
		style.setBorderLeft(CellStyle.BORDER_THIN);
		style.setBorderRight(CellStyle.BORDER_THIN);
		style.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
		style.setWrapText(true);
		
    	cIdx = 0;
    	
    	titlerow = sheet.createRow(rowIdx++);
    	createCellWithStyle(titlerow, cIdx++, style).setCellValue("주문번호");
    	createCellWithStyle(titlerow, cIdx++, style).setCellValue("서비스구분\n( S:해상, A:항공, R:재판매, D:폐기 )");
    	createCellWithStyle(titlerow, cIdx++, style).setCellValue("반품센터");
    	createCellWithStyle(titlerow, cIdx++, style).setCellValue("한국수출신고인");
    	createCellWithStyle(titlerow, cIdx++, style).setCellValue("화물 수출 운송장 No.");
    	createCellWithStyle(titlerow, cIdx++, style).setCellValue("송화인 (중국)이름 중문");
    	createCellWithStyle(titlerow, cIdx++, style).setCellValue("송화인(중국)주소 중문");
    	createCellWithStyle(titlerow, cIdx++, style).setCellValue("송화인(중국)연락처");
    	createCellWithStyle(titlerow, cIdx++, style).setCellValue("담당자\n(MD)");
    	createCellWithStyle(titlerow, cIdx++, style).setCellValue("상품명(중문)");
    	createCellWithStyle(titlerow, cIdx++, style).setCellValue("중국\n반품배송택배사");
    	createCellWithStyle(titlerow, cIdx++, style).setCellValue("중국\n반품배송송장번호");
    	createCellWithStyle(titlerow, cIdx++, style).setCellValue("");
    	createCellWithStyle(titlerow, cIdx++, style).setCellValue("");
    	createCellWithStyle(titlerow, cIdx++, style).setCellValue("□");
    	createCellWithStyle(titlerow, cIdx++, style).setCellValue("");
    	
    	createCellWithStyle(titlerow, cIdx++, style).setCellValue("수출자명");
    	createCellWithStyle(titlerow, cIdx++, style).setCellValue("수출신고번호\n(일괄 시 주문번호와 동일 란 추가)");
    	createCellWithStyle(titlerow, cIdx++, style).setCellValue("총금액,\n총 중량,\n총 박스수");
    	createCellWithStyle(titlerow, cIdx++, style).setCellValue("총 란수");
    	createCellWithStyle(titlerow, cIdx++, style).setCellValue("해당 란수");
    	createCellWithStyle(titlerow, cIdx++, style).setCellValue("해당  NO.");
    	createCellWithStyle(titlerow, cIdx++, style).setCellValue("상품명");
    	createCellWithStyle(titlerow, cIdx++, style).setCellValue("수출신고 품명");
    	createCellWithStyle(titlerow, cIdx++, style).setCellValue("브랜드명");
    	createCellWithStyle(titlerow, cIdx++, style).setCellValue("수량");
    	createCellWithStyle(titlerow, cIdx++, style).setCellValue("화폐단위");
    	createCellWithStyle(titlerow, cIdx++, style).setCellValue("단가");
    	createCellWithStyle(titlerow, cIdx++, style).setCellValue("금액");
    	createCellWithStyle(titlerow, cIdx++, style).setCellValue("HS CODE");
        
		font = wb.createFont();
		font.setFontHeight((short) 180);
		font.setColor((short) 8);
		font.setBoldweight((short) 500);
		font.setCharSet(129);
		font.setFontName("맑은 고딕");
		style = wb.createCellStyle();
		style.setFont(font);
		style.setAlignment(CellStyle.ALIGN_CENTER);
		style.setBorderTop(CellStyle.BORDER_THIN);		
		style.setBorderBottom(CellStyle.BORDER_THIN);
		style.setBorderLeft(CellStyle.BORDER_THIN);
		style.setBorderRight(CellStyle.BORDER_THIN);
		style.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
		style.setWrapText(true);
		
        List<Map> rst = dao.list("imp.selectImpKotraWms", regNos);
        for(Map item : rst) {
        	Row row = sheet.createRow(rowIdx++);
        	cIdx = 0;
        	
        	createCellWithStyle(row, cIdx++, style).setCellValue(item.get("ORDER_ID").toString());
        	createCellWithStyle(row, cIdx++, style).setCellValue(item.get("SERVICE_DIVI").toString());
        	createCellWithStyle(row, cIdx++, style).setCellValue(item.get("RETERN_NM").toString());
        	createCellWithStyle(row, cIdx++, style).setCellValue(item.get("EXP_RPT_NM").toString());
        	createCellWithStyle(row, cIdx++, style).setCellValue(item.get("EXP_WAYBILL_NO").toString());
        	createCellWithStyle(row, cIdx++, style).setCellValue(item.get("CONSIGNOR_NM").toString());
        	createCellWithStyle(row, cIdx++, style).setCellValue(item.get("CONSIGNOR_ADDR").toString());
        	createCellWithStyle(row, cIdx++, style).setCellValue(item.get("CONSIGNOR_TELNO").toString());
        	createCellWithStyle(row, cIdx++, style).setCellValue(item.get("MD_NM").toString());
        	createCellWithStyle(row, cIdx++, style).setCellValue(item.get("GOODS_NM").toString());
        	createCellWithStyle(row, cIdx++, style).setCellValue(item.get("DELIVERY_FIRM").toString());
        	createCellWithStyle(row, cIdx++, style).setCellValue(item.get("WAYBILL_NO").toString());
        	createCellWithStyle(row, cIdx++, style).setCellValue("");
        	createCellWithStyle(row, cIdx++, style).setCellValue("");
        	createCellWithStyle(row, cIdx++, style).setCellValue("□");
        	createCellWithStyle(row, cIdx++, style).setCellValue("");
        	createCellWithStyle(row, cIdx++, style).setCellValue(item.get("EXP_NM").toString());
        	createCellWithStyle(row, cIdx++, style).setCellValue(item.get("RPT_NO").toString());
        	createCellWithStyle(row, cIdx++, style).setCellValue(item.get("TOT_AMT").toString() + "\n" + item.get("TOT_WT").toString() + "\n" + item.get("TOT_PACK_CNT").toString());
        	createCellWithStyle(row, cIdx++, style).setCellValue(item.get("TOT_RAN").toString());
        	createCellWithStyle(row, cIdx++, style).setCellValue(item.get("RAN_NO").toString());
        	createCellWithStyle(row, cIdx++, style).setCellValue(item.get("SIL").toString());
        	createCellWithStyle(row, cIdx++, style).setCellValue(item.get("STD_GNM").toString());
        	createCellWithStyle(row, cIdx++, style).setCellValue(item.get("EXC_GNM").toString());
        	createCellWithStyle(row, cIdx++, style).setCellValue(item.get("MODEL_GNM").toString());
        	createCellWithStyle(row, cIdx++, style).setCellValue(item.get("QTY").toString());
        	createCellWithStyle(row, cIdx++, style).setCellValue(item.get("AMT_UT").toString());
        	createCellWithStyle(row, cIdx++, style).setCellValue(item.get("PRICE").toString());
        	createCellWithStyle(row, cIdx++, style).setCellValue(item.get("AMT").toString());
        	createCellWithStyle(row, cIdx++, style).setCellValue(item.get("HS").toString());
        }
        
        for(int i = 0; i < cIdx; i++) {
        	sheet.autoSizeColumn(i);
        }
        
        wb.write(out);
	}	
	
	private Cell createCellWithStyle(Row row, int idx, CellStyle style) {
		Cell cell = row.createCell(idx);
		cell.setCellStyle(style);
		
		return cell;
	}
	
	@Override
	public AjaxModel selectImpKotra(AjaxModel model) {
		return commonService.select(model);
	}
	
	@Override
	public AjaxModel deleteImpKotras(AjaxModel model) throws Exception {
		List<Map<String, Object>> rows = model.getDataList();
		for(Map item : rows) {
			dao.delete("imp.deleteImpKotraItem", item);
			@SuppressWarnings("unused")
			int delCnt = dao.delete("imp.deleteImpKotra", item);
		}

        return model;
	}	
    
	@Override
	public AjaxModel selectImpKotraItemList(AjaxModel model) {
		return commonService.selectGridPagingList(model);
	}

	@Override
	public AjaxModel deleteImpKotraItems(AjaxModel model) throws Exception {
		List<Map<String, Object>> rows = model.getDataList();
		for(Map item : rows) {
			@SuppressWarnings("unused")
			int delCnt = dao.delete("imp.deleteImpKotraItem", item);
		}

        return model;
	}

	@Override
	public AjaxModel createImpKotraItems(AjaxModel model) throws Exception {
		List<Map<String, Object>> rows = model.getDataList();
		for(Map item : rows) {
			@SuppressWarnings("unused")
			int insCnt = dao.insert("imp.insertImpKotraItem", item);
		}

        return model;
	}
	
	@Override
	public AjaxModel saveImpKotra(AjaxModel model) throws Exception {
		Map<String, Object> param = model.getData();
		
		AjaxModel itemModel = new AjaxModel();
		if(!StringUtils.isEmpty((String) param.get("REGNO"))) {	// 수정불가 체크
			param.put("qKey", "imp.updateImpKotra");
			itemModel.setData(param);

			commonService.update(model);
		} else {
			param.put("qKey", "imp.insertImpKotra");
			itemModel.setData(param);

			commonService.insert(model);
		}
		
        return model;
	}
}
