package kr.pe.frame.home.mem.service;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.pe.frame.cmm.core.model.AjaxModel;

public interface MemService {
	AjaxModel selectUser(AjaxModel model) throws Exception;
	
	AjaxModel saveMemberJoin(HttpServletRequest request, HttpServletResponse response) throws Exception;

    AjaxModel saveEmailAuth(AjaxModel model) throws Exception;
    
    AjaxModel selectEmailAuth(AjaxModel model) throws Exception;
    
    AjaxModel selectUthUsr(AjaxModel model) throws Exception;
}
