package kr.pe.frame.exp.dec.service;

/**
 * 수출의뢰 응답 파일(FF) 처리용 매핑
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
public enum CUSDEC830Rule {
    UP_EHDR_RULE("#EHDR^REQ_NO#^RPT_NO#^RPT_FIRM#^RPT_MARK#^RPT_BOSS_NM#^COMM_CODE#^COMM_FIRM#^COMM_REGNO#^COMM_TGNO#^EXP_DIVI#^EXP_CODE#^EXP_FIRM#^EXP_BOSS_NAME#^EXP_ADDR1#^EXP_ADDR2#^EXP_SDNO#^EXP_SDNO_DIVI#^EXP_TGNO#^EXP_POST#^MAK_CODE#^MAK_FIRM#^MAK_TGNO#^MAK_POST#^#^#^#^#^#^INLOCALCD#^BUY_FIRM#^BUY_MARK#^RPT_CUS#^RPT_SEC#^RPT_YEAR#^RPT_LIS_NO#^RPT_DAY#^RPT_DIVI#H^RPT_DIVINM#^EXC_DIVI#^EXC_DIVINM#^EXP_KI#^EXP_KINM#^CON_MET#^CON_METNM#^TA_ST_ISO#^TA_ST_ISONM#^FOD_CODE#^FOD_CODENM#^ARR_MARK#^TRA_MET#^TRA_METNM#^TRA_CTA#^TRA_CTANM#^#^MAK_FIN_DAY#^GDS_POST#^#^GDS_ADDR1#^#^LCNO#^USED_DIVI#N^UP5AC_DIVI#^BAN_DIVI#^BAN_DIVINM#^REF_DIVI#^#^#^RET_DIVI#NO^MRN_DIVI#^CONT_IN_GBN#^TOT_WT#0^UT#KG^TOT_PACK_CNT#0^TOT_PACK_UT#^TOT_RPT_KRW#0^TOT_RPT_USD#0^FRE_KRW#0^FRE_UT#^FRE_AMT#0^INSU_KRW#0^INSU_UT#^INSU_AMT#0^AMT_COD#^CUR#^AMT#0^EXC_RATE_USD#0^EXC_RATE_CUR#0^BOSE_RPT_CODE#^BOSE_RPT_FIRM#^BOSE_RPT_DAY1#^BOSE_RPT_DAY2#^#^EXP_LIS_DAY#^JUK_DAY#^SEND_DIVI#^RES_YN#AB^#^#^TOT_RAN#0^PO_NO#^RPT_USG#^#^#^#^#^#^#^#^#^#^CUS_NOTICE#^#^#^#^#^#^#^#^#^#^FILE_NO#^BLNO#^GS_CHK#^SN_DIVI#^JU_MARK#^JU_NAME#^UCRNO#^MODI_RPT#^"), 
    UP_EDTL_RULE("#EDTL^#^RPT_NO#^RAN_NO#^HS#^STD_GNM#^EXC_GNM#^MG_CODE#^MODEL_GNM#^RPT_KRW#0^RPT_USD#0^CUR_UT#^AMT_COD#^CON_AMT#0^SUN_WT#0^SUN_UT#KG^WT#0^UT#^IMP_RPT_SEND#^IMP_RAN_NO#^PACK_CNT#0^PACK_UT#^ORI_ST_MARK1#^ORI_ST_NM#^ORI_ST_MARK2#^ORI_ST_MARK3#^ORI_FTA_YN#^ATT_YN#N^"),
    UP_EMDL_RULE("#EMDL^#^RPT_NO#^RAN_NO#^SIL#^MG_CD#^GNM1#^GNM2#^GNM3#^GNM4#^GNM5#^GNM6#^#^#^COMP1#^COMP2#^QTY#0^QTY_UT#^PRICE#0^AMT#0^#^"), 
    
    DOWN_EHDR_RULE("#EHDR^REQ_NO#^#^EOCPARTYORGNAME2#^RPT_MARK#^EOCPARTYORGCEONAME#^#^EOCPARTYORGNAME2#^#^EOCPARTYPARTYIDID2#^EXPORTERCLASSCODE#^#^EOCPARTYORGNAME2#^EOCPARTYORGCEONAME#^EOCPARTYADDRLINE#^#^EOCPARTYPARTYIDID1#^#^EOCPARTYPARTYIDID2#^EOCPARTYLOCID#^#^MANUPARTYORGNAME#^MANUPARTYORGID#^MANUPARTYLOCID#^#^#^#^#^#^GOODSLOCATIONID2#^BUYERPARTYORGNAME#^#^CUSTOMORGANIZATIONID#^CUSTOMDEPARTMENTID#^#^#^RPT_DAY#^#^#^#^#^#^#^PAYMENTTERMSTYPECODE#^#^DESTINATIONCOUNTRYCODE#^#^LODINGLOCATIONID#^#^#^TRANSPORTMEANSCODE#^#^#^#^#^#^GOODSLOCATIONID1#^#^GOODSLOCATIONNAME#^#^#^#^#^#^#^#^#^#^SIMPLEDRAWAPPINDICATOR#NO^#^#^SUMMARY_TOTALWEIGHT#0^SUMMARY_TOTALWEIGHT_UC#^SUMMARY_TOTALQUANTITY#0^#^#^#^FRE_KRW#0^FRE_KRW_UC#^FRE_AMT#FRE_KRW^INSU_KRW#0^INSU_KRW_UC#^INSU_AMT#INSU_KRW^DELIVERYTERMSCODE#^PAYMENTAMOUNT_CUR#^PAYMENTAMOUNT#0^#^#^#^#^#^#^#^#^#^#^#^#^#^#^#^#^#^#^#^#^#^#^#^#^#^#^#^#^#^#^#^#^#^#^#^ORDER_ID#^#^#^#^#^#^#^#^"), 
    DOWN_EDTL_RULE("#EDTL^REQ_NO#^#^RAN_NO#^CLASSIDHSID#^#^ITEMNAME_EN#^#^BRANDNAME_EN#^#0^#0^#^#^#0^SUM_NETWEIGHTMEASURE#0^SUN_UT#KG^SUM_LINEITEMQUANTITY#0^LINEITEMQUANTITY_UC#^#^#^SUM_PACKAGINGQUANTITY#0^PACKAGINGQUANTITY_UC#^ORIGINLOCID#^#^#^#^#^ATT_YN#N^"),
    DOWN_EMDL_RULE("#EMDL^REQ_NO#^#^RAN_NO#^SIL#^#^ITEMNAME_EN#^#^#^#^#^#^#^#^COMP1#^COMP2#^LINEITEMQUANTITY#0^LINEITEMQUANTITY_UC#^BASEPRICEAMT#0^DECLARATIONAMOUNT#0^#^"),    
    
    EHDR("EHDR"), 
    EDTL("EDTL"), 
    EMDL("EMDL"), 
    
    UP("UP"), 
    DOWN("DOWN")
    ;
    
    private String key;
    CUSDEC830Rule(String key){
        this.key = key;
    }

    public String getCode(){
        return this.key;
    }
    
    public static String getRuleStr(String header, CUSDEC830Rule upDown) {
    	CUSDEC830Rule headerO = null;
        for (CUSDEC830Rule me : CUSDEC830Rule.values()) {
            if (me.name().equalsIgnoreCase(header)) {
            	headerO = me;
            	break;
            }
        }
        
        if(headerO == null) return null;
        
		return CUSDEC830Rule.getRuleStr(headerO, upDown);
    }
    
    public static String getRuleStr(CUSDEC830Rule header, CUSDEC830Rule upDown) {
		switch(upDown) {
			case UP : 
	    		switch(header) {
	    			case EHDR : return UP_EHDR_RULE.getCode();
	    			case EDTL : return UP_EDTL_RULE.getCode();
	    			case EMDL : return UP_EMDL_RULE.getCode();
					default: return null;
	    		}
			case DOWN : 
	    		switch(header) {
	    			case EHDR : return DOWN_EHDR_RULE.getCode();
	    			case EDTL : return DOWN_EDTL_RULE.getCode();
	    			case EMDL : return DOWN_EMDL_RULE.getCode();
					default: return null;
	    		}
			default: return null;		
    	}
    }
}