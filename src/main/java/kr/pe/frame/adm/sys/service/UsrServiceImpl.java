package kr.pe.frame.adm.sys.service;

import kr.pe.frame.adm.sys.model.UsrSessionModel;
import kr.pe.frame.cmm.core.base.CommonDAO;
import kr.pe.frame.cmm.core.base.Constant;
import kr.pe.frame.cmm.core.base.Sha256;
import kr.pe.frame.cmm.core.model.AjaxModel;
import kr.pe.frame.cmm.core.service.CommonService;
import kr.pe.frame.cmm.core.service.FileCommonService;
import kr.pe.frame.cmm.util.DocUtil;
import kr.pe.frame.cmm.util.RandomString;
import kr.pe.frame.cmm.util.StringUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 시스템관리 > 사용자관리 구현 클래스
 *
 * @author 성동훈
 * @version 1.0
 * @see UsrService
 * <p>
 * <pre>
 * == 개정이력(Modification Information) ==
 *
 * 수정일      수정자  수정내용
 * ----------- ------- ---------------------------
 * 2017.01.05  성동훈  최초 생성
 *
 * </pre>
 * @since 2017-01-05
 */
@Service(value = "usrService")
public class UsrServiceImpl implements UsrService {
    Logger logger = LoggerFactory.getLogger(this.getClass());

    @Resource(name = "commonDAO")
    private CommonDAO commonDAO;

    @Resource(name = "menuService")
    private MenuService menuService;

    @Resource(name = "commonService")
    private CommonService commonService;

    @Resource(name = "fileCommonService")
    private FileCommonService fileCommonService;

    /**
     * {@inheritDoc}
     *
     * @param usrId 사용자 ID
     * @return UsrSessionModel
     * @throws Exception
     */
    @Override
    public UsrSessionModel selectUsrSessionInfo(String usrId, String sessionDiv) throws Exception {
        UsrSessionModel model = (UsrSessionModel) commonDAO.select("usr.selectUsrSessionInfo", usrId);

        if (model != null) {

            model.setEmail(DocUtil.decrypt(model.getEmail()));
            model.setHpNo(DocUtil.decrypt(model.getHpNo()));
            model.setTelNo(DocUtil.decrypt(model.getTelNo()));

            model.setMenuModelList(menuService.selectUsrMenuList(model.getAuthCd(), sessionDiv));

            Map<String, List<String>> menuAuthRet = new HashMap<>();
            List<Map<String, String>> menuAuth = commonDAO.list("menu.selectCmmBtnAuth", usrId);
            for (Map<String, String> data : menuAuth) {
                String menuId = data.get("MENU_ID");
                String btnId = data.get("BTN_ID");

                List<String> btnList;
                if (menuAuthRet.containsKey(menuId)) {
                    btnList = menuAuthRet.get(menuId);

                } else {
                    btnList = new ArrayList<>();
                }

                btnList.add(btnId);
                menuAuthRet.put(menuId, btnList);
            }

            model.setMenuBtnAuth(menuAuthRet);
        }

        return model;
    }

    /**
     * {@inheritDoc}
     *
     * @param model
     * @return
     * @throws Exception
     */
    @Override
    public AjaxModel selectUsrList(AjaxModel model) throws Exception {
        model = commonService.selectGridPagingList(model);
        List<Map<String, Object>> list = model.getDataList();

        for (Map<String, Object> map : list) {
            map.put("EMAIL", DocUtil.decrypt((String) map.get("EMAIL")));
            map.put("HP_NO", DocUtil.decrypt((String) map.get("HP_NO")));
            map.put("TEL_NO", DocUtil.decrypt((String) map.get("TEL_NO")));
        }

        return model;
    }

    /**
     * {@inheritDoc}
     *
     * @param model
     * @return
     * @throws Exception
     */
    @Override
    public AjaxModel selectUsr(AjaxModel model) throws Exception {
        Map param = model.getData();

        // 필수 쿼리 아이디 체크
        if (StringUtil.isEmpty((String) param.get(Constant.QUERY_KEY.getCode()))) {
            model.setStatus(-1);
            model.setMsg(commonService.getMessage("E00000001")); // 조회 쿼리 ID가 존재하지 않습니다.

            return model;
        }

        // 조회쿼리
        String qKey = (String) param.get(Constant.QUERY_KEY.getCode());
        if (!param.containsKey("USER_ID")) {
            param.put("USER_ID", model.getUsrSessionModel().getUserId());
        }
        Map<String, Object> map = (Map<String, Object>) commonDAO.select(qKey, param);

        map.put("EMAIL", DocUtil.decrypt((String) map.get("EMAIL")));
        map.put("HP_NO", DocUtil.decrypt((String) map.get("HP_NO")));
        map.put("TEL_NO", DocUtil.decrypt((String) map.get("TEL_NO")));

        model.setData(map);

        return model;
    }

    /**
     * {@inheritDoc}
     *
     * @param model
     * @return
     * @throws Exception
     */
    @Override
    public AjaxModel saveUser(AjaxModel model) throws Exception {
        Map<String, Object> param = model.getData();
        logger.debug("param {}", param);

        // 필드 암호화 처리
        if (StringUtil.isNotEmpty((String) param.get("EMAIL"))) {
            param.put("EMAIL", DocUtil.encrypt((String) param.get("EMAIL")));
        }

        if (StringUtil.isNotEmpty((String) param.get("TEL_NO"))) {
            param.put("TEL_NO", DocUtil.encrypt((String) param.get("TEL_NO")));
        }

        if (StringUtil.isNotEmpty((String) param.get("HP_NO"))) {
            param.put("HP_NO", DocUtil.encrypt((String) param.get("HP_NO")));
        }

        param.put("MOD_ID", model.getUsrSessionModel().getUserId());

        commonDAO.update("usr.updateUser", param);

        // 가입상태 변경에 따른 처리
        String userStatus = (String) param.get("USER_STATUS");
        String orgUserStatus = (String) param.get("ORG_USER_STATUS");
        if (!orgUserStatus.equals(userStatus)) {
            model.getData().put("EMAIL", DocUtil.decrypt((String) param.get("EMAIL")));

            // 가입승인
            if ("1".equals(userStatus)) {
                saveUserApprove(model);

                // 탈퇴승인
            } else if ("9".equals(userStatus)) {
                saveUserDrop(model);

            } else {
                commonDAO.insert("usr.insertCmmStatusHis", param);

            }
        }

        model.setCode("I00000003"); //저장되었습니다.

        return model;
    }

    /**
     * {@inheritDoc}
     *
     * @param model
     * @return
     * @throws Exception
     */
    @Override
    public AjaxModel saveInitPass(AjaxModel model) throws Exception {
        String randomPassword = RandomString.random(10); //10자리 생성한 임시 패스워드

        Map<String, Object> mailMap = model.getData();

        String passwd = Sha256.encrypt(randomPassword);
        mailMap.put("USER_PW", passwd);
        mailMap.put("RANDOM_PASSWORD", randomPassword);

        // 암호 초기화
        commonDAO.update("usr.updateUserPassword", mailMap);

        String receiver = (String) mailMap.get("EMAIL");
        String title = "GoGlobal 서비스 사용자 임시 비밀번호 발송";
        String vmName = "init_password_mail.html";
        commonService.sendSimpleEMail(receiver, title, vmName, mailMap);

        model.setCode("I00000007"); //비밀번호가 초기화 되었습니다.

        return model;
    }

    /**
     * {@inheritDoc}
     *
     * @param model
     * @return
     * @throws Exception
     */
    @Override
    public AjaxModel saveUserApprove(AjaxModel model) throws Exception {
        Map<String, Object> param = model.getData();

        Map<String, Object> userData = (Map<String, Object>) commonDAO.select("usr.selectUser", param);

        String userDiv = (String) userData.get("USER_DIV");
        String authCd = (String) userData.get("AUTH_CD");

        // 관세사이고 권한코드가 없을때 권한코드 update+0.
        if ("G".equals(userDiv) && StringUtil.isEmpty(authCd)) {
            userData.put("AUTH_CD", "CUSTOMS");
            userData.put("REG_ID", model.getUsrSessionModel().getUserId());
            commonDAO.update("usr.updateUserAuthcd", userData);
        }

        commonDAO.update("usr.updateUserApprove", userData);// 회원상태 업데이트

        //판매자 기본값 테이블에서 해당 키값의 데이터를 삭제..승인시 해당정보는 없어야함
        commonDAO.delete("usr.deleteCmmbasevalSeller", userData);

        //판매자 신고서 기본값 CMM_BASEVAL_SELLER에 기본값 Insert
        commonDAO.insert("usr.insertCmbasevalSeller", userData);

        // 상태변경 내역 저장
        param.put("USER_STATUS", "1");
        param.put("USER_STATUS_REASON", "가입승인");
        commonDAO.insert("usr.insertCmmStatusHis", param);

        param.put("USER_DIV", userDiv);

        param.putAll((Map) commonDAO.select("usr.selectUserBaseVal", param));

        String receiver = (String) param.get("EMAIL");
        String title = "GoGlobal 서비스 사용자 가입승인";
        String vmName = "user_approve_mail.html";

        commonService.sendSimpleEMail(receiver, title, vmName, param);

        model.setCode("I00000008"); // 승인 되었습니다.

        return model;
    }

    /**
     * {@inheritDoc}
     *
     * @param model
     * @return
     */
    @Override
    public AjaxModel saveMakeApiKey(AjaxModel model) {
        Map<String, Object> param = model.getData();

        //API 키를 생성하여 등록함.
        Map<String, Object> apiMap = new HashMap<>();
        apiMap.put("USER_ID", param.get("USER_ID"));
        apiMap.put("API_KEY", DocUtil.getApiKey());
        apiMap.put("MOD_ID", model.getUsrSessionModel().getUserId());

        commonDAO.update("usr.updateAPIKeyMng", apiMap);

        // API키관리상세 등록
        List<Map<String, Object>> list = commonDAO.list("usr.selectApiDtl", apiMap); //CMM_API_KEY_DTL 조회

        if (list.size() <= 0) { //기존 ApiKeyDtl 데이터가 없을 경우
            commonDAO.insert("usr.insertApiDtl", apiMap);
        }

        model.setCode("I00000009");// 생성되었습니다.

        return model;
    }

    /**
     * {@inheritDoc}
     *
     * @param model
     * @return
     * @throws Exception
     */
    @Override
    public AjaxModel saveUserDrop(AjaxModel model) throws Exception {
        Map<String, Object> param = model.getData();

        param.put("MOD_ID", model.getUsrSessionModel().getUserId());

        commonDAO.update("usr.updateUserDrop", param); // 사용자 정보 갱신

        // API KEY 상태를 사용정지로 변경
        commonDAO.update("usr.updateApiReqStatus", param);

        // 상태변경 내역 저장
        param.put("USER_STATUS", "9");
        param.put("USER_STATUS_REASON", "탈퇴승인");
        commonDAO.insert("usr.insertCmmStatusHis", param);

        String receiver = (String) param.get("EMAIL");
        String title = "GoGlobal 서비스 탈퇴가 완료되었습니다.";
        String vmName = "user_drop_mail.html";

        commonService.sendSimpleEMail(receiver, title, vmName, param);

        model.setCode("I00000010"); //탈퇴승인 되었습니다.

        return model;
    }

    /**
     * {@inheritDoc}
     *
     * @param model
     * @return
     * @throws Exception
     */
    @Override
    public AjaxModel saveUserAttachFileId(AjaxModel model) throws Exception {
        Map<String, Object> params = model.getData();

        commonDAO.update("usr.udpateUsrAttchFileId", params);
        return model;
    }

    /**
     * {@inheritDoc}
     *
     * @param usrSessionModel
     */
    @Override
    public void updateUserLoginInfo(UsrSessionModel usrSessionModel) {
        commonDAO.update("usr.updateUserLoginInfo", usrSessionModel);
    }

    /**
     * {@inheritDoc}
     *
     * @param model
     * @return
     */
    @Override
    public AjaxModel deleteUser(AjaxModel model) {
        Map<String, Object> param = model.getData();
        Map<String, Object> userData = (Map<String, Object>) commonDAO.select("usr.selectUser", param);

        // 1. 첨부파일 삭제
        if (StringUtil.isNotEmpty((String) userData.get("ATCH_FILE_ID"))) {
            AjaxModel fileAjaxModel = new AjaxModel();
            fileAjaxModel.setData(userData);
            fileCommonService.deleteFiles(fileAjaxModel);
        }

        // 2. api 키 삭제
        commonDAO.delete("api.deleteCmmapikeydtl", userData); // DETAIL 삭제
        commonDAO.delete("api.deleteCmmapikeymst", userData); // MASTER 삭제

        // 3. 사용자 신고서 기본값 삭제
        commonDAO.delete("usr.deleteCmmbasevalseller", userData);

        // 4. 수발신 식별자 삭제
        commonDAO.delete("usr.deleteCmmidentifier", userData);

        // 5. 가입상태 내역 삭제
        commonDAO.delete("usr.deleteCmmstatushis", userData);

        // 6. 사용자 삭제
        commonDAO.delete("usr.deleteCmmuser", userData);

        model.setCode("I00000004"); //삭제되었습니다.

        return model;
    }

}
