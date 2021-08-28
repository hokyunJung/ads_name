<%@page import="org.apache.log4j.Logger"%>
<%@page import="kr.co.ecf.ads.name.AdsServerConnect"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String time = new Date().toString();
%>


<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml"  dir="ltr">
<head>
<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width, height=device-height">
<link rel="stylesheet" href="./css/jquery.mobile.min.css">
<script type="text/javascript" src="./js/jquery-1.8.3.min.js?<%=time%>" charset="UTF-8"></script>
<script type="text/javascript" src="./js/jquery.mobile.min.js?<%=time%>"></script>
<script type="text/javascript" src="./js/jquery-ui.min.js?<%=time%>"></script>
<script type="text/javascript" src="./js/keyboard/jquery.keyboard.min.js?<%=time%>"></script>
<script type="text/javascript" src="./js/keyboard/jquery.keyboard.extension-all.min.js?<%=time%>"></script>
<link rel="stylesheet" type="text/css" href="./css/jquery-ui-1.9.2.css?<%=time%>" title="ui-theme" />
<link rel="stylesheet" type="text/css" href="./css/m_keyboard.css?<%=time%>"/>

<script type="text/javascript">
<%!
static Logger log = Logger.getLogger("index_mobile.jsp"); 
%>
<%
	String ua=request.getHeader("User-Agent").toLowerCase();
	
	String peerRegNum = request.getParameter("peerRegNum");
	String isPopup = request.getParameter("isPopup");
	
	log.info("peerRegNum = " + peerRegNum);
	log.info("user-agent: " + ua);
	log.info("isPopup = " + isPopup);
	
	AdsServerConnect adsServerConnect = new AdsServerConnect();
	
	if (peerRegNum != null) {
		
		String peers = adsServerConnect.getPeers();
		
		Boolean isServerError = peers.contains("error");
		if(isServerError) {
			out.print("alert('"+peers+"');");
			if ("false".equals(isPopup)) {
				out.print("history.back();");
			} else {
				out.print("window.close();");
			}
			out.print("</script>");
			return;
		}
		
		
		Boolean isEnableAuthName = peers.contains(peerRegNum);
		
		if(!isEnableAuthName || peerRegNum.length() != 10) {
			%>
			alert('실명확인 가능한 사업자가 아닙니다.');
			<%
			if ("false".equals(isPopup)) {
				out.print("history.back();");
			} else {
				out.print("window.close();");
			}
			out.print("</script>");
			return;
		}
	} else {
			%>
			alert('중계자만 이용할 수 있습니다.');
			<%
			if ("false".equals(isPopup)) {
				out.print("history.back();");
			} else {
				out.print("window.close();");
			}
			out.print("</script>");
			return;
	}
%>
var rsaPublicKeyModulus;
var rsaPublicKeyExponent;
var peerRegNum = '<%=peerRegNum%>';
var isPopup = '<%=isPopup%>';


function makeKeyboard(id, length) {
	$('#'+id).keyboard({
		layout : 'num',
		preventPaste : true,
		lockInput    : true,
		autoAccept : true,
		keyBinding   : 'touchend',
		maxLength: length
	}).addScramble({
		byRow         : true,      // randomize by row, otherwise randomize all keys
		randomizeOnce : false       // if false, randomize every time the keyboard opens
	});
}

$(document).ready(function() {
	$("#agreeAll").click(function(){
				var chk = $(this).prop("checked");//.attr('checked');
				if(chk) {
					$(":checkbox").prop('checked', true).checkboxradio('refresh');
				} else {
					$(":checkbox").prop('checked', false).checkboxradio('refresh');
				}
		});

	$(':checkbox').click(function() {
		if ($("input:checkbox[id='agree1']").prop("checked") &&
				$("input:checkbox[id='agree2']").prop("checked") &&
				$("input:checkbox[id='agree3']").prop("checked")
		) {
			$("input:checkbox[id='agreeAll']").prop('checked', true).checkboxradio('refresh');
		} else {
			$("input:checkbox[id='agreeAll']").prop('checked', false).checkboxradio('refresh');
		}
	});


	$('#mandator0').hide();
	$('#mandator1').hide();
	$('#mandator2').hide();

	makeKeyboard('idn1', 6);
	makeKeyboard('idn2', 7);
	makeKeyboard('mandatorIdn1', 6);
	makeKeyboard('mandatorIdn2', 7);
});


function validateNameAndIdn() {
	if(!checkIdnForm()) return;

	var name = $('#name').val();
	var idn1 = $('#idn1').val();
	var idn2 = $('#idn2').val();

	var idn = idn1+idn2;

	var isValid = checkSSN(idn);
	if (!isValid) {
		var reverseIdn = reverseString(idn1);
		reverseIdn += reverseString(idn2);

		isValid = checkSSN(reverseIdn)
		if (isValid) {
			idn = reverseIdn;
		} else {
			alert("주민등록번호 형식 체계가 올바르지 않습니다.");
			return;
		}
	}

	var mandatorIdn = "";
	var mandatorName = "";

	var isUnderAge = checkIsUnderAge(idn);
	if (isUnderAge) {

		$('#mandator0').show();
		$('#mandator1').show();
		$('#mandator2').show();

		if (!checkMandatorForm()) return;

		mandatorName = $('#mandatorName').val();
		var mandatorIdn1 = $('#mandatorIdn1').val();
		var mandatorIdn2 = $('#mandatorIdn2').val();

		mandatorIdn = mandatorIdn1+mandatorIdn2;

		var isValid = checkSSN(mandatorIdn);
		if (!isValid) {
			var reverseIdn = reverseString(mandatorIdn1);
			reverseIdn += reverseString(mandatorIdn2);

			isValid = checkSSN(reverseIdn)
			if (isValid) {
				mandatorIdn = reverseIdn;
			} else {
				alert("대리인의 주민등록번호 형식 체계가 올바르지 않습니다.");
				return;
			}
		}

		if(checkIsUnderAge(mandatorIdn)){
			alert('대리인의 법정나이는 만 19세 이상이여야 합니다.');
			return false;
		}

	} else {
		$('#mandator0').hide();
		$('#mandator1').hide();
		$('#mandator2').hide();
	}

	if (!$("input:checkbox[id='agreeAll']").prop("checked")) {
		alert('약관을 확인해 주세요.');
		return false;
	}

	name = encodeURI(name);
	mandatorName = encodeURI(mandatorName);

	$.ajax({
		url : "./jsp/validate.jsp",
		type : "post",
		data: "name="+name+"&idn="+idn+"&mandatorName="+mandatorName+"&mandatorIdn="+mandatorIdn+"&isUnderAge="+isUnderAge+"&peerRegNum="+peerRegNum,
		dataType: 'json',
		timeout : 30000,
		async: false,
		beforeSend: function(xhr) {
			xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
			},
		success: function(data, textStatus, jqXHR) {
			if (data.finalResult == "true") {
				fnLoad(data.tempAuthNum, data.name, data.isUnderAge, data.mandatorName, data.nameAndIdnHash, data.finalResult, data.authResultMessage, data.existRaddress);
			} else {
				var failMessage = (data.authResultMessage == '' ? data.mandatorAuthResultMessage : data.authResultMessage);
				//fnLoad('', '', '', '', '', data.finalResult, failMessage, '');
				if (failMessage != "") {
					alert(failMessage);
					<%
					if ("false".equals(isPopup)) {
						out.print("history.back();");
					} else {
						out.print("window.close();");
					}
					%>
				}
			}
		}
	});

}

function reverseString(str){
	var reverseStr = "";
	for (var i=0; i<str.length; i++) {
		reverseStr +=str.substr((str.length-1)-i,1);
	}
	return reverseStr;
}

function checkIdnForm() {
	var name = $('#name').val();
	var idn1 = $('#idn1').val();
	var idn2 = $('#idn2').val();

	if(name == '') {
		alert('본인의 성명을 입력해 주십시오.');
		return false;
	}

	if(idn1 === '' && idn2 ==='') {
		alert('주민등록번호를 입력하세요.');
		return false;
	}
	if(idn1 != '' || idn2 !='') {
		if(idn1.length != 6) {
			alert('주민등록번호 앞자리를 정확히 입력해 주십시오.');
			return false;
		}
		if(idn2.length != 7) {
			alert('주민등록번호 뒷자리를 정확히 입력해 주십시오.');
			return false;
		}
	}

	return true;
}

function checkMandatorForm() {

	var mandatorName = $('#mandatorName').val();
	var mandatorIdn1 = $('#mandatorIdn1').val();
	var mandatorIdn2 = $('#mandatorIdn2').val();

	if(mandatorName == '') {
		alert('대리인의 성명을 입력해 주십시오.');
		return false;
	}

	if(mandatorIdn1 === '' && mandatorIdn2 ==='') {
		alert('대리인의 주민등록번호를 입력하세요.');
		return false;
	}
	if(mandatorIdn1 != '' || mandatorIdn2 !='') {
		if(mandatorIdn1.length != 6) {
			alert('대리인의 주민등록번호 앞자리를 정확히 입력해 주십시오.');
			return false;
		}
		if(mandatorIdn2.length != 7) {
			alert('대리인의 주민등록번호 뒷자리를 정확히 입력해 주십시오.');
			return false;
		}
	}
	return true;
}

function checkIsUnderAge(idn) {

	var isUnderAge = false;
	Now = new Date();    //현재 연도를 구함

	NowYear = Now.getFullYear(); //나이를 구하는 함수 시작

	var n1=idn.substr(0,2);      //앞 6자리에 입력한 값중 앞에서 두글자를 n1 에 대입
	var n2=idn.substr(6,1);      //뒤 7자리에 입력한 값중 맨앞의 글자를 n2 에 대입( 1~4)

	if (n2 === '1' || n2 === '2' || n2 === '3' || n2 === '4') {
		var age = 0;
		if((n2==1)||(n2==2)){     //뒤 첫째값이 1, 2일 경우(1900년대에 출생한 남녀)
			age = (NowYear-(1900 + Number(n1)));
		}
		if ((n2==3)||(n2==4)){     //뒤 첫째값이 3, 4일 경우
			age = (NowYear-(2000 + Number(n1)));
		}

		if (Number(age) >  1 && Number(age) <=  14 ){     // 아동
			isUnderAge = true;
		}
	}

	return isUnderAge;
}

function checkSSN(ssn) {
	var sum = 0;
	var month = ssn.substr(2,2);
	var day = ssn.substr(4,2);

	if(ssn.length != 13) {
		return false;
	}

	//월의 경우 13월을 넘지 않아야 한다.
	if((month < 13 && month > 0) && (day > 0 && day < 32)) {
		//2월의 경우
		if(month == 2 && day > 29) {
			//2월 29일을 넘지 않아야 한다.
			return false;
		} else if((month == 4 || month == 6 || month == 9 || month == 11) && day > 30){
			// 4,6,9,11월의 경우 30일을 넘지 않아야 한다.
			return false;
		} else if ((month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) && day > 31) {
			// 4,6,9,11월의 경우 31일을 넘지 않아야 한다.
			return false;
		}

	} else {
		return false;
	}

	for(var i = 0; i < 12; i++) {
		sum += Number(ssn.substr(i, 1)) * ((i % 8) + 2);
	}

	if(ssn.substr(6,1) == 1 || ssn.substr(6,1) == 2 || ssn.substr(6,1) == 3 || ssn.substr(6,1) == 4) {
		//내국인 주민번호 검증(1900(남/여) 2000(남/여))
		if(((11 - (sum % 11)) % 10) == Number(ssn.substr(12,1))) {
				return true;
			}
			return false;
	}else if(ssn.substr(6,1) == 5 || ssn.substr(6,1) == 6 || ssn.substr(6,1) == 7 || ssn.substr(6,1) == 8) {
		//외국인 주민번호 검증(1900(남/여) 2000(남/여))
			if(Number(ssn.substr(8,1)) % 2 != 0) {
				return false;
			}
			if((((11 - (sum % 11)) % 10 + 2) % 10) == Number(ssn.substr(12, 1))){
			return true;
		}
			return false;
	} else {
		return false;
	}
	return true;  //정상 주민번호
}

function fnLoad(authCode, name, isUnderAge, mandatorName, nameAndIdn, result, resultMessage, existRaddress){
	document.form1.action='<%=request.getParameter("successPage")%>'
	document.form1.authCode.value = authCode;
	document.form1.name.value = name;
	document.form1.isUnderAge.value = isUnderAge;
	document.form1.mandatorName.value = mandatorName;
	document.form1.nameAndIdn.value = nameAndIdn;
	document.form1.result.value = result;
	document.form1.resultMessage.value = resultMessage;
	document.form1.existRaddress.value = existRaddress;
	document.form1.submit();
}

function showAgree(id) {
	var url = './jsp/'+id+'.html';
	window.open(url, 'agree', 'width=450, height=400, top=100, left=100, fullscreen=no, menubar=no, status=no, toolbar=no, titlebar=yes, location=no, scrollbar=yes');
}
</script>
<style type="text/css">
.ui-block-a {
	width:75% !important;
}
.ui-block-b {
	width:25% !important;
}
</style>
<title>한국인터넷진흥원 실명확인 서비스</title>
</head>
<body>
<div data-role="page" data-theme="d">
	<div data-role="header" data-theme="f">
		<img alt="실명인증 서비스" src="./img/m_h1_logo.gif">
	</div>

	<div data-role="content" data-theme="d">
		<table width=100% border="0">
			<tbody>
				<tr>
					<td style="vertical-align: middle;">성명</td>
					<td colspan=2 style=""><input type="text" id="name" name="name" style="font-size: 20px;" value=""></td>
				</tr>
				<tr>
					<td  style="vertical-align: middle;">주민등록번호</td>
					<td  style="width:25%;">
						<input type="password" id="idn1" name="idn1" style="font-size: 20px;" value="">
					</td>
					<td  style="width:25%;">
						<input type="password" id="idn2" name="idn2" style="font-size: 20px;" value="">
					</td>
				</tr>
				<tr>
					<td style="vertical-align: middle;" colspan=2>&nbsp;</td>
				</tr>
				<tr id="mandator0">
					<td style="vertical-align: middle;" colspan=3>* 공인전자주소 신청자가 14세 미만 아동일 경우, 대리인이 필요합니다.</td>
				</tr>
				<tr id="mandator1">
					<td  style="vertical-align: middle;">대리인 성명</td>
					<td colspan=2 style="vertical-align: middle;">
						<input type="text" id="mandatorName"	name="mandatorName" style="margin-left : 3px;">
					</td>
				</tr>
				<tr id="mandator2">
					<td  style="vertical-align: middle;">대리인 주민등록번호</td>
					<td>
						<input type="password" id="mandatorIdn1" name="mandatorIdn1" style="margin-left : 3px;">
					</td>
					<td>
						<input type="password" id="mandatorIdn2" name="mandatorIdn2" style="margin-left : 3px;">
					</td>
				</tr>
			</tbody>
		</table>

		<div class="ui-grid-a">
			<div class="ui-block-a">
				<label for="agree1">
					<input type="checkbox" id="agree1">
					개인정보 수집 및 이용안내
				</label>
			</div>
			<div class="ui-block-b">
				<button onclick="showAgree('agree1');">보기</button>
			</div>
		</div>
			
			
		<div class="ui-grid-a">
			<div class="ui-block-a">
				<label for="agree2">
					개인정보 취급위탁
					<input type="checkbox" id="agree2">
				</label>
			</div>
			<div class="ui-block-b">
				<button onclick="showAgree('agree2');">보기</button>
			</div>
		</div>
			
		<div class="ui-grid-a">
			<div class="ui-block-a">
				<label for="agree3">
					<input type="checkbox" id="agree3">
					고유식별정보처리 동의
					</label>
			</div>
			<div class="ui-block-b">
				<button onclick="showAgree('agree3');">보기</button>
			</div>
		</div>
			

		<div class="ui-grid-solo">
			<label for="agreeAll"><input type="checkbox" id="agreeAll">위 약관에 전체 동의합니다.</label>
		</div>

		<div class="ui-grid-solo">
				<button onclick="validateNameAndIdn()" style="cursor: pointer;">실명확인</button>
		</div>
			




						
						
						

						
						

						
	
					
						

					 	
	

						
						

					


		<table width=100% border="0">
			<tbody>
				<tr>
					<td><font style="font-size:12px;">* 「전자문서 및 전자거래 기본법」시행규칙 제1조의3(공인전자주소의 등록신청)에 따라 개인정보는 한국인터넷진흥원에 보관됩니다.</font></td>
				</tr>
			</tbody>
		</table>
</div>

	<div data-role="footer" data-theme="f">
		<font style="font-size:11px; font-family:맑은고딕; color: #767676;">(우)58324 전라남도 나주시 진흥길9 한국인터넷진흥원  Tel : 1544-5776</font><br>
	<font style="font-size:11px; font-family:맑은고딕; color: #767676;">e메일 : npost@kisa.or.kr&nbsp;&nbsp;&nbsp;#메일 : 공인전자주소팀#한국인터넷진흥원.법인</font><br>
	<img alt="실명인증 서비스" src="./img/m_footer_logo.gif" align="bottom" style="padding-top:5px;"></img>
	<img alt="실명인증 서비스" src="./img/m_footer_copyright.gif" align="bottom" style="padding-left:60px;"></img>
	</div>
</div>
<form name='form1' method='post'>
<input type='hidden' name='authCode'  value=''>
<input type='hidden' name='name' value=''>
<input type='hidden' name='isUnderAge' value=''>
<input type='hidden' name='mandatorName' value=''>
<input type='hidden' name='nameAndIdn' value=''>
<input type='hidden' name='result' value=''>
<input type='hidden' name='resultMessage' value=''>
<input type='hidden' name='existRaddress' value=''>
</form>
</body>
</html>