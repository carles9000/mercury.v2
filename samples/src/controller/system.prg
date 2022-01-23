CLASS System 

	METHOD New()	CONSTRUCTOR 
	
	METHOD Routes()
	

ENDCLASS 

METHOD New() CLASS System 


RETU Self 

METHOD Routes( oApp, hParam ) CLASS System 
	
	oApp:oRouter:Show()	

RETU nil 
