package kr.pe.frame.openapi.model;

/**
 * OPEN API 에러 상세 종류
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
public enum ErrorDescription {
	UNAUTHORIZED_REQUEST("접근권한이 없습니다."), 
	INVALID_REQUEST_DATA("잘못된 요청값입니다."), 
	REQUIRED_FIELD_MSG("필수항목입니다."), 
	
	INIT_MESSAGE("Initialized.")
    ;

    private String key;
    ErrorDescription(String key){
        this.key = key;
    }

    public String getCode(){
        return this.key;
    }    
    
    public String toString() {
    	return this.getCode();
    }
}
