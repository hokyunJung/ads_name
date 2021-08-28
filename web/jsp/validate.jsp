<%@page import="kr.co.ecf.ads.name.NameServiceProperties"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.OutputStreamWriter"%>
<%@page import="java.net.URLConnection"%>
<%@page import="java.net.URL"%>
<%@page import="java.net.URLEncoder"%>
<%@ page import="org.apache.log4j.Logger" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
	Logger logger = Logger.getLogger("validate.jsp");
	request.setCharacterEncoding("utf-8");
	String peerRegNum = request.getParameter("peerRegNum");
	String name = request.getParameter("name");
	String idn = request.getParameter("idn");
	String mandatorName = request.getParameter("mandatorName");
	String mandatorIdn = request.getParameter("mandatorIdn");
	String isUnderAge = request.getParameter("isUnderAge");
	String ua= request.getHeader("User-Agent").toLowerCase();
	String data = "peerRegNum="+peerRegNum+"&"+
					"name="+name+"&"+
					"idn="+idn+"&"+
					"mandatorName="+mandatorName+"&"+
					"mandatorIdn="+mandatorIdn+"&"+
					"ua="+ua+"&"+
					"isUnderAge="+isUnderAge;
	
	String[] agree = request.getParameterValues("agree");	 
	
	logger.debug("name : " +name+ " ");
	logger.debug("개인정보 수집 및 이용에 대한 안내 동의 : " +agree[0]+ ", 개인정보 취급위탁 동의 : "+ agree[1]+ ", 고유식별정보처리 동의 : "+ agree[2]);
	
	NameServiceProperties nameServiceProperties = new NameServiceProperties();

	String target = nameServiceProperties.getProperties("ads.name.target");
	
	URL url = new URL(target);

	URLConnection conn = url.openConnection();
	conn.setDoOutput(true);
	
	OutputStreamWriter wr = new OutputStreamWriter(conn.getOutputStream());
	wr.write(data);
	wr.flush();
	
	BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
	StringBuffer sb = new StringBuffer();
	String line;
	
	while ((line = br.readLine()) != null) {
		sb.append(line);
	}
	
	out.print(sb.toString());
	
	wr.close();
	br.close();

%>