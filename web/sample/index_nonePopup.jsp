<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<meta http-equiv="Content-type" content="text/html; charset=utf-8" />
<title>공인전자주소</title>
<script>
</script>
</head>
<body>
	<form name="resultFormValue">
		<div align=center style="padding: 50px 0px 0px 0px;">
			<b>공인전자주소 등록대행기관 실명인증 요청페이지</b>
			<table style="padding: 10px 0px 10px 0px;">
				<tr>
					<td>실명확인 코드</td>
					<td><input type="text" name="authCode"
						value="<%=request.getParameter("authCode")%>" size="50"></td>
				</tr>
				<tr>
					<td>성명</td>
					<td><input type="text" name="name"
						value="<%=request.getParameter("name")%>" size="50"></td>
				</tr>
				<tr>
					<td>아동여부</td>
					<td><input type="text" name="isUnderAge"
						value="<%=request.getParameter("isUnderAge")%>" size="50"></td>
				</tr>
				<tr>
					<td>대리인 성명</td>
					<td><input type="text" name="mandatorName"
						value="<%=request.getParameter("mandatorName")%>" size="50"></td>
				</tr>
				<tr>
					<td>해쉬</td>
					<td><input type="text" name="nameAndIdn"
						value="<%=request.getParameter("nameAndIdn")%>" size="50"></td>
				</tr>
			</table>
	</form>

	<a
		href="https://test.npost.kr/ads/jsp/authName/index.jsp?successPage=http://192.168.34.77:8080/index.jsp&peerRegNum=0000000024">aaaa</a>
	</div>
</body>
</html>


