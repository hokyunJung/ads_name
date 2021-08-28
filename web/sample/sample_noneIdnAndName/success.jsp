<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<html>
<head>
<script type="text/javascript" language="javascript">
	opener.window.confirm(
			'<%=request.getParameter("authCode")%>',
			'<%=request.getParameter("name")%>',
			'<%=request.getParameter("isUnderAge")%>',
			'<%=request.getParameter("mandatorName")%>');
	self.close();
</script>
</head>
<body>
</body>
</html>
