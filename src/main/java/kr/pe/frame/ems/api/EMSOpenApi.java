package kr.pe.frame.ems.api;

import java.util.Map;

import kr.pe.frame.cmm.util.SEED128;
import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpMethodBase;
import org.apache.commons.httpclient.MultiThreadedHttpConnectionManager;
import org.apache.commons.httpclient.methods.GetMethod;
import org.apache.commons.httpclient.params.HttpConnectionManagerParams;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;

@Repository
public class EMSOpenApi {

    private static String EMS_PICKUP_REQ_URL;
    
    @Value("#{config['ems.pickup.req.url']}")
    private void setEMS_PICKUP_REQ_URL(String url) {
        EMS_PICKUP_REQ_URL = url;
    }
    
    public enum OpenApi {
        API001("http://eship.epost.go.kr:80/api.RetrieveEMSResDset.ems", "b7159149dbded7ff81482144047801", ""), // EMS 접수확인 정보
        API002("http://biz.epost.go.kr/KpostPortal/openapi", "b7159149dbded7ff81482144047801", "emsTrace"), // EMS 종추적
        API003(EMS_PICKUP_REQ_URL, "b7159149dbded7ff81482144047801", ""); // EMS 픽업요청

        private String url;
        private String reqKey;
        private String target;

        private OpenApi(String url, String reqKey, String target) {
            this.url = url;
            this.reqKey = reqKey;
            this.target = target;
        }
    }
    
    public static String getData(String apiId, Map<String, String> apiParams) throws Exception {
        OpenApi api = OpenApi.valueOf(StringUtils.defaultString(apiId));
        String url = "";
        if (apiId.equals("API001")) {
            url = api.url + "?" + encryptParams(api.reqKey, apiParams);
        } else if (apiId.equals("API002")) {
            apiParams.put("target", api.target);
            url = api.url + "?" + makeParams(api.reqKey, apiParams);
        } else if (apiId.equals("API003")) {
            url = api.url + "?" + encryptParams(api.reqKey, apiParams);
        }

        MultiThreadedHttpConnectionManager connectionManager = new MultiThreadedHttpConnectionManager();
        HttpConnectionManagerParams params = connectionManager.getParams();
        params.setConnectionTimeout(5000); // set connection timeout (how long it takes to connect to remote host)
        params.setSoTimeout(5000); // set socket timeout (how long it takes to retrieve data from remote host)

        HttpClient httpClient = new HttpClient(connectionManager);
        httpClient.getParams().setParameter("http.connection-manager.timeout", 5000L); // set timeout on how long we’ll wait for a connection from the pool

        HttpMethodBase baseMethod = new GetMethod(url);
        baseMethod.setRequestHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
        httpClient.executeMethod(baseMethod);
        return baseMethod.getResponseBodyAsString();
    }

    private static String encryptParams(String reqKey, Map<String, String> map) throws Exception {
        String encryptReqData = "";
        StringBuffer sb = new StringBuffer();
        for (String key : map.keySet()) {
            sb.append(key).append("=").append(map.get(key)).append("&");
        }
        String parsms = sb.substring(0, sb.length() - 1);
        SEED128 seed = new SEED128();
        encryptReqData = seed.getEncryptData(reqKey, parsms); // 평문 암호화
        return String.format("key=%s&regData=%s", reqKey, encryptReqData);
    }

    private static String makeParams(String reqKey, Map<String, String> map) {
        StringBuffer sb = new StringBuffer("regkey=").append(reqKey).append("&");
        for (String key : map.keySet()) {
            sb.append(key).append("=").append(map.get(key)).append("&");
        }

        return sb.substring(0, sb.length() - 1);
    }
}
