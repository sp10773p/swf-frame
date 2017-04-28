package kr.pe.frame.exp.dec.service;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONObject;

public class CalcCheckMap {
	public String exchangeRateStr = "";
	public BigDecimal sumNetWeight = new BigDecimal("0.000");
	public BigDecimal totalDecAmt = new BigDecimal("0");
	public String errMsg = "";
	
	public CalcCheckMap() {
		this.exchangeRateStr = "";
		this.sumNetWeight = null;
		this.totalDecAmt = null;
		this.errMsg = "";
	}
	public CalcCheckMap(String exchangeRateStr, BigDecimal sumNetWeight, BigDecimal totalDecAmt, String errMsg){
		this.exchangeRateStr = exchangeRateStr;
		this.sumNetWeight = sumNetWeight;
		this.totalDecAmt = totalDecAmt;
		this.errMsg = errMsg;
	}
}
