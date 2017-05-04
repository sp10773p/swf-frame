package kr.pe.frame.home.login.service;

import kr.pe.frame.cmm.core.model.AjaxModel;

public interface HomeLoginService {
	AjaxModel selectUser(AjaxModel model) throws Exception;
}
