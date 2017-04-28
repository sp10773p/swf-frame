package kr.pe.frame.cmm.util;

import java.io.FileInputStream;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.text.NumberFormat;
import java.util.Properties;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * String 객체 처리 Util
 * - ASIS 소스
 * @author ASIS
 * @since 2017-01-24
 * @version 1.0
 * @see
 *
 * <pre>
 * == 개정이력(Modification Information) ==
 *
 * 수정일      수정자  수정내용
 * ----------- ------- ---------------------------
 * 2017.01.24  성동훈  최초 생성
 * 2017.02.21  성동훈  System.out.println(e) -> logger.error("{}", e)
 * </pre>
 */

public class StringUtil extends StringUtils{
	private static Logger logger = LoggerFactory.getLogger(StringUtil.class);

	/**
	 * null 이거나 빈 문자열 체크
	 *
	 * @param input
	 *            문자열
	 * @return true : null 이거나 빈 문자열 <br>
	 *         false : 문자가 포함된 문자열
	 */
	public static boolean isEmpty(String input)
	{
		return input == null || input.trim().equals("");
	}

	/**
	 * 문자열의 Number형 문자열인지 여부
	 * (- 기호나 소수점도 포함)
	 *
	 * @param source 검증 하고자 하는 문자열
	 * @return 숫자형 문자열 여부 (true : 숫자형)
	 */
	public static boolean isNumber(String source)
	{
		if(isEmpty(source)) { return false; }

		try
		{
			Double db = new Double(source);
			return !db.isNaN();
		}
		catch(NumberFormatException ex)
		{
			return false;
		}
	}

	/**
	 * null을 빈 문자열로 바꾸고, 앞 뒤 공백 문자를 제거한다.
	 *
	 * @param input
	 *            문자열
	 * @return trim 처리된 문자열
	 */
	public static String verify(String input)
	{
		if(input == null) { return ""; }
		return input.trim();
	}

	/**
	 * 줄바꿈문자(\r\n)를 &ltbr/&gt;로 치환
	 *
	 * @param input
	 *            문자열
	 * @return &ltbr/&gt;로 치환된 문자열
	 */
	public static String toLine(String input)
	{
		return input.replaceAll("\r\n", "<br/>");
	}

	/**
	 * null 이거나 공백으로 이루어진 문자열을 빈 문자열로 치환
	 *
	 * @param input
	 *            문자열
	 * @return 치환된 문자열
	 */
	public static String toDB(String input)
	{
		if(isEmpty(input)) { return ""; }
		return input;
	}

	/**
	 * null 이거나 공백으로 이루어진 문자열을 빈 문자열로 치환
	 *
	 * @param input
	 *            문자열
	 * @return 치환된 문자열
	 */
	public static String fromDB(String input)
	{
		if(isEmpty(input)) { return ""; }
		return input;
	}

	/**
	 * 문자열을 줄임말 형태로 변환시에 사용 예) 게시판 리스트에서 제목을 보여줄때, 긴 제목은 잘라서 "..."을 붙여서 보여주는 경우에
	 * 사용 문자의 개수를 이용하여 처리하므로 한글과 영문/숫자의 경우 동일한 글자수를 보인다.
	 *
	 * @param str
	 *            문자열
	 * @param len
	 *            표시할 문자 개수
	 * @return 줄임말
	 */
	public static String toShortenString(String str, int len)
	{
		if(str.length() > len)
		{
			str = str.substring(0, len) + " ...";
		}
		return str;
	}

	/**
	 * 문자열을 줄임말 형태로 변환시에 사용 예) 게시판 리스트에서 제목을 보여줄때, 긴 제목은 잘라서 "..."을 붙여서 보여주는 경우에
	 * 사용 문자의 바이트 수를 이용하여 처리하므로 한글과 영문/숫자의 경우 다른 글자수를 보인다. 한글 일 경우 바이트 수가 초과되었을
	 * 때 초과된 문자를 포함 하지 않는다.
	 *
	 * @param str
	 *            문자열
	 * @param len
	 *            표시할 문자 개수
	 * @return 줄임말
	 */
	public static String toShortenStringB(String str, int len)
	{
		return toShortenStringB(str, len, '-');
	}

	/**
	 * 문자열을 줄임말 형태로 변환시에 사용 예) 게시판 리스트에서 제목을 보여줄때, 긴 제목은 잘라서 "..."을 붙여서 보여주는 경우에
	 * 사용 문자의 바이트 수를 이용하여 처리하므로 한글과 영문/숫자의 경우 다른 글자수를 보인다. 한글 일 경우 바이트 수가 초과되었을
	 * 때 초과된 문자를 포함 하지 않는다.
	 *
	 * @param str
	 *            문자열
	 * @param len
	 *            표시할 문자 개수
	 * @return 줄임말
	 */
	public static String toShortenStringMB(String str, int len)
	{
		return toShortenStringMB(str, len, '-');
	}

	/**
	 * 문자열을 줄임말 형태로 변환시에 사용 예) 게시판 리스트에서 제목을 보여줄때, 긴 제목은 잘라서 "..."을 붙여서 보여주는 경우에
	 * 사용 문자의 바이트 수를 이용하여 처리하므로 한글과 영문/숫자의 경우 다른 글자수를 보인다.
	 *
	 * @param str
	 *            문자열
	 * @param len
	 *            표시할 문자 개수
	 * @param type
	 *            [+|-] 반올림 유무
	 * @return 줄임말
	 */
	public static String toShortenStringB(String str, int len, char type)
	{
		byte[] bytes = str.getBytes();
		int lenArr = bytes.length;
		int counter = 0;

		if(len >= lenArr)
		{
			StringBuilder sb = new StringBuilder();
			sb.append(str);

			for(int i = 0; i < len - lenArr; i++)
			{
				sb.append(' ');
			}
			return sb.toString();
		}

		for(int i = len - 1; i >= 0; i--)
		{
			if(((int) bytes[i] & 0x80) != 0)
			{
				counter++;
			}
		}

		String result;
		if(type == '+' || type == '-')
		{
			result = new String(bytes, 0, len + (counter % 2));
		}
		else
		{
			result = new String(bytes, 0, len - (counter % 2));
		}
		result += "...";
		return result;
	}

	/**
	 * 문자열을 줄임말 형태로 변환시에 사용 예) 게시판 리스트에서 제목을 보여줄때, 긴 제목은 잘라서 "..."을 붙여서 보여주는 경우에
	 * 사용 문자의 바이트 수를 이용하여 처리하므로 한글과 영문/숫자의 경우 다른 글자수를 보인다.
	 *
	 * @param str
	 *            문자열
	 * @param len
	 *            표시할 문자 개수
	 * @param type
	 *            [+|-] 반올림 유무
	 * @return 줄임말
	 */
	public static String toShortenStringMB(String str, int len, char type)
	{
		byte[] bytes = str.getBytes();
		int lenArr = bytes.length;
		int counter = 0;

		if(len >= lenArr)
		{
			StringBuilder sb = new StringBuilder();
			sb.append(str);

			for(int i = 0; i < len - lenArr; i++)
			{
				sb.append(' ');
			}
			return sb.toString();
		}

		for(int i = len - 1; i >= 0; i--)
		{
			if(((int) bytes[i] & 0x80) != 0)
			{
				counter++;
			}
		}

		String result = new String(bytes, 0, len + (counter % 2));
		/*if(type == '+')
		{
			result = new String(bytes, 0, len + (counter % 2));
		}
		else if(type == '-')
		{
			result = new String(bytes, 0, len - (counter % 2));
		}
		else
		{
			result = new String(bytes, 0, len - (counter % 2));
		}*/
		result += "";
		return result;
	}

	/**
	 * 입력된 길이에 맞도록 문자열 좌측에 공백을 추가
	 *
	 * @param str
	 *            문자열
	 * @param len
	 *            공백이 채워진 문자열 전체 길이
	 * @return 공백이 추가된 문자열
	 */
	public static String lPad(String str, int len)
	{
		return pad(str, len, " ", 'l');
	}

	/**
	 * 입력된 길이에 맞도록 문자열 좌측에 특정 문자를 추가
	 *
	 * @param str
	 *            문자열
	 * @param len
	 *            특정 문자가 채워진 문자열 전체 길이
	 * @param addChar
	 *            채울 문자
	 * @return 특정 문자가 추가된 문자열
	 */
	public static String lPad(String str, int len, String addChar)
	{
		return pad(str, len, addChar, 'l');
	}

	/**
	 * 입력된 길이에 맞도록 문자열 우측에 공백을 추가
	 *
	 * @param str
	 *            문자열
	 * @param len
	 *            공백이 채워진 문자열 전체 길이
	 * @return 공백이 추가된 문자열
	 */
	public static String rPad(String str, int len)
	{
		return pad(str, len, " ", 'r');
	}

	/**
	 * 입력된 길이에 맞도록 문자열 우측에 특정 문자를 추가
	 *
	 * @param str
	 *            문자열
	 * @param len
	 *            특정 문자가 채워진 문자열 전체 길이
	 * @param plusStr
	 *            채울 문자
	 * @return 특정 문자가 추가된 문자열
	 */
	public static String rPad(String str, int len, String plusStr)
	{
		return pad(str, len, plusStr, 'r');
	}

	/**
	 * 입력된 길이에 맞도록 문자열의 특정 위치에 특정 문자를 추가
	 *
	 * @param str
	 *            문자열
	 * @param len
	 *            특정 문자가 채워진 문자열 전체 길이
	 * @param addChar
	 *            채울 문자
	 * @param position
	 *            채울 위치 [l|r]
	 * @return 특정 문자가 추가된 문자열
	 */
	public static String pad(String str, int len, String addChar, char position)
	{
		StringBuilder sb = new StringBuilder(str);
		if(position == 'l')
		{
			for(int i = 0; i < len - str.length(); i++)
			{
				sb.insert(0, addChar);
			}
		}
		else if(position == 'r')
		{
			for(int i = 0; i < len - str.length(); i++)
			{
				sb.append(addChar);
			}
		}
		return sb.toString();
	}

	/**
	 * 입력된 길이에 맞도록 문자열 우측에 공백을 추가. 내부적으로 바이트 단위로 처리
	 *
	 * @param str
	 *            문자열
	 * @param len
	 *            공백이 채워진 문자열 전체 길이
	 * @return 공백이 추가된 문자열
	 */
	public static String rPadB(String str, int len)
	{
		return padB(str, len, '0', 'r');
	}

	/**
	 * 입력된 길이에 맞도록 문자열 좌측에 공백을 추가. 내부적으로 바이트 단위로 처리
	 *
	 * @param str
	 *            문자열
	 * @param len
	 *            공백이 채워진 문자열 전체 길이
	 * @return 공백이 추가된 문자열
	 */
	public static String lPadB(String str, int len)
	{
		return padB(str, len, '0', 'l');
	}

	/**
	 * 입력된 길이에 맞도록 문자열의 특정 위치에 특정 문자를 추가 내부적으로 바이트 단위로 처리
	 *
	 * @param str
	 *            문자열
	 * @param len
	 *            특정 문자가 채워진 문자열 전체 길이
	 * @param addChar
	 *            채울 문자
	 * @param position
	 *            채울 위치 [l|r]
	 * @return 특정 문자가 추가된 문자열
	 */
	public static String padB(String str, int len, char addChar, char position)
	{
		StringBuilder sb = new StringBuilder(str);
		int lenB = lengthB(str);
		if(position == 'l')
		{
			for(int i = 0; i < len - lenB; i++)
			{
				sb.insert(0, addChar);
			}
		}
		else if(position == 'r')
		{
			for(int i = 0; i < len - lenB; i++)
			{
				sb.append(addChar);
			}
		}
		return sb.toString();
	}

	/**
	 * 문자열을 바이트 길이를 리턴
	 *
	 * @param str
	 *            문자열
	 * @return 문자열의 바이트 길이
	 */
	private static int lengthB(String str)
	{
		return str.getBytes().length;
	}

	/**
	 * 문자열 좌측의 공백을 제거
	 *
	 * @param str
	 *            문자열
	 * @return 공백이 제거된 문자열
	 */
	public static String lTrim(String str)
	{
		return str.replaceAll("^\\s+", "");
	}

	/**
	 * 문자열 좌측의 공백 및 특정 문자열을 제거
	 *
	 * @param str
	 *            문자열
	 * @param delStr
	 *            삭제 할 문자열
	 * @return 공백 및 삭제 대상이 제거된 문자열
	 */
	public static String lTrim(String str, String delStr)
	{
		return str.replaceAll("^\\s+" + delStr, "");
	}

	/**
	 * 문자열 우측의 공백을 제거
	 *
	 * @param str
	 *            문자열
	 * @return 공백이 제거된 문자열
	 */
	public static String rTrim(String str)
	{
		return str.replaceAll("\\s+$", "");
	}

	/**
	 * 문자열 우측의 공백 및 특정 문자열을 제거
	 *
	 * @param str
	 *            문자열
	 * @param delStr
	 *            삭제 할 문자열
	 * @return 공백 및 삭제 대상이 제거된 문자열
	 */
	public static String rTrim(String str, String delStr)
	{
		return str.replaceAll("\\s+$", "").replaceAll(delStr + "+$", "");
	}

	/**
	 * 스트링을 잘라낸다, 만일 index가 범위를 벗어나면, ""값을 리턴.
	 *
	 * @param str
	 *            문자열
	 * @param start
	 *            시작위치
	 * @param end
	 *            종료위치
	 * @return 잘라진 문자열
	 */
	public static String substring(String str, int start, int end)
	{
		String retVal = "";
		if(isEmpty(str)) { return retVal; }

		try
		{
			retVal = str.substring(start, end);
		}
		catch(Exception e)
		{
			retVal = "";
		}
		return retVal;
	}

	/**
	 * 문자열의 특정 위치에 구분자를 삽입한다. split("20030516","46","-") ==> "2003-05-16"
	 *
	 * @param str
	 *            문자열
	 * @param position
	 *            삽입 위치. 가까운 순서로 입력. 예) "4|6|8" >> 4번째문자뒤/6번째문자뒤/8번째문자뒤
	 * @param delim
	 *            구분자
	 * @return 구분자가 삽입된 문자열
	 */
	public static String addDelim(String str, String position, String delim)
	{
		if(isEmpty(str)) { return str; }

		int beforePos = 0;
		int currentPos;
		StringBuffer result = new StringBuffer();
		String[] posArr = position.split("\\|");

		for (String aPosArr : posArr) {
			if (!isEmpty(aPosArr)) {
				currentPos = Integer.parseInt(aPosArr);
				if (currentPos <= str.length()) {
					result.append(str.substring(beforePos, currentPos)).append(delim);
					beforePos = currentPos;
				}
			}
		}
		result.append(str.substring(beforePos));

		return result.toString();
	}

	/**
	 * 정해진 크기의 공백 문자열를 리턴
	 *
	 * @param len
	 *            공백 크기
	 * @return 공백 문자열
	 */
	public static String getSpace(int len)
	{
		StringBuilder retVal = new StringBuilder(len);

		for(int i = 0; i < len; i++)
		{
			retVal.append(" ");
		}
		return retVal.toString();
	}

	/**
	 * 원하는 문자열 배열을 "" 로 초기화시켜서 리턴한다.
	 *
	 * @param size
	 *            배열의 길이.
	 * @return 빈 문자열로 초기화된 String객체 배열.
	 */
	public static String[] getStrArray(int size)
	{
		String[] arrName = new String[size];
		for(int i = 0; i < size; i++)
		{
			arrName[i] = "";
		}
		return arrName;
	}

	/**
	 * 배열에서 특정 문자열이 저장된 인덱스를 리턴
	 *
	 * @param arr
	 *            체크할 배열
	 * @param str
	 *            체크할 문자열
	 * @return 배열이 특정 문자를 원소로 가지고 있으면 첫번째 인덱스, 포함하지 않으면 -1.
	 */
	public static int existStr(String[] arr, String str)
	{
		for(int i = 0; i < arr.length; i++)
		{
			if(arr[i].equals(str)) { return i; }
		}
		return -1;
	}

	/**
	 * chr로 시작되어 줄바꿈/탭/공백 문자로 끝나는 문자열을 찾아서 리턴
	 *
	 * @param str
	 *            대상 문자열
	 * @param chr
	 *            시작 문자
	 * @return chr가 제거된 문자열
	 */
	public static String getToken(String str, String chr)
	{
		StringBuffer rtn = new StringBuffer();
		int index = str.indexOf(chr);

		if(index > -1)
		{
			for(int i = index + 1; i < str.length(); i++)
			{
				if(str.substring(i, i + 1).matches("\\s"))
				{
					break;
				}
				rtn.append(str.substring(i, i + 1));
			}
		}

		return rtn.toString();
	}

	/**
	 * 서버에 저장된 프로퍼티 파일을 로드한다.
	 *
	 * @param fileName
	 *            프로퍼티 파일명
	 * @return Properties 객체
	 */
	public static Properties getPropertiesFromFile(String fileName)
	{
		Properties pro = null;
		InputStream inputStream = null;

		try
		{
			pro = new Properties();
			inputStream = new FileInputStream(fileName);
			pro.load(inputStream);

		}
		catch(Exception e)
		{
			logger.error("{}", e);
		}
		finally
		{
			IOUtils.closeQuietly(inputStream);
		}
		return pro;
	}

	/**
	 * 문자열이 null이거나 값이 없을 경우 변환하여 return
	 *
	 * @param original
	 *            체크 문자열
	 * @param toStr
	 *            null이거나 빈문자열일 경우 치환될 문자열
	 * @return String 처리된 문자열
	 */
	public static String nvl(String original, String toStr)
	{
		if(original == null || original.equals("")) { return toStr; }
		return original;
	}

	/**
	 * 문자열이 null이거나 값이 없을 경우 변환하여 return
	 *
	 * @param original
	 *            체크 문자열
	 * @param toStr
	 *            null이거나 빈문자열일 경우 치환될 문자열
	 * @return String 처리된 문자열
	 */
	public static String nvl(Object original, String toStr)
	{
		if(original == null || original.toString().equals("")) { return toStr; }
		return original.toString();
	}

	/**
	 * BASE64 Encoder
	 *
	 * @param str
	 *            BASE64로 인코딩할 문자열
	 * @return BASE64로 인코딩된 문자열
	 */
	public static String encodeBASE64(String str)
	{
		String result = "";

		try
		{
			result = Base64.encodeBase64String(str.getBytes("UTF-8")).replaceAll("[^A-Za-z0-9=/+]", "");
		}
		catch(Exception e)
		{
			logger.error("{}", e);
		}
		return result;
	}

	/**
	 * BASE64 Decoder
	 *
	 * @param str
	 *            BASE64로 디코딩할 문자열
	 * @return BASE64로 디코딩될 문자열
	 */
	public static String decodeBASE64(String str)
	{
		String result = "";

		try
		{
			byte[] b1 = Base64.decodeBase64(str);
			result = new String(b1, "UTF-8");
		}
		catch(Exception e)
		{
			logger.error("{}", e);
		}
		return result;
	}

	/**
	 * euc-kr -> UTF-8
	 *
	 * @param str
	 *            euc-kr로 인코딩된 문자열
	 * @return UTF-8로 인코딩된 문자열
	 */
	public static String K2U(String str)
	{
		String result = "";

		try
		{
			result = new String(str.getBytes("EUC-KR"), "UTF-8");
		}
		catch(UnsupportedEncodingException e)
		{
			logger.error("{}", e);
		}
		return result;
	}

	/**
	 * UTF-8 -> euc-kr
	 *
	 * @param str
	 *            utf-8로 인코딩된 문자열
	 * @return euc-kr로 인코딩된 문자열
	 */
	public static String U2K(String str)
	{
		String result = "";

		try
		{
			result = new String(str.getBytes("UTF-8"), "EUC-KR");
		}
		catch(UnsupportedEncodingException e)
		{
			logger.error("{}", e);
		}
		return result;
	}

	public static String null2Str(Object value)
	{
		return value != null ? value.toString() : "";
	}

	public static int null2Int(Object value)
	{
		if(value == null) return 0;

		try
		{
			return Integer.parseInt(value.toString());
		}
		catch(Exception e)
		{
			return 0;
		}
	}

	public static double null2Double(Object value)
	{
		if(value == null) return 0;

		try
		{
			return Double.parseDouble(value.toString());
		}
		catch(Exception e)
		{
			return 0;
		}
	}

	/**
	 * 문자열을 콤마및 소수점을 삽입하고 리턴
	 *
	 * @param amt 변환할 금액
	 * @param dec 소수점 자리수
	 * @return String 포맷 문자열
	 */
	public static String getNumberFormat(String amt, int dec){
		String result;
		try {
			NumberFormat nf = NumberFormat.getInstance();
			nf.setMaximumFractionDigits(dec);
			result = nf.format(Double.parseDouble(amt));
		} catch (Exception e) {
			result = "0";
		}
		return result;
	}

	/**
	 * 문자열을 콤마및 소수점을 삽입하고 리턴
	 *
	 * @param amt 변환할 금액
	 * @return String 포맷 문자열
	 */
	public static String getNumberFormat(String amt){
		return getNumberFormat(amt, 0);
	}

	/**
	 * 문자열이 null, "null"일 경우 빈문자열 return
	 *
	 * @param value 체크 문자열
	 * @return String 처리된 문자열("")
	 */
	public static String nullToStr2(Object value)
	{
		if(value == null || value.toString().equals("null")) return "";
		return value.toString();
	}

	/**
	 * 반각문자를 전각문자로 변환
	 * @param src
	 * @param bytes
	 * @return
	 */
	public static String getFullChar(String src, int bytes){

		int len = bytes / 2;

		// 변환된 문자들을 쌓아놓을 StringBuffer 를 마련한다
		StringBuilder strBuf = new StringBuilder();
		char c;
		int nSrcLength = src.length();
		for (int i = 0; i < nSrcLength; i++) {
			c = src.charAt(i);
			// 영문이거나 특수 문자 일경우.
			if (c >= 0x21 && c <= 0x7e) {
				c += 0xfee0;
			}
			// 공백일경우
			else if (c == 0x20) {
				c = 0x3000;
			}
			// 문자열 버퍼에 변환된 문자를 쌓는다
			strBuf.append(c);
		}

		return StringUtil.rPad(strBuf.toString(), len, "\u3000");

	}
}
