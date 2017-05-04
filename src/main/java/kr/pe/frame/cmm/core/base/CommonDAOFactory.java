package kr.pe.frame.cmm.core.base;

import kr.pe.frame.cmm.util.StringUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;

/**
 * 모든 DAO를 관리하고 반환
 * @author 성동훈
 * @since 2017-01-05
 * @version 1.0
 * @see CommonDAO, CommonExppsDAO, CommonTradeDAO, CommonUcpappDAO, CommonZipDAO
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
@Repository
public class CommonDAOFactory {
    @Resource(name = "commonDAO")
    private CommonDAO commonDAO;

    @Resource(name = "commonZipDAO")
    private CommonZipDAO commonZipDAO;

    @Resource(name = "commonTradeDAO")
    private CommonTradeDAO commonTradeDAO;

    /**
     * CommonDAO를 반환
     * @return
     */
    public AbstractDAO getDao(){
        return commonDAO;
    }

    /**
     * poolName에 해당하는 DAO를 반환
     * @param poolName
     * @return
     */
    public AbstractDAO getDao(String poolName){
        if(StringUtil.isEmpty(poolName)){
            poolName = "default";
        }

        if("zip".equals(poolName.toLowerCase())){
            return commonZipDAO;

        }else if("trade".equals(poolName.toLowerCase())){
            return commonTradeDAO;

        }

        return getDao();
    }
}
