<%@page import="org.apache.log4j.Logger"%>
<%@page import="kr.co.ecf.ads.name.AdsServerConnect"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
if (request.getProtocol().equals("HTTP/1.1")) {
	response.setHeader("Cache-Control", "no-cache");
} else {
	response.setHeader("Cache-Control", "no-store");
}

	String time = new Date().toString();
	String ua=request.getHeader("User-Agent").toLowerCase();
		
	if (ua.matches(".*(android|avantgo|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|ad)|iris|kindle|lge |maemo|midp|mmp|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\\/|plucker|pocket|psp|symbian|treo|up\\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino).*")||ua.substring(0,4).matches("1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\\-(n|u)|c55\\/|capi|ccwa|cdm\\-|cell|chtm|cldc|cmd\\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\\-s|devi|dica|dmob|do(c|p)o|ds(12|\\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\\-|_)|g1 u|g560|gene|gf\\-5|g\\-mo|go(\\.w|od)|gr(ad|un)|haie|hcit|hd\\-(m|p|t)|hei\\-|hi(pt|ta)|hp( i|ip)|hs\\-c|ht(c(\\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\\-(20|go|ma)|i230|iac( |\\-|\\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\\/)|klon|kpt |kwc\\-|kyo(c|k)|le(no|xi)|lg( g|\\/(k|l|u)|50|54|e\\-|e\\/|\\-[a-w])|libw|lynx|m1\\-w|m3ga|m50\\/|ma(te|ui|xo)|mc(01|21|ca)|m\\-cr|me(di|rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\\-2|po(ck|rt|se)|prox|psio|pt\\-g|qa\\-a|qc(07|12|21|32|60|\\-[2-7]|i\\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\\-|oo|p\\-)|sdk\\/|se(c(\\-|0|1)|47|mc|nd|ri)|sgh\\-|shar|sie(\\-|m)|sk\\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\\-|v\\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\\-|tdg\\-|tel(i|m)|tim\\-|t\\-mo|to(pl|sh)|ts(70|m\\-|m3|m5)|tx\\-9|up(\\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|xda(\\-|2|g)|yas\\-|your|zeto|zte\\-")) {
		pageContext.forward("./index_mobile.jsp");
	}
		
	String isDisabled = request.getParameter("isDisabled");

	if ("true".equals(isDisabled)) {
		pageContext.forward("./index_disabled.jsp");
	}
%>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml"  dir="ltr" lang="ko">
<head>
<meta http-equiv="Content-type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge;" >
<script type="text/javascript" src="./js/jquery-1.8.3.min.js?<%=time%>" charset="UTF-8"></script>
<script type="text/javascript" src="./js/jquery-ui.min.js?<%=time%>" charset="UTF-8"></script>
<script type="text/javascript" src="./js/keyboard/jquery.keyboard.min.js?<%=time%>" charset="UTF-8"></script>
<script type="text/javascript" src="./js/keyboard/jquery.keyboard.extension-all.min.js?<%=time%>" charset="UTF-8"></script>
<link rel="stylesheet" type="text/css" href="./css/style.css?<%=time%>" charset="UTF-8"/>
<link rel="stylesheet" type="text/css" href="./css/jquery-ui-1.9.2.css?<%=time%>" title="ui-theme" charset="UTF-8"/>
<link rel="stylesheet" type="text/css" href="./css/keyboard.css?<%=time%>" charset="UTF-8"/>

<script type="text/javascript">
<%!
static Logger log = Logger.getLogger("index.jsp"); 
%>
<%

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

function makeKeyboard(id, length) {
	$('#'+id).keyboard({
		layout : 'num',
		preventPaste : true,
		lockInput    : true,
		autoAccept : true,
		maxLength: length
	}).addScramble({
		byRow         : true,      // randomize by row, otherwise randomize all keys
		randomizeOnce : false       // if false, randomize every time the keyboard opens
	});
}

$(document).ready(function() {
	$("#agreeAll").click(function(){
				var chk = $(this).is(":checked");//.attr('checked');
				if(chk) {
					$(":checkbox").attr('checked', true);
				} else {
					$("input").attr('checked', false);
				}
		});

	$(':checkbox').click(function() {
		if ($("input:checkbox[id='agree1']").is(":checked") &&
				$("input:checkbox[id='agree2']").is(":checked") &&
				$("input:checkbox[id='agree3']").is(":checked")
		) {
			$("input:checkbox[id='agreeAll']").attr('checked', true);
		} else {
			$("input:checkbox[id='agreeAll']").attr('checked', false);
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

	if (!$("input:checkbox[id='agreeAll']").is(":checked")) {
		alert('약관을 확인해 주세요.');
		return false;
	}

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
		},
		error: function(request, status, error) {
			alert("code : " + request.status + "\n" + "message : " + request.responseText+ "\n" + "error : " + error);
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
	var month = parseInt(ssn.substr(2,2), 10);
	var day = parseInt(ssn.substr(4,2), 10);
	
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
	} else if(ssn.substr(6,1) == 5 || ssn.substr(6,1) == 6 || ssn.substr(6,1) == 7 || ssn.substr(6,1) == 8) {
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
	window.open(url, 'agree', 'width=450, height=550, top=100, left=100, fullscreen=no, menubar=no, status=no, toolbar=no, titlebar=yes, location=no, scrollbar=yes');
}
</script>


<title>한국인터넷진흥원 실명확인 서비스</title>
<style type="text/css">
body { margin-left: 0px; margin-top: 0px; margin-right: 0px; margin-bottom: 0px; }
.wrap {width:400px; margin:0 auto;}
#top {width:100%; height:30px; margin-top:10px; margin-bottom:20px;}
#body {width:100%; height:320px; margin-bottom:5px;}
#bottom {clear:both;width:100%;}
</style>
</head>
<body class="wrap">

<div id="top">
	<img alt="공인전자주소 등록자 실명확인" src="./img/h1_logo.gif">
</div>
<div id="body">
		<table class="FieldTable_Search" style="width: 100%;">
			<tbody>
				<tr>
					<td class="FieldLabel_L_Search" style="width: 120px;"><label for="name">성명</label></td>
					<td class="FieldData_L_Search">
						<input type="text" value="" id="name" name="name" size=23 style="margin-left : 3px; width:187px; border: 1px solid #a6c9e2; background: #fcfdfd url(./img/ui-bg_inset-hard_100_fcfdfd_1x100.png) 50% bottom repeat-x; color: #222222;" value=""></td>
				</tr>
				<tr>
					<td class="FieldLabel_L_Search" ><label for="idn1">주민등록번호</label></td>
					<td class="FieldData_L_Search">
					<input type="password" value="" id="idn1" name="idn1" style="margin-left : 3px; width:85px;" title="주민등록번호 앞자리"> -<input type="password" value="" id="idn2" name="idn2" style="margin-left : 3px; width:85px;" title="주민등록번호 뒷자리">
					</td>
				</tr>
				<tr>
					<td class="FieldData_NONE_Search" colspan=2>&nbsp;</td>
				</tr>
				<tr id="mandator0">
					<td class="FieldData_NONE_Search" colspan=2>* 공인전자주소 신청자가 14세 미만 아동일 경우, 대리인이 필요합니다.</td>
				</tr>
				<tr id="mandator1">
					<td class="FieldLabel_L_Search"><label for="mandatorName">대리인 성명</label></td>
					<td class="FieldData_L_Search">
						<input type="text" id="mandatorName" name="mandatorName" style="margin-left : 3px; width:187px; border: 1px solid #a6c9e2; background: #fcfdfd url(./img/ui-bg_inset-hard_100_fcfdfd_1x100.png) 50% bottom repeat-x; color: #222222;">
					</td>
				</tr>
				<tr id="mandator2">
					<td class="FieldLabel_L_Search"><label for="mandatorIdn1">대리인 주민등록번호</label></td>
					<td class="FieldData_L_Search">
						<input type="password" id="mandatorIdn1" name="mandatorIdn1" style="margin-left : 3px; width:85px;" title="주민등록번호 앞"></input> -<input type="password" id="mandatorIdn2" name="mandatorIdn2" style="margin-left : 3px; width:85px;" title="주민등록번호 뒷자리"></input>
					</td>
				</tr>
			</tbody>
		</table>
		<table class="FieldTable_Search" style="width: 100%; margin: 5px 0px 5px 0px;">
			<tbody>
				<tr>
					<td class="FieldData_NONE_Search" style="vertical-align: middle;" align="left">
						<input type="checkbox" id="agree1" name='agree' value="Y" style="vertical-align:-2px;"><label for="agree1">개인정보 수집 및 이용에 대한 안내</label> <button style="height: 20px; width: 75px; font-size:11px; line-height: 5px;" onclick="showAgree('agree1');" title="새창열림 - 개인정보 수집 및 이용에 대한 안내">전문보기</button>
					</td>
				</tr>
				<tr>
					<td class="FieldData_NONE_Search" style="vertical-align: middle;" align="left">
						<input type="checkbox" id="agree2" name='agree' value="Y" style="vertical-align:-2px;"><label for="agree2">개인정보 취급위탁</label> <button style="height: 20px; width: 75px; font-size:11px; line-height: 5px;" onclick="showAgree('agree2');" title="새창열림 - 개인정보 취급위탁">전문보기</button><br>
					</td>
				</tr>
				<tr>
					<td class="FieldData_NONE_Search" style="vertical-align: middle;" align="left">
						<input type="checkbox" id="agree3" name='agree' value="Y" style="vertical-align:-2px;"><label for="agree3">고유식별정보처리 동의</label> <button style="height: 20px; width: 75px; font-size:11px; line-height: 5px;" onclick="showAgree('agree3');" title="새창열림 - 고유식별정보처리 동의">전문보기</button>
					</td>
				</tr>
				<tr>
					<td class="FieldData_NONE_Search" style="vertical-align: middle; " align="center">
						<input type="checkbox" id="agreeAll" style="vertical-align:-2px;"><label for="agreeAll">위 약관에 전체 동의합니다.</label>
					</td>
				</tr>
				<tr>
					<td style="vertical-align: middle; padding: 10px 0px 0px 0px;" align="center"><button onclick="validateNameAndIdn()" style="cursor: pointer;">실명확인</button></td>
				</tr>
			</tbody>
		</table>
		<table style="width: 100%; margin: 10px 0px 0px 0px;">
			<tbody>
				<tr>
					<td><font style="font-size:10px;">* 「전자문서 및 전자거래기본법」시행령 제22조의3(고유식별번호의 처리) 및 시행규칙 제1조의3(공인전자주소의 등록신청)에 따라 개인정보는 한국인터넷진흥원에 보관됩니다.</font></td>
				</tr>
			</tbody>
		</table>
</div>
<div id="bottom">
<font style="font-size:10px; font-family:굴림; color: #767676;">(우)58324 전라남도 나주시 진흥길9 한국인터넷진흥원  Tel : 1544-5776</font><br>
<font style="font-size:10px; font-family:굴림; color: #767676;">e메일 : npost@kisa.or.kr&nbsp;&nbsp;&nbsp;#메일 : 공인전자주소팀#한국인터넷진흥원.법인</font><br>
<img alt="한국인터넷진흥원" src="./img/footer_logo.gif" align="bottom" style="padding-top:5px;"></img>
<img alt="copyright KISA All Rights Reserved" src="./img/footer_copyright.gif" align="bottom" style="padding-left:60px;"></img>
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