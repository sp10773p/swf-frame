package kr.pe.frame.cmm.core.base;

import java.util.Map;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpMethodBase;
import org.apache.commons.httpclient.MultiThreadedHttpConnectionManager;
import org.apache.commons.httpclient.methods.GetMethod;
import org.apache.commons.httpclient.params.HttpConnectionManagerParams;

public class CustomsOpenApi {
	public enum OpenApi {
		API001("https://unipass.customs.go.kr:38010/ext/rest/cargCsclPrgsInfoQry/retrieveCargCsclPrgsInfo", "r250l136u092q262l080a030j1"),                 // 화물통관 진행정보
		API002("https://unipass.customs.go.kr:38010/ext/rest/expDclrNoPrExpFfmnBrkdQry/retrieveExpDclrNoPrExpFfmnBrkd", "s240z166u002h262f000u080w0"),     // 수출신고번호별 수출이행 내역
		API003("https://unipass.customs.go.kr:38010/ext/rest/xtrnUserReqApreBrkdQry/retrieveXtrnUserReqApreBrkd", "w210h126z052g272a020g040f1"),           // 수출입요건 승인 내역
		API004("https://unipass.customs.go.kr:38010/ext/rest/xtrnUserInscQuanBrkdQry/retrieveXtrnUserInscQuanBrkd", "z280e166o022o292t000s070n0"),         // 검사검역 내역
		API005("https://unipass.customs.go.kr:38010/ext/rest/shedInfoQry/retrieveShedInfo", "v200c166l012v282q000k010q1"),                                 // 장치장 정보
		API006("https://unipass.customs.go.kr:38010/ext/rest/frwrLstQry/retrieveFrwrLst", "f280f126o022v242b090t080i1"),                                   // 화물운송주선업자 목록
		API007("https://unipass.customs.go.kr:38010/ext/rest/frwrBrkdQry/retrieveFrwrBrkd", "u230m116m042m272y040s050d1"),                                 // 화물운송주선업자 내역
		API008("https://unipass.customs.go.kr:38010/ext/rest/flcoLstQry/retrieveFlcoLst", "g270t126c062b242i070r060g1"),                                   // 항공사 목록
		API009("https://unipass.customs.go.kr:38010/ext/rest/flcoBrkdQry/retrieveFlcoBrkd", "j270q106d052c242b010e010o1"),                                 // 항공사 내역
		API010("https://unipass.customs.go.kr:38010/ext/rest/ecmQry/retrieveEcm", "x200c116n092a212f090w010o1"),                                           // 통관고유부호
		API011("https://unipass.customs.go.kr:38010/ext/rest/ovrsSplrSgnQry/retrieveOvrsSplrSgn", "l250a106d032z232k030m060g1"),                           // 해외공급자부호
		API012("https://unipass.customs.go.kr:38010/ext/rest/trifFxrtInfoQry/retrieveTrifFxrtInfo", "h240d186u022r212k060r050v0"),                         // 관세환율 정보
		API013("https://unipass.customs.go.kr:38010/ext/rest/lcaLstInfoQry/retrieveLcaBrkd", "j200e166y072w282h040f050r0"),                                // 관세사 목록
		API014("https://unipass.customs.go.kr:38010/ext/rest/lcaBrkdQry/retrieveLcaBrkd", "z220d186r012g262q060t000j0"),                                   // 관세사 내역
		API015("https://unipass.customs.go.kr:38010/ext/rest/simlXamrttXtrnUserQry/retrieveSimlXamrttXtrnUser", "e240i196m072o212i020b050x0"),             // 간이정액 환급율표
		API016("https://unipass.customs.go.kr:38010/ext/rest/simlFxamtAplyNnaplyEntsQry/retrieveSimlFxamtAplyNnaplyEnts", "x230x116u052j272d010i000e0"),   // 간이정액 적용/비적용 업체
		API017("https://unipass.customs.go.kr:38010/ext/rest/expFfmnPridShrtTrgtPrlstQry/retrieveExpFfmnPridShrtTrgtPrlst", "t210v146x012n222o030e040g0"), // 수출이행기간 단축대상 품목
		API018("https://unipass.customs.go.kr:38010/ext/rest/hsSgnQry/searchHsSgn", "r290e136n072b222o070t010h0"),                                         // HS부호
		API019("https://unipass.customs.go.kr:38010/ext/rest/statsSgnQry/retrieveStatsSgnBrkd", "j230f116z032w222l020g050j1"),                             // 통계부호
		API020("https://unipass.customs.go.kr:38010/ext/rest/cntrQryBrkdQry/retrieveCntrQryBrkd", ""),                                                     // 컨테이너내역조회
		API021("https://unipass.customs.go.kr:38010/ext/rest/etprRprtQryBrkdQry/retrieveetprRprtQryBrkd", "");                                             // 입항보고내역조회

		private String url;
		private String crkyCn;

		private OpenApi(String url, String crkyCn) {
			this.url = url;
			this.crkyCn = crkyCn;
		}
	}

	public static String getData(String apiId, Map<String, String> apiParams) throws Exception {
		OpenApi api = OpenApi.valueOf(apiId);
		String url = api.url + "?" + makeParamStr(api.crkyCn, apiParams);

		MultiThreadedHttpConnectionManager connectionManager =  new MultiThreadedHttpConnectionManager();
		HttpConnectionManagerParams params = connectionManager.getParams();
		params.setConnectionTimeout(5000); // set connection timeout (how long it takes to connect to remote host)
		params.setSoTimeout(5000); // set socket timeout (how long it takes to retrieve data from remote host)

		HttpClient httpClient = new HttpClient(connectionManager);
		httpClient.getParams().setParameter("http.connection-manager.timeout", 5000L); // set timeout on how long we’ll wait for a connection from the pool

		HttpMethodBase baseMethod = new GetMethod(url);
		httpClient.executeMethod(baseMethod);

		return new String(baseMethod.getResponseBodyAsString().getBytes("8859_1"), "utf-8");
	}

	private static String makeParamStr(String crkyCn, Map<String, String> map) {
		StringBuffer sb = new StringBuffer("crkyCn=").append(crkyCn).append("&");
		for (String key : map.keySet()) {
			sb.append(key).append("=").append(map.get(key)).append("&");
		}

		return sb.substring(0, sb.length() - 1);
	}
}
