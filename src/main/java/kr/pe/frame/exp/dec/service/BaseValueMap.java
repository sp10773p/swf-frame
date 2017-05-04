package kr.pe.frame.exp.dec.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class BaseValueMap {
	private Map<String, Object> maps = null;
	private String[] itemNmArr = null;
	public BaseValueMap(List<Map<String, Object>> record){
		if (record !=null && record.size()>0){
			this.maps = new HashMap();
			this.itemNmArr = new String[record.size()];
			Map<String, Object> tmpCm = new HashMap<String, Object>();
			for ( int i=0;i<record.size(); i++ ){
				tmpCm = (Map<String, Object>)record.get(i);
				this.maps.put((String)tmpCm.get("DOC_ITEM").toString().toUpperCase(), tmpCm);
				this.itemNmArr[i] = tmpCm.get("DOC_ITEM").toString().toUpperCase();
			}
		}
	}
	public BaseValueMap() {
		this.maps = new HashMap<String, Object> ();
	}
	public String[] getItemNmArr(){
		return this.itemNmArr;
	}
	public Map<String, Object> getBaseValMap(String itemNm){
		return (Map)this.maps.get(itemNm);
	}
	public void setBaseValue(String itemNm, String BaseVal){
		//기존에 있던 정보 대신 입력
		Map<String, Object> tmpCm = new HashMap<String, Object>();
		tmpCm.put("DOC_ITEM", itemNm);
		tmpCm.put("BASE_VAL", BaseVal);
		
		if ( this.maps == null ) this.maps = new HashMap<String, Object>();
		
		this.maps.put(itemNm, tmpCm);
	}
	public int size(){
		int size = 0;
		if (this.itemNmArr == null){
			size = 0;
		}else {
			size = itemNmArr.length;
		}
		return size;
	}
}
