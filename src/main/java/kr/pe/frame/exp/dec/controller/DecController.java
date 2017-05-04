package kr.pe.frame.exp.dec.controller;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import kr.pe.frame.cmm.core.base.BizException;
import kr.pe.frame.cmm.core.model.AjaxModel;
import kr.pe.frame.cmm.core.service.CommonService;
import kr.pe.frame.exp.dec.service.DecService;

import org.apache.commons.io.IOUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Created by jjkhj on 2017-01-09.
 */
@Controller
public class DecController {
    Logger logger = LoggerFactory.getLogger(this.getClass());

    @Resource(name = "decService")
    DecService decService;
    
    @Resource(name = "commonService")
    CommonService commonService;
    
    /**
     * 수출신고조회 전송
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/dec/saveExpDecSend")
    @ResponseBody
    public AjaxModel saveExpDecSend(AjaxModel model) throws Exception {
        return decService.saveExpDecSend(model);
    }
    
    
    /**
     * 수출신고 요청
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/dec/saveExpDecReq")
    @ResponseBody
    public AjaxModel saveExpDecReq(AjaxModel model) throws Exception {
        return decService.saveExpDecReq(model);
    }
    
    /**
     * 수출신고 정정
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/dec/saveExpDecMod")
    @ResponseBody
    public AjaxModel saveExpDecMod(AjaxModel model) throws Exception {
        return decService.saveExpDecMod(model);
    }
    
    /**
     * 수출신고 취하
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/dec/saveExpDecCancel")
    @ResponseBody
    public AjaxModel saveExpDecCancel(AjaxModel model) throws Exception {
        return decService.saveExpDecCancel(model);
    }
    
    /**
     * 수출신고 기간연장
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/dec/saveExpDecTerm")
    @ResponseBody
    public AjaxModel saveExpDecTerm(AjaxModel model) throws Exception {
        return decService.saveExpDecTerm(model);
    }
    
    /**
     * 수출신고 수정
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/dec/saveExpDecAll")
    @ResponseBody
    public AjaxModel saveExpDecAll(AjaxModel model) throws Exception {
        return decService.saveExpDecAll(model);
    }
    
    /**
     * 수출정정취하신고 수정
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/dec/saveModExpDecAll")
    @ResponseBody
    public AjaxModel saveModExpDecAll(AjaxModel model) throws Exception {
        return decService.saveModExpDecAll(model);
    }
    
    /**
     * 수출정정취하신고 정정내역생성
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/dec/saveModExpDecDtl")
    @ResponseBody
    public AjaxModel saveModExpDecDtl(AjaxModel model) throws Exception {
        return decService.saveModExpDecDtl(model);
    }
    
    @RequestMapping("/dec/downloadExpReq")
    public void downloadExpReq(@RequestParam("REQ_NO") String reqNo, HttpServletResponse response) throws Exception {
        try(ServletOutputStream out = response.getOutputStream();){
        	try {
				AjaxModel rst = decService.downloadExpReq(reqNo);
				
				response.setContentType("application/octet-stream");
				response.setHeader("Accept-Ranges", "bytes");
				response.setHeader("Content-Disposition", "attachment;filename=EXPREQ" + URLEncoder.encode(reqNo + ".txt", StandardCharsets.UTF_8.toString())+";");
				
				IOUtils.write(rst.getMsg(), out, "MS949");
        	} catch(BizException e) {
        		IOUtils.write("<script>alert('" + e.getModel().getMsg() + "');</script>", response.getOutputStream());
        	} catch(Exception e){
        		logger.error("{}", e);
        		String errorMsg = commonService.getMessage("E00000003");
        		IOUtils.write("<script>alert('" + errorMsg + "');</script>", response.getOutputStream());
            } finally {
            	out.flush();
        	}
		} 
    }
    
    @RequestMapping("/dec/downloadExpReqInZip")
    public void downloadImpReq(@RequestParam("REQ_NOS[]") String[] reqNos, HttpServletResponse response) throws Exception {
        try(ServletOutputStream out = response.getOutputStream();){
        	try {
        		AjaxModel[] rsts = new AjaxModel[reqNos.length];
        		int idx = 0;
        		for(String reqNo : reqNos) {
        			rsts[idx++] = decService.downloadExpReq(reqNo);
        		}
        		
				response.setContentType("application/octet-stream");
				response.setHeader("Accept-Ranges", "bytes");
				response.setHeader("Content-Disposition", "attachment;filename=EXPREQ.zip;");
	
        		ZipOutputStream zos = new ZipOutputStream(out);
        		idx = 0;
        		for(String reqNo : reqNos) {
        			ZipEntry ze= new ZipEntry("EXPREQ" + reqNo + "txt");
            		zos.putNextEntry(ze);
            		
            		IOUtils.write(rsts[idx++].getMsg(), zos, "MS949");
            		zos.closeEntry();
        		}
        		
        		zos.close();
        	} catch(BizException e) {
        		IOUtils.write("<script>alert('" + e.getModel().getMsg() + "');</script>", response.getOutputStream());
        	} catch(Exception e){
        		logger.error("{}", e);
        		String errorMsg = commonService.getMessage("E00000003");
        		IOUtils.write("<script>alert('" + errorMsg + "');</script>", response.getOutputStream());
            } finally {
            	out.flush();
        	}
		} 
    }    
    
	/**
	 * 수출수리정보 파일 업로드
	 * @param model
	 * @return
	 */
    @RequestMapping("/dec/uploadResFile")
    @ResponseBody
    public AjaxModel uploadResFile(HttpServletRequest request) throws Exception {
        return decService.uploadResFile(request);
    }
    
    /**
     * 수출이행내역 조회
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/dec/selectRunHis")
    @ResponseBody
    public AjaxModel selectRunHis(AjaxModel model) throws Exception {
        return decService.selectRunHis(model);
    }
}
