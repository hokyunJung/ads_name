var USING_CUSTOM_IMAGE = 0;
var CUSTOM_IMAGE_URL = "";
var USING_TouchEnKey = "1";		
 
var TouchEnKey_CLSID		= "clsid:6CE20149-ABE3-462E-A1B4-5B549971AA38";
var TouchEnKey_CODEBASE_x64 = "/name/cab/TouchEnkey3.1.0.32_64k.cab";
var TouchEnKey_CODEBASE_x86 = "/name/cab/TouchEnkey3.1.0.32_32k.cab";
var TouchEnKey_VERSION 		= "3,1,0,32";
var Multi_InstallBinary 	= "/name/cab/TouchEnKey_Installer_3.1.0.32_32bit.exe";
var Multi_InstallBinary_x64	= "/name/cab/TouchEnKey_Installer_3.1.0.32_64bit.exe"; // 64 bit IE only
var Multi_Version 			= "3.1.0.30";
var TouchEnKey_Installpage	= "/name/jsp/touchenkey/install.html";

var TouchEn_BaseBRW = {
	ua      : navigator.userAgent.toLowerCase(),
    ie      : navigator.appName == 'Microsoft Internet Explorer',
    ie_		: navigator.userAgent.match('MSIE') == 'MSIE',
    ns      : navigator.appName == 'Netscape',
    ff      : navigator.userAgent.match('Firefox') == 'Firefox',
    sf      : navigator.userAgent.match('Safari') == 'Safari',
    op      : navigator.userAgent.match('Opera') == 'Opera',
    cr      : navigator.userAgent.match('Chrome') == 'Chrome',
    win     : navigator.platform.match('Win') == 'Win',
    mac     : navigator.userAgent.match('Mac') == 'Mac',
    linux   : navigator.userAgent.match('Linux') == 'Linux',
    ie11		: navigator.userAgent.match('Trident/7.0') == 'Trident/7.0'
};

var getPluginType = {
    TouchEn_FFMIME      : ((TouchEn_BaseBRW.win) && (TouchEn_BaseBRW.ff ||TouchEn_BaseBRW.op)),
    TouchEn_SFMIME      : ((TouchEn_BaseBRW.win) && (TouchEn_BaseBRW.sf ||TouchEn_BaseBRW.cr)),
  	TouchEn_ACTIVEX   	: (TouchEn_BaseBRW.win && ( TouchEn_BaseBRW.ie || TouchEn_BaseBRW.ie11 || TouchEn_BaseBRW.ie_)),
    TouchEn_NPRUNTIME   : (TouchEn_BaseBRW.win && ((TouchEn_BaseBRW.ff || TouchEn_BaseBRW.sf || TouchEn_BaseBRW.cr) || TouchEn_BaseBRW.op)),
    TouchEn_OtherNP     : (TouchEn_BaseBRW.win && (TouchEn_BaseBRW.cr || TouchEn_BaseBRW.op)),
    TouchEn_OtherOS     : (TouchEn_BaseBRW.mac || TouchEn_BaseBRW.linux)
};


function checkTouchEnKeyMime() {
    if (getPluginType.TouchEn_NPRUNTIME) {
        var CKmType = navigator.plugins["TouchEn Key for Multi-Browser"];
        if (CKmType == undefined) {
            return false;
        } else {
            return true;
        }
    }
}

function PrintTouchEnKeyActiveXTag() {
    if(USING_TouchEnKey == "1") {
        var Str="";
        
        Str+= '<object classid="' + TouchEnKey_CLSID + '"';
        if(navigator.cpuClass.toLowerCase() == "x64")   {
            Str+= '\n\t codebase="' + TouchEnKey_CODEBASE_x64 + '#version=' + TouchEnKey_VERSION + '"';
        } else {
           Str+= '\n\t codebase="' + TouchEnKey_CODEBASE_x86 + '#version=' + TouchEnKey_VERSION + '"';
        }
        Str+= '\n\tvspace="0" hspace="0" width="0" id="TouchEnKey" style="display:none;">';
        Str+= '\n\t <PARAM name="PKI" value="TouchEnKeyEx">';
        Str+= '\n\t <PARAM name="DefaultEnc" value="Off">';
        Str+= '\n\t <PARAM name="DefaultPaste" value="On">';
        Str+= '\n\t <PARAM name="ClearBufferOnEmpty" value="true">';
        Str+= '\n\t <PARAM name="IgnoreProgress" value="on">';
        Str+= '\n\t <PARAM name="Verify" value="2">'; //Verify 0 , 1, 2
        Str+= '\n\t <PARAM name="KeyboardOnly" value="true">';
        if(USING_CUSTOM_IMAGE) {
            Str+= '\n\t <PARAM name="ImageURL" value="' + CUSTOM_IMAGE_URL + '">';
        }

        Str+= '</object>';
        document.write(Str);
    }
}

function PrintTouchEnKeyEmbedTag() {

    if(USING_TouchEnKey == "1") {
        var Str="";
        Str+= '<EMBED id="TouchEnKey" type="application/ClientKeeperKeyPro" width=0 height=0 ';
        if(USING_CUSTOM_IMAGE) {
            Str+= 'ImageURL="' + CUSTOM_IMAGE_URL + '" ';
        }
        Str+='PKI="TouchEnKeyEx"';
        Str+= 'TKFieldNotCheckPrefix="transkey_Tk_|transkey_"';
        Str+= 'RefreshSession="true"';
        Str+= 'DefaultPaste="off"';
        Str+= 'Verify="2"';
        Str+= '>';
        Str+= '</EMBED>';
        Str+= '<NOEMBED>no TouchEn Key</NOEMBED>';

        document.write(Str);
    }
}

function PrintTouchEnKeyTag() {
    if(getPluginType.TouchEn_ACTIVEX) {
        PrintTouchEnKeyActiveXTag();
    } else if(getPluginType.TouchEn_NPRUNTIME) {
        var mTypeRet = checkTouchEnKeyMime();
        if(mTypeRet) {
            PrintTouchEnKeyEmbedTag();
        } else {
           location.href = TouchEnKey_Installpage;
        }
    }
}

//===================== TouchEnKey Event function (Start) ==============================//

function triggerEvent(el,eventName,keycode){
	var htmlEvents = {
		onkeydown:1,
		onkeypress:1,
		onkeyup:1
	};
    var event;
    if(document.createEvent){
        event = document.createEvent('HTMLEvents');
        event.initEvent(eventName,true,true);
    }else if(document.createEventObject){// IE < 9
        event = document.createEventObject();
        event.eventType = eventName;
    }
    event.eventName = eventName;
	event.keyCode = keycode;
	event.which = keycode;
	
    if(el.dispatchEvent){
        el.dispatchEvent(event);
    }else if(el.fireEvent && htmlEvents['on'+eventName]){
        el.fireEvent('on'+event.eventType,event);
    }else if(el[eventName]){
        el[eventName]();
    }else if(el['on'+eventName]){
        el['on'+eventName]();
    }
}

function XecureCK_UIEevents(frm,ele,event,keycode) {
	TouchEnKey_UIEevents(frm,ele,event,keycode);

}

function TouchEnKey_UIEevents(frm,ele,event,keycode) {
 var obj;
    var e;
	if (navigator.userAgent.match('Trident/7.0') == 'Trident/7.0')
	{
		obj = document.activeElement;
		e = event.replace("on", "");		
		triggerEvent(obj, e, 120);
	}	
	else 
	{
		obj = document.activeElement;
		try {
			if( document.createEventObject )
			{
				eventObj = document.createEventObject();
				eventObj.keyCode=keycode;
				if(obj)
				{
					console.log(keycode);
					obj.fireEvent(event,eventObj);
				}
			}
			else if(document.createEvent) {
				if(window.KeyEvent) {
					
					e = document.createEvent('KeyEvents');
					e.initKeyEvent(event, true, true, window, false, false, false, false, keycode, 0);
				} else {
					e = document.createEvent('UIEvents');
					/*if(event=='keypress'){
						e.initUIEvent('input', true, true, window, 1);
						console.log('input');
					}*/					
					e.initUIEvent(event, true, true, window, 1);
					e.keyCode = keycode;
				}
				obj.dispatchEvent(e);
			} 
		} catch(e) {
		}	
	}
}
//===================== TouchEnKey Event function (End) ==============================//


//===================== TouchEnKey Multi Browser function (End) ==============================//
var CK_objFocused;
function CK_Start(nsEvent) {
    if(!getPluginType.TouchEn_NPRUNTIME) return;

    var theEvent;
    var inputObj;

    if(nsEvent.type == "text" || nsEvent.type == "password") {
        inputObj = nsEvent;
    } else {
        theEvent = nsEvent ? nsEvent : window.event;
        inputObj = theEvent.target ? theEvent.target : theEvent.srcElement;
    }

    try {
        document.getElementById('TouchEnKey').StartCK(inputObj);
        CK_objFocused = inputObj;
        CK_OP_IsStart = true;  
    } catch(e) {
    }
}

function CK_Stop() {
    if(!getPluginType.TouchEn_NPRUNTIME) return;

    try {
        document.getElementById('TouchEnKey').StopCK();
        CK_OP_IsStart = false;
    } catch(e) {
    }
}

function CK_PatchKey() {
    if(!getPluginType.TouchEn_NPRUNTIME) return;

    try {
        document.getElementById('TouchEnKey').PatchKey(CK_objFocused);
    } catch(e) {
    }
}

function CK_Blur() {
    if(!getPluginType.TouchEn_NPRUNTIME) return;

    try {
        CK_objFocused.blur();
    } catch(e) {
    }
}
function CK_Click(nsEvent) {
    var theEvent;
    var inputObj;

    if(nsEvent.type == "text" || nsEvent.type == "password") {
        inputObj = nsEvent;
    } else {
        theEvent = nsEvent ? nsEvent : window.event;
        inputObj = theEvent.target ? theEvent.target : theEvent.srcElement;
    }

}

function CK_KeyDown(nsEvent) {
    var theEvent;
    var inputObj;

    if(nsEvent.type == "text" || nsEvent.type == "password") {
        inputObj = nsEvent;
    } else {
        theEvent = nsEvent ? nsEvent : window.event;
        inputObj = theEvent.target ? theEvent.target : theEvent.srcElement;
    }
    if((typeof(inputObj.getAttribute("data-enc")) == "undefined") || (inputObj.getAttribute("data-enc") != "on")) return;
    
    if((theEvent.keyCode >= 35 && theEvent.keyCode <= 40)||(theEvent.keyCode == 46)) {
        if(theEvent.preventDefault) theEvent.preventDefault();
        if(theEvent.stopPropagation) theEvent.stopPropagation();

        theEvent.returnValue = false;
        theEvent.cancelBubble = true;

        return;
    }
}
function TouchEnKey_ApplySecurity() {
    if(!getPluginType.TouchEn_NPRUNTIME) return;
    try {
        for(var i=0;i<document.forms.length;i++) {
            for(var j=0;j < document.forms[i].elements.length;j++) {
                if(document.forms[i].elements[j].tagName == "INPUT" && (document.forms[i].elements[j].type == "text" || document.forms[i].elements[j].type == "password")) {
                    if(document.forms[i].elements[j].addEventListener){
                        document.forms[i].elements[j].addEventListener("focus", CK_Start, false);       //w3c
                        document.forms[i].elements[j].addEventListener("blur", CK_Stop, false);     //w3c
                        document.forms[i].elements[j].addEventListener("click", CK_Click, false);       //w3c
                        document.forms[i].elements[j].addEventListener("mouseup", CK_Click, false);     //w3c
                        document.forms[i].elements[j].addEventListener("keydown", CK_KeyDown, false);       //w3c ff/safari/chrome
                        document.forms[i].elements[j].addEventListener("keypress", CK_KeyDown, false);      //w3c opera
                    } else if(document.forms[i].elements[j].attachEvent) {
                        document.forms[i].elements[j].attachEvent("onfocus", CK_Start);                 //msdom
                        document.forms[i].elements[j].attachEvent("onblur", CK_Stop);//msdom
                    }
                }
            }
        }
    } catch(e) {
    }
}
function CK_ApplySecurity() {
    TouchEnKey_ApplySecurity();
}

//===================== TouchEnKey Multi Browser function (End) ==============================//


//===================== TouchEnKey dynamic input filed use this function (End) ==============================//

function TouchEnKey_ReScan() {
    if(USING_TouchEnKey == 1) {
        if(getPluginType.TouchEn_ACTIVEX) {
            var obj = document.getElementById("TouchEnKey");
            obj.ReScanDocument();
        } else {
            TouchEnKey_ApplySecurity();
        }
    }    
}

function TouchEnKey_EnqueueList(fname, iname)
{
	if(!getPluginType.TouchEn_ACTIVEX){
 	
  document.getElementById("TouchEnKey").ReScanDocument();

  } 
 if(document.TouchEnKey==null || typeof(document.TouchEnKey) == "undefined" || document.TouchEnKey.object==null) {
  
  return;
 }
 
 document.TouchEnKey.EnqueueList(fname, iname);
}

function TouchEnkey_EnqueueList_frm(frmname) {
 if(navigator.platform.match('Win') == 'Win'){
		if(!getPluginType.TouchEn_ACTIVEX) {
			CK_ApplySecurity();
	 		return;
		}
	}
 	var frm = document.getElementById(frmname);
 	var elelength = frm.elements.length;
	var fieldCnt = 0;	
	var name = new Array(elelength);
	for (var j=0;j < elelength;j++) {    	
		if(frm.elements[j].tagName == "INPUT" && (frm.elements[j].type == "text" || frm.elements[j].type == "password") && frm.elements[j].getAttribute("data-enc")=="on") {	  
			var elename = frm.elements[j].name;
			TouchEnKey_EnqueueList(frmname, elename);
		}
	}
}

/*
 * TouchEney install check function
 */
function isInstalledTouchEnKey() {
	var installed = false;
    if(!getPluginType.TouchEn_NPRUNTIME) {
        if(document.TouchEnKey==null || typeof(document.TouchEnKey) == "undefined" || document.TouchEnKey.object == null) {
            installed = false;
        } else {
            installed = true;
        }
    } else {
        if(checkTouchEnKeyMime()) {
            try {
                IsNeedUpdate = document.getElementById('TouchEnKey').NeedUpdate(Multi_Version);
                if(IsNeedUpdate==false) {
                     installed = true;
                } else {
                    installed = false;
                }
            } catch(e) {
                installed = false;
            }
        } else {
            installed = false;
        }
    }

    return installed;
}

/*
 * TouchEney Keyboard inpudata memory clear function
 */
function TouchEnKey_Clear(frmName,eleName) {
	try
	{
		var obj = document.getElementById("TouchEnKey");
	    obj.Clear(frmName, eleName, 0);
	}
	catch(e)
	{
	}
}

/*
 * TouchEnKey State Check function ( CapsLock, Shift )
 */
function GetKeyStateCheck(keyname){
	return document.getElementById('TouchEnKey').GetKeyState(keyname);
}


if(!TouchEn_BaseBRW.win || USING_TouchEnKey == 0 || (navigator.userAgent.indexOf("Opera") > -1 && navigator.userAgent.indexOf("Version/12.") > -1 )) {

} else {
    PrintTouchEnKeyTag();
    
    if(isInstalledTouchEnKey()) {
        TouchEnKey_ApplySecurity();
    } else {
    	location.href = TouchEnKey_Installpage;
    }
}
