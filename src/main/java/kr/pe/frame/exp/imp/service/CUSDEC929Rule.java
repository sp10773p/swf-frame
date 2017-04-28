package kr.pe.frame.exp.imp.service;


/**
 * 반품수입 응답 파일(FF) 처리용 매핑
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
public enum CUSDEC929Rule {
    UP_IHDR_RULE("#IHDR^IMP_REQ_NO#^RPT_NO#^RPT_DAY#SYSDATE^CUS#^SEC#^BLNO#^BL_YN#^MRN#^MSN#^HSN#^ARR_DAY#^INC_DAY#^LEV_FORM#^RPT_FIRM#^RPT_NAME#^RPT_TELNO#^RPT_EMAIL#^#^IMP_CODE#^IMP_FIRM#^#^IMP_TGNO#^IMP_DIVI#^NAB_CODE#^NAB_FIRM#^NAB_NAME#^NAB_PA_MARK#^NAB_ADDR1#^NAB_ADDR2#^NAB_TGNO#^NAB_SDNO#^NAB_SDNO_DIVI#^NAB_TELNO#^NAB_EMAIL#^#^OFF_FIRM#^OFF_MARK#^SUP_FIRM#^SUP_ST#^SUP_ST_SHT#^SUP_MARK#^TG_PLN_MARK#^TG_PLN_COT#^RPT_DIVI_MARK#^RPT_DIVI_COT#^EXC_DIVI_MARK#^EXC_DIVI_COT#^IMP_KI_MARK#^IMP_KI_COT#^ORI_ST_PRF_YN#^AMT_RPT_YN#^TOT_WT#0^TOT_UT#KG^TOT_PACK_CNT#0^TOT_PACK_UT#^ARR_MARK#^ARR_NAME#^TRA_MET#^TRA_CTA#^FOD_MARK#^FOD_SHT#^SHIP#^ST_SHT#^ST_CODE#^MAS_BLNO#^TRA_CHF_MARK#^CHK_PA_MARK#^CHK_PA#^CHK_PA_NAME#^TOT_RAN_CNT#0^CON_COD#^CON_CUR#^CON_RATE#0^CON_RATE_USD#0^CON_TOT_AMT#0^CON_KI#^CON_KI_COT#^CON_AMT#0^CON_GITA_AMT#0^TOT_TAX_USD#0^TOT_TAX_KRW#0^FRE_KRW#0^FRE1_KI#^FRE1_AMT#0^#^#0^INSU_KRW#0^INSU1_KI#^INSU1_AMT#0^AD_DIVI#^AD_CUR_KI#^AD_CST_RATE#0^#^#0^AD_CST_KRW#0^SUB_DIVI#^SUB_CUR_KI#^SUB_CST_RATE#0^SUB_CST_KRW#0^TOT_GS#0^TOT_TS#0^TOT_HOF#0^TOT_GT#0^TOT_KY#0^TOT_NT#0^TOT_VAT#0^TOT_DLY_TAX#0^TOT_ADD_TAX#0^TOT_TAX_SUM#0^ADD_TAX_GBN#N^NAB_NO#^NAB_DELI_DAY#^VAT_TAX_CT#0^VAT_FREE_CT#0^SP_DELI#^SEND_DIVI#9^RES_FORM#AB^CB_DIVI1#^CB_DIVI2#^CB_DIVI3#^CB1#^CB2#^CB3#^CB4#^CB5#^CB6#^CB7#^CB8#^CB9#^CUS_NOTICE#^#^#^#^#^#^#^#^#^JU_NAME#^JU_MARK#^RC_DAY#^LIS_DAY#^FILE_NO#^SEND#^RECE#^MD_REFE_NO#^SN_DIVI#^BLYNCD#^BLYNTXT#^AMTFIXDAY#^AMTNO_5SM#^FWDMARK#^FWDNAME#^MODI_RPT#^"), 
    UP_IDTL_RULE("#IDTL^IMP_REQ_NO#^RPT_NO#^RAN_NO#^HS#^STD_GNAME#^#^EXC_GNAME#^#^STD_CODE#^MODEL_GNAME#^ATT_YN#N^FRE_CUR#^FRE_AMT#0^FRE_KRW#0^INSU_CUR#^INSU_AMT#0^INSU_KRW#0^AD_CUR#^AD_AMT#0^AD_CST#0^SUB_CUR#^SUB_AMT#0^SUB_CST#0^TAX_KRW#0^TAX_USD#0^TAX_USG_KRW#0^TAX_USG_USD#0^SUN_WT#0^SUN_UT#KG^QTY#0^QTY_UT#^REF_WT#0^REF_UT#^CS_CHK_MARK#^CS_CHK_COT#^CHK_MET_MARK#^CHK_MET_COT#^AFT_CHK_CHF1#^AFT_CHK_CHF2#^AFT_CHK_CHF3#^ORI_ST_MARK1#^ORI_ST_SHT#^ORI_ST_MARK2#^ORI_ST_MARK3#^ORI_ST_MARK4#^ORI_ST_DAY#^ORI_ST_NO#^ORI_ST_CHF#^ORI_ST_STNCD#^SP_TAX_BASIS#0^TAX_KI_DIVI#^GS_DIVI#^GS_RATE#0^UPI_TAX#0^GS_RMV_RATE#0^GS#0^GS_RMV#0^GS_RMV_MARK#^GS_RMV_DIVI#^SEND_RATE#0^NG_DIVI#^NG_KI_DIVI#^NG_MARK#^NG_RATE#0^NG_RMV_AMT#0^NG#0^TS_FREE_MARK#^TS_CET_SUB#0^TS#0^GT#0^HOF#0^KY_DIVI#^KY_KI_DIVI#^KY_RMV_AMT#0^KY_RATE#0^KY#0^NT_DIVI#^NT_KI_DIVI#^NT#0^NT_RATE#0^VAT_RATE#0^VAT_DIVI#^VAT_KI_DIVI#^VAT#0^VAT_RMV_MARK#^VAT_RMV#0^VAT_RMV_RATE#0^GS_CET#^VAT_TAX_CT#0^VAT_FREE_CT#0^SP_DELI#^ROY_RATE#0^ROY_DIVI#^ROY_AMT#0^CHK_MET_CH#^DAM_AMT#0^TOT_SIZE_CNT#0^TOT_EXP_CNT#0^TOT_C4_CNT#^YONGDO_NO#^#^ORI_ST_STN#^ORI_ST_NAME#^ORI_ST_MARK5#^ORI_ST_MARK6#^ORI_ST_TOTQTY#0^ORI_ST_QTY#0^ORI_ST_TOTWT#0^ORI_ST_WT#0^ORI_ST_PARTYN#^ITEMCD#^ITEMCDSEND#^"),
    UP_IMDL_RULE("#IMDL^IMP_REQ_NO#^RPT_NO#^RAN_NO#^SIL#^RG_CODE#^IMP_GNAME1#^IMP_GNAME2#^IMP_GNAME3#^COMPOENT1#^COMPOENT2#^QTY#0^UT#^UPI#0^AMT#0^D26_RPT_NO#^"), 
    
    DOWN_IHDR_RULE("#IHDR^REQ_NO#^#^RPT_DAY#^CUS#^SEC#^BLNO#^#^MRN#^MSN#^HSN#^#^#^LEV_FORM#^#^#^#^#^#^#^IMP_FIRM#^#^IMP_TGNO#^#A^#^NAB_FIRM#^NAB_NAME#^NAB_PA_MARK#^NAB_ADDR1#^#^NAB_TGNO#^NAB_SDNO#^#^NAB_TELNO#^RPT_EMAIL#^#^#^#^SUP_FIRM#^SUP_ST#^#^SUP_MARK#^#^#^RPT_DIVI_MARK#^#^EXC_DIVI_MARK#^#^IMP_KI_MARK#^#^ORI_ST_PRF_YN#^AMT_RPT_YN#^TOT_WT#0^TOT_UT#KG^TOT_PACK_CNT#0^TOT_PACK_UT#^ARR_MARK#^#^TRA_MET#^TRA_CTA#^FOD_ST_ISO#^#^SHIP_NM#^#^SHIP_ST_ISO#^MAS_BLNO#^#^#^#^#^#0^CON_COD#^CON_CUR#^#0^#0^#0^CON_KI#^#^CON_AMT#0^#0^#0^#0^#0^FRE_UT#^FRE_AMT#0^#^#0^#0^INSU_UT#^INSU_AMT#0^#^ADD_UT#^ADD_AMT#0^#^#0^#0^#^SUB_UT#^SUB_AMT#0^#0^#0^#0^#0^#0^#0^#0^#0^#0^#0^#0^#N^#^#^#0^#0^#^#9^#AB^#^#^#^#^#^#^#^#^#^#^#^#^#^#^#^#^#^#^#^#^#^#^#^#^#^#^#^#^#^#^#^#^#^#^#^#^#^"), 
    DOWN_IDTL_RULE("#IDTL^REQ_NO#^#^RAN_NO#^HS#^STD_GNAME#^#^EXC_GNAME#^#^#^#^#N^#^#0^#0^#^#0^#0^#^#0^#0^#^#0^#0^#0^#0^#0^TAX_USG_USD#0^SUN_WT#0^SUN_UT#KG^QTY#0^QTY_UT#^#0^#^#^#^#^#^#^#^#^ORI_ST_MARK1#^#^#^#^#^#^#^#^#^#0^#^#^#0^#0^#0^#0^#0^GS_RMV_MARK#^GS_RMV_DIVI#^#0^#^#^#^#0^#0^#0^#^#0^#0^#0^#0^#^#^#0^#0^#0^#^#^#0^#0^#0^VAT_DIVI#^#^#0^VAT_RMV_MARK#^#0^#0^#^#0^#0^#^#0^#^#0^#^#0^#0^#0^#^#^#^#^#^#^#^#0^#0^#0^#0^#^#^#^"),
    DOWN_IMDL_RULE("#IMDL^REQ_NO#^#^RAN_NO#^SIL#^#^IMP_GNAME1#^IMP_GNAME2#^IMP_GNAME3#^COMPOENT1#^COMPOENT2#^QTY#0^UT#^UPI#0^AMT#0^#^"),    
    DOWN_IEXP_RULE("#IEXP^REQ_NO#^#^RAN_NO#^SIL#^EXPCD#^EXPRANNO#^EXPSILNO#^#^#^QTY#0^QTY_UT#^"),    
    
    IHDR("IHDR"), 
    IDTL("IDTL"), 
    IMDL("IMDL"), 
    IEXP("IEXP"),  
    
    UP("UP"), 
    DOWN("DOWN")
    ;
    
    private String key;
    CUSDEC929Rule(String key){
        this.key = key;
    }

    public String getCode(){
        return this.key;
    }
    
    public static String getRuleStr(String header, CUSDEC929Rule upDown) {
    	CUSDEC929Rule headerO = null;
        for (CUSDEC929Rule me : CUSDEC929Rule.values()) {
            if (me.name().equalsIgnoreCase(header)) {
            	headerO = me;
            	break;
            }
        }
        
        if(headerO == null) return null;
        
		return CUSDEC929Rule.getRuleStr(headerO, upDown);
    }
    
    public static String getRuleStr(CUSDEC929Rule header, CUSDEC929Rule upDown) {
		switch(upDown) {
			case UP : 
	    		switch(header) {
	    			case IHDR : return UP_IHDR_RULE.getCode();
	    			case IDTL : return UP_IDTL_RULE.getCode();
	    			case IMDL : return UP_IMDL_RULE.getCode();
					default: return null;
	    		}
			case DOWN : 
	    		switch(header) {
	    			case IHDR : return DOWN_IHDR_RULE.getCode();
	    			case IDTL : return DOWN_IDTL_RULE.getCode();
	    			case IMDL : return DOWN_IMDL_RULE.getCode();
	    			case IEXP : return DOWN_IEXP_RULE.getCode();
					default: return null;
	    		}
			default: return null;		
    	}
    }    
}