CLASS MyClass 

	METHOD New()	CONSTRUCTOR 
	
	METHOD Info()	

ENDCLASS 

//	--------------------------------------------------	//

METHOD New( oController ) CLASS MyClass 

	AUTENTICATE CONTROLLER oController
	
RETU Self 

//	--------------------------------------------------	//

METHOD Info( oController ) CLASS MyClass 

	?? '<b>Version</b>', mc_Version()
	
	? '<hr>'
	? "If you can try to delete cookie and refresh screen, you can't access to ::Info() method."

RETU NIL
