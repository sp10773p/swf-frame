package kr.pe.frame.openapi.model;

/**
 * OPEN API 에러코드 종류
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
public enum ResultTypeCode {
	BUSINESS_ERROR("-1"), 
	NO_ERROR("220"), 
	UNAUTHORIZED("421"),
	UNPROCESSABLE_ENTITY("422"),
	INTERNAL_SERVER_ERROR("500"), 
	
	INIT("000")
    ;

    private String key;
    ResultTypeCode(String key){
        this.key = key;
    }

    public String getCode(){
        return this.key;
    }    
    
    public static boolean isError(String rstTypeCode) {
    	ResultTypeCode rstCode = null;
        for(ResultTypeCode e : values()) {
            if(e.getCode().equals(rstTypeCode)) {
            	rstCode = e;
            	break;
            }
        }    	
        
    	if(rstCode == UNAUTHORIZED || 
    			rstCode == UNPROCESSABLE_ENTITY || 
    			rstCode == INTERNAL_SERVER_ERROR ) {
    		return true;
    	}
    	return false;
    }
    
    public String toString() {
    	return this.getCode();
    }
}
