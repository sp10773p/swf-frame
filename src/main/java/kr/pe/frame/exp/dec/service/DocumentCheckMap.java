package kr.pe.frame.exp.dec.service;

import java.util.List;
import java.util.Map;

import org.json.simple.JSONObject;

public class DocumentCheckMap {
	public List<Map<String, Object>> dataSetMap = null;
	public Map<String, Object> map = null;
	public String errMsg = "";
	public JSONObject jsonOBJ = null;
	
	public DocumentCheckMap() {
		this.dataSetMap = null;
		this.map = null;
		this.errMsg = "";
		this.jsonOBJ = null;
	}
	public DocumentCheckMap(List<Map<String, Object>> dsm, Map<String, Object> map, String errMsg, JSONObject errJSON){
		this.dataSetMap = dsm;
		this.map = map;
		this.errMsg = errMsg;
		this.jsonOBJ = errJSON;
	}
}
