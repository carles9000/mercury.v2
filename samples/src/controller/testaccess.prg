CLASS TestAccess 

	METHOD New()	CONSTRUCTOR 
	
	METHOD CreaToken()
	METHOD DelToken()
	
	METHOD Hello_Access()


ENDCLASS 

METHOD New( oController ) CLASS TestAccess 
	
	AUTENTICATE CONTROLLER oController VIA 'cookie' TYPE 'jwt' ;
		ERROR ROUTE 'unathorized' EXCEPTION 'creatoken', 'deltoken'
		
RETU Self 

METHOD CreaToken( oController ) CLASS TestAccess 

	
	oController:oMiddleware:SendToken()

	?  'SendToken', time()
	

RETU nil 


METHOD DelToken( oController ) CLASS TestAccess 

	
	oController:oMiddleware:DeleteToken()

	?  'DeleteToken', time()
	

RETU nil 


METHOD Hello_Access( oController ) CLASS TestAccess 


	?? '<h2>Hello access...</h2><hr>'
	
	? 'Now: ' + Time()
	

RETU nil 