package kr.co.ecf.ads.name;

import java.util.ResourceBundle;

public class NameServiceProperties {

	ResourceBundle resourceBundle;
	
	String propertyName;
	
	public NameServiceProperties() {
		this.propertyName = "name";
		resourceBundle = ResourceBundle.getBundle(this.propertyName);
	}
	
	public NameServiceProperties(String propertyName) {
		this.propertyName = propertyName;
		resourceBundle = ResourceBundle.getBundle(this.propertyName);
		
	}
	
	public String getProperties (String key) {
		String value = (String) resourceBundle.getString(key);
		
		return value;
	}
	
}
