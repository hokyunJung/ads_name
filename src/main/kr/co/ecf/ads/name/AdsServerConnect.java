package kr.co.ecf.ads.name;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;

public class AdsServerConnect {
	
	
	NameServiceProperties nameServiceProperties = new NameServiceProperties();
	
	String target = null;
	
	public AdsServerConnect() {
		this.target = nameServiceProperties.getProperties("ads.name.target");
	}
	
	public HttpURLConnection connect(String target) {
		
		URL url = null;	
		HttpURLConnection connection = null;
		
		try {
			url = new URL(target);
		} catch (MalformedURLException e) {
			e.printStackTrace();
		}
		
		try {
			connection = (HttpURLConnection) url.openConnection();
			connection.getResponseCode();
		} catch (IOException e) {
			e.printStackTrace();
		}
				
		return connection;
	}

	public String getPeers() {
		String target = this.target+"getPeers/";
		HttpURLConnection con = connect(target);
		
		
		StringBuffer sb = new StringBuffer();
		String line;
		int code = 0;
		BufferedReader in = null;
		try {
			code = con.getResponseCode();
			in = new BufferedReader(new InputStreamReader(con.getInputStream()));
			
			while ((line = in.readLine()) != null) {
				sb.append(line);
			}
			
			in.close();
		} catch (IOException e) {
			e.printStackTrace();
			return "error code : " + code + " in " + e.getMessage();
		} finally {
			//if (in != null) {
			//	in.close();
			//}
			if (con != null) {
				con.disconnect();
			}
			
		}

		con = null;
		
		return sb.toString();
	}
	
/*	public String validateName(String data) {
		HttpURLConnection con = connect(this.target);
		
		try {
			con.setRequestMethod("POST");
		} catch (ProtocolException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		con.setDoOutput(true);

		OutputStreamWriter wr = null;
		try {
			wr = new OutputStreamWriter(con.getOutputStream());
			wr.write(data);
			wr.flush();
			wr.close();
		} catch (IOException e) {
			e.printStackTrace();
		}

		
		BufferedReader br = null;
		StringBuffer sb = new StringBuffer();
		String line;
		
		try {
			br = new BufferedReader(new InputStreamReader(con.getInputStream(), "UTF-8"));

			while ((line = br.readLine()) != null) {
				sb.append(line);
			}
			
			br.close();

		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}	
		
		return sb.toString();
	}*/
	
}
