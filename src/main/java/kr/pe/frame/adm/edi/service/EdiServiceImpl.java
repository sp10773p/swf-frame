package kr.pe.frame.adm.edi.service;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.pe.frame.cmm.core.base.CommonDAO;
import kr.pe.frame.cmm.util.DocUtil;
import org.apache.commons.lang.exception.ExceptionUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import kr.pe.frame.cmm.core.base.BizException;
import kr.pe.frame.cmm.core.model.AjaxModel;
import kr.pe.frame.cmm.core.service.CommonService;

/**
 * 송수신이력 처리 Service<br/><br/>
 * 
 * 전문번호 체번 규칙 : 문서코드9자리 + 년월일(YYYYMMDD) + 시퀀스 4자리
 * 재처리 시 처리횟수 증가 이력테이블에 최종 상태 UPDATE(Admin) / 재처리 여부는 동일 DOC_ID 존재로 판단
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
@Service("ediService")
@SuppressWarnings({"rawtypes", "unchecked"})
public class EdiServiceImpl implements EdiService {
    Logger logger = LoggerFactory.getLogger(this.getClass());

    @Resource(name = "commonDAO")
    private CommonDAO dao;

    @Resource(name = "commonService")
    private CommonService commonService;
    
	@Override
	public AjaxModel selectSendRecvList(AjaxModel model) {
		return commonService.selectGridPagingList(model);
	}

	@Override
	public AjaxModel selectSendRecv(AjaxModel model) throws Exception {
		AjaxModel rtn = commonService.select(model);
		
		Map<String, Object> item = rtn.getData();
		if(!StringUtils.isEmpty(item.get("FILE_PATH")) && !StringUtils.isEmpty(item.get("FILE_NM"))) {
			String xml = "";
			Path sourcePath = Paths.get((String)item.get("FILE_PATH") + File.separatorChar  + item.get("FILE_NM"));
			
			try { 
				xml = DocUtil.xmlPrettyPrint(new String(Files.readAllBytes(sourcePath), "UTF-8"));
			} catch(Exception e) {
				xml = ExceptionUtils.getStackTrace(e);
			}
			
			item.put("XML_CONTENT", xml);
		}
		
		return rtn;
	}

	@Override
	public AjaxModel docReRecv(AjaxModel model) throws Exception {
		List<Map<String, Object>> rows = model.getDataList();
		for(Map item : rows) {
			dao.insert("edi.docReRecv", item);
			dao.update("edi.updateEdiHis", item);
		}
		
        model.setCode("I00000018"); // 재전송(수신) 처리 요청되었습니다.

        return model;
	}

	@Override
	public AjaxModel selectSendRecvEvtList(AjaxModel model) {
		return commonService.selectGridPagingList(model);
	}
	
	@Override
	public AjaxModel sendDoc(AjaxModel reqs) throws BizException {
		List<Map<String, Object>> rows = reqs.getDataList();
		for(Map item : rows) {
			item.put("CLASS_ID", "DOC_TYPE");
			item.put("CODE", item.get("DOC_TYPE"));
			if(dao.select("common.selectCommCode", item) == null) {
				throw new BizException("존재하지 않는 문서 코드 입니다.(" + item.get("DOC_TYPE") + ")");
			}
			
			dao.insert("edi.docSend", item);
		}
		
		reqs.setCode("I00000014"); // 전송 요청되었습니다.

        return reqs;
	}
}
