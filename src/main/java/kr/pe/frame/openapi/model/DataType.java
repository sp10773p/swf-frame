package kr.pe.frame.openapi.model;

/**
 * OPEN API 타입종류
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
public enum DataType {
	LIST("LIST"), 
    VARCHAR("VARCHAR"), 
    NUMERIC("NUMERIC"), 
    CODE("CODE")  
    ;

    private String key;
    DataType(String key){
        this.key = key;
    }

    public String getCode(){
        return this.key;
    }    
    
    public String toString() {
    	return this.getCode();
    }
}
