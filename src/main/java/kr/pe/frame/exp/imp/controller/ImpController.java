package kr.pe.frame.exp.imp.controller;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import javax.annotation.Resource;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.IOUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.pe.frame.cmm.core.base.BizException;
import kr.pe.frame.cmm.core.model.AjaxModel;
import kr.pe.frame.cmm.core.service.CommonService;
import kr.pe.frame.exp.imp.service.ImpService;

/**
 * 반품수입 처리 Controller
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
@Controller
@RequestMapping("/imp")
public class ImpController {
    Logger logger = LoggerFactory.getLogger(this.getClass());
    
    @Resource(name = "impService")
    ImpService impService;
    
    @Resource(name = "commonService")
    CommonService commonService;

    @RequestMapping("/selectImpReqList")
    @ResponseBody
    public AjaxModel selectImpReqList(AjaxModel model) throws Exception{
        return impService.selectImpReqList(model);
    }

    @RequestMapping("/selectImpReq")
    @ResponseBody
    public AjaxModel selectImpReq(AjaxModel model) throws Exception{
        return impService.selectImpReq(model);
    }

    @RequestMapping("/deleteImpReqs")
    @ResponseBody
    public AjaxModel deleteImpReqs(AjaxModel model) throws Exception{
        return impService.deleteImpReqs(model);
    }

    @RequestMapping("/selectImpReqItemList")
    @ResponseBody
    public AjaxModel selectImpReqItemList(AjaxModel model) throws Exception{
        return impService.selectImpReqItemList(model);
    }

    @RequestMapping("/deleteImpReqItems")
    @ResponseBody
    public AjaxModel deleteImpReqItems(AjaxModel model) throws Exception{
        return impService.deleteImpReqItems(model);
    }

    @RequestMapping("/createImpReqItems")
    @ResponseBody
    public AjaxModel createImpReqItems(AjaxModel model) throws Exception{
        return impService.createImpReqItems(model);
    }

    @RequestMapping("/saveImpReq")
    @ResponseBody
    public AjaxModel saveImpReq(AjaxModel model) throws Exception{
        return impService.saveImpReq(model);
    }

    @RequestMapping("/sendImpReq")
    @ResponseBody
    public AjaxModel sendImpReq(AjaxModel model) throws Exception{
        return impService.sendImpReq(model);
    }
    
    @RequestMapping("/downloadImpReq")
    public void downloadImpReq(@RequestParam("REQ_NO") String reqNo, HttpServletResponse response) throws Exception {
        try(ServletOutputStream out = response.getOutputStream();){
        	try {
				AjaxModel rst = impService.downloadImpReq(reqNo);
				
				response.setContentType("application/octet-stream");
				response.setHeader("Accept-Ranges", "bytes");
				response.setHeader("Content-Disposition", "attachment;filename=IMPREQ" + URLEncoder.encode(reqNo + ".txt", StandardCharsets.UTF_8.toString())+";");
				
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
    
    @RequestMapping("/downloadImpReqInZip")
    public void downloadImpReq(@RequestParam("REQ_NOS[]") String[] reqNos, HttpServletResponse response) throws Exception {
        try(ServletOutputStream out = response.getOutputStream();){
        	try {
        		AjaxModel[] rsts = new AjaxModel[reqNos.length];
        		int idx = 0;
        		for(String reqNo : reqNos) {
        			rsts[idx++] = impService.downloadImpReq(reqNo);
        		}
        		
				response.setContentType("application/octet-stream");
				response.setHeader("Accept-Ranges", "bytes");
				response.setHeader("Content-Disposition", "attachment;filename=IMPREQ.zip;");
	
        		ZipOutputStream zos = new ZipOutputStream(out);
        		idx = 0;
        		for(String reqNo : reqNos) {
        			ZipEntry ze= new ZipEntry("IMPREQ" + reqNo + "txt");
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

    @RequestMapping("/selectExpItemList")
    @ResponseBody
    public AjaxModel selectExpItemList(AjaxModel model) throws Exception{
        return impService.selectExpItemList(model);
    }    
    
    // 수입신고결과 조회
    @RequestMapping("/selectImpResList")
    @ResponseBody
    public AjaxModel selectImpResList(AjaxModel model) throws Exception{
        return impService.selectImpResList(model);
    }

    @RequestMapping("/selectImpRes")
    @ResponseBody
    public AjaxModel selectImpRes(AjaxModel model) throws Exception{
        return impService.selectImpRes(model);
    }

    @RequestMapping("/selectImpResRanList")
    @ResponseBody
    public AjaxModel selectImpResRanList(AjaxModel model) throws Exception{
        return impService.selectImpResRanList(model);
    }
    
    @RequestMapping("/selectImpResRanItemList")
    @ResponseBody
    public AjaxModel selectImpResRanItemList(AjaxModel model) throws Exception{
        return impService.selectImpResRanItemList(model);
    }
    
    @RequestMapping("/uploadResFile")
    @ResponseBody
    public AjaxModel uploadResFile(HttpServletRequest request) throws Exception {
        return impService.uploadResFile(request);
    }
    
    // KOTRA return
    @RequestMapping("/selectImpKotraList")
    @ResponseBody
    public AjaxModel selectImpKotraList(AjaxModel model) throws Exception{
        return impService.selectImpKotraList(model);
    }
    
    @RequestMapping(value = "/downloadImpKotra")
    public void downloadImpKotra(@RequestParam(value = "REG_NOS[]") List<String> regNos, HttpServletResponse response) throws Exception {
        try(ServletOutputStream out = response.getOutputStream();){
        	try {
        		response.setContentType("application/octet-stream");
        		response.setHeader("Accept-Ranges", "bytes");
        		response.setHeader("Content-Disposition", "attachment;filename=kotra_wms.xls;");
        		
        		impService.downloadImpKotra(regNos, out);
        	} catch(Exception e){
        		logger.error("{}", e);
        		response.setContentType("text/html");
         		String errorMsg = commonService.getMessage("E00000003");
         		IOUtils.write("<script>alert('" + errorMsg + "');</script>", response.getOutputStream());
        	} finally {
        		out.flush();
        	}
		} 
    }

    @RequestMapping("/selectImpKotra")
    @ResponseBody
    public AjaxModel selectImpKotra(AjaxModel model) throws Exception{
        return impService.selectImpKotra(model);
    }

    @RequestMapping("/deleteImpKotras")
    @ResponseBody
    public AjaxModel deleteImpKotras(AjaxModel model) throws Exception{
        return impService.deleteImpKotras(model);
    }    

    @RequestMapping("/selectImpKotraItemList")
    @ResponseBody
    public AjaxModel selectImpKotraItemList(AjaxModel model) throws Exception{
        return impService.selectImpKotraItemList(model);
    }

    @RequestMapping("/deleteImpKotraItems")
    @ResponseBody
    public AjaxModel deleteImpKotraItems(AjaxModel model) throws Exception{
        return impService.deleteImpKotraItems(model);
    }

    @RequestMapping("/createImpKotraItems")
    @ResponseBody
    public AjaxModel createImpKotraItems(AjaxModel model) throws Exception{
        return impService.createImpKotraItems(model);
    }

    @RequestMapping("/saveImpKotra")
    @ResponseBody
    public AjaxModel saveImpKotra(AjaxModel model) throws Exception{
        return impService.saveImpKotra(model);
    }    
}
