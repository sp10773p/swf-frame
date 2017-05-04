package kr.pe.frame.adm.sys.controller;

import kr.pe.frame.adm.sys.model.MenuModel;
import kr.pe.frame.adm.sys.model.UsrSessionModel;
import kr.pe.frame.cmm.core.service.CommonService;
import kr.pe.frame.cmm.util.WebUtil;
import kr.pe.frame.cmm.core.base.Constant;
import kr.pe.frame.cmm.core.model.AjaxModel;
import kr.pe.frame.adm.sys.service.MenuService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.List;

/**
 * 시스템관리 > 메뉴관리 Controller
 * 메뉴 관련 기능
 * @author 성동훈
 * @since 2017-01-05
 * @version 1.0
 * @see MenuService
 *
 * <pre>
 * == 개정이력(Modification Information) ==
 *
 * 수정일      수정자  수정내용
 * ----------- ------- ---------------------------
 * 2017.01.05  성동훈  최초 생성
 *
 * </pre>
 */
@Controller
public class MenuController {

    @Resource(name = "menuService")
    private MenuService menuService;

    @Resource(name = "commonService")
    private CommonService commonService;


    /**
     * 메뉴 이동
     * @param jsp
     * @param menuId
     * @param menuNm
     * @param menuDiv
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/jspView")
    public ModelAndView jspView(@RequestParam(value = "jsp") String jsp,
                                @RequestParam(value = "MENU_ID", required = false) String menuId,
                                @RequestParam(value = "MENU_NM", required = false) String menuNm,
                                @RequestParam(value = "MENU_DIV", required = false) String menuDiv, HttpServletRequest request) throws Exception {
        ModelAndView mnv = new ModelAndView();

        if(menuId == null){
            menuId = (String)request.getAttribute(Constant.ACTION_MENU_ID.getCode());
        }
        if(menuNm == null){
            menuNm = (String)request.getAttribute(Constant.ACTION_MENU_NM.getCode());
        }
        if(menuDiv == null){
            menuDiv = (String)request.getAttribute(Constant.ACTION_MENU_DIV.getCode());
        }

        List<MenuModel> menuModels = null;
        UsrSessionModel sessionModel = commonService.getUsrSessionModel(request);
        if(sessionModel != null) {
            menuModels = sessionModel.getMenuModelList();
        }
        if(menuId == null){
            if(sessionModel != null){
                menuModels = sessionModel.getMenuModelList();
                MenuModel menuModel = menuService.findJspMenu(menuModels, jsp);
                menuId = menuModel.getMenuId();
                menuNm = menuModel.getMenuNm();
            }
        }

        if("Y".equals(request.getParameter("IS_FRAME_PAGE")) && menuModels != null){
            MenuModel rootMenuModel = menuService.findRootMenu(menuModels, menuId);
            if(rootMenuModel != null){
                mnv.addObject(Constant.ACTION_TOP_MENU_ID.getCode(), rootMenuModel.getMenuId());
                mnv.addObject(Constant.ACTION_TOP_MENU_NM.getCode(), rootMenuModel.getMenuNm());
            }
        }


        mnv.addObject(Constant.ACTION_MENU_ID.getCode(), menuId);
        mnv.addObject(Constant.ACTION_MENU_NM.getCode(), menuNm);
        mnv.addObject(Constant.ACTION_MENU_DIV.getCode(), menuDiv);

        mnv.addAllObjects(WebUtil.getParameterToObject(request));

        mnv.setViewName(jsp);
        return mnv;
    }

    /**
     * 메뉴 조회
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/menu/menuList")
    @ResponseBody
    public AjaxModel getMenuList(AjaxModel model)throws Exception{
        return menuService.selectMenuList(model);
    }

    /**
     * 메뉴 저장
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/menu/saveMenu")
    @ResponseBody
    public AjaxModel saveMenu(AjaxModel model)throws Exception{
        return menuService.saveMenu(model);
    }

    /**
     * 메뉴 삭제
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/menu/deleteMenu")
    @ResponseBody
    public AjaxModel deleteMenu(AjaxModel model)throws Exception{
        return menuService.deleteMenu(model);
    }

    /**
     * 메뉴별 버튼 저장
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/menu/saveMenuBtn")
    @ResponseBody
    public AjaxModel saveMenuBtn(AjaxModel model)throws Exception{
        return menuService.saveMenuBtn(model);
    }

    /**
     * 메뉴별 버튼 삭제
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/menu/deleteMenuBtn")
    @ResponseBody
    public AjaxModel deleteMenuBtn(AjaxModel model)throws Exception{
        return menuService.deleteMenuBtn(model);
    }
}
