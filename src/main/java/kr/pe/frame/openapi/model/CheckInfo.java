package kr.pe.frame.openapi.model;

import java.util.HashMap;
import java.util.Map;

/**
 * OPEN API 타입정보
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
public class CheckInfo {
	private DataType dataType;
	
	private String length;
	private boolean isMan = false;
	private String[] codes;	// Validation Check용 임으로 코드만 있으면 됨
	private String codeQueryId;
	private Map<String,CheckInfo> subCheckers;
	
	public DataType getDataType() {
		return dataType;
	}
	
	public void setDataType(DataType dataType) {
		this.dataType = dataType;
	}
	
	public String getLength() {
		return length == null ? "99999" : length;
	}
	
	public void setLength(String length) {
		this.length = length;
	}
	
	public boolean isMan() {
		return isMan;
	}
	
	public void setMan(boolean isMan) {
		this.isMan = isMan;
	}
	
	public String[] getCodes() {
		return codes;
	}
	
	public void setCodes(String[] codes) {
		this.codes = codes;
	}

	public String getCodeQueryId() {
		return codeQueryId;
	}

	public void setCodeQueryId(String codeQueryId) {
		this.codeQueryId = codeQueryId;
	}

	public Map<String, CheckInfo> getSubCheckers() {
		return subCheckers;
	}

	public void setSubCheckers(Map<String, CheckInfo> subCheckers) {
		this.subCheckers = subCheckers;
	}
	
	public CheckInfo setLIST(boolean isMan) {	// subCheckers는 추가적으로 넣어야 함
		this.setDataType(DataType.LIST);
		this.subCheckers = new HashMap<String,CheckInfo>();
		this.setMan(isMan);
		
		return this;
	}
	
	public CheckInfo setVARCHAR(String length, boolean isMan) {
		this.setDataType(DataType.VARCHAR);
		this.setLength(length);
		this.setMan(isMan);
		
		return this;
	}
	
	public CheckInfo setNUMERIC(String length, boolean isMan) {
		this.setDataType(DataType.NUMERIC);
		this.setLength(length);
		this.setMan(isMan);
		
		return this;
	}	
	
	public CheckInfo setCODE(boolean isMan) {
		this.setDataType(DataType.CODE);
		this.setMan(isMan);
		
		return this;
	}
	
	public CheckInfo setCODE(boolean isMan, String[] codes) {
		this.setDataType(DataType.CODE);
		this.setMan(isMan);
		this.setCodes(codes);
		
		return this;
	}		
	
	public CheckInfo setCODE(boolean isMan, String codeQueryId) {
		this.setDataType(DataType.CODE);
		this.setMan(isMan);
		this.setCodeQueryId(codeQueryId);
		
		return this;
	}	
	
	@Override
	public String toString() {
		StringBuffer rst = new StringBuffer();
		rst.append("{'dataType' : '" + dataType.toString() + "', 'length' : '" + length + "', 'isMan' : '" + isMan + "', 'codes' : {");
		int idx = 0;
		if(codes != null) {
			for(String code : codes) {
				if(idx > 0) rst.append(", ");
				rst.append("'" + code + "' : '" + code + "'");
				idx++;
			}
		}
		rst.append("}, 'subCheckers' : {");
		
		idx = 0;
		if(subCheckers != null) {
			for(String id : subCheckers.keySet()) {
				if(idx > 0) rst.append(", ");
				rst.append("'" + id + "' : " + subCheckers.get(id).toString() + "");
				idx++;
			}
		}
		rst.append("}}");
		
		return rst.toString();
	}
}
