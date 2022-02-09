CLASS TestAccess 

	METHOD New()	CONSTRUCTOR 
	
	METHOD SetJWT()


ENDCLASS 

METHOD New(oC) CLASS TestAccess 

	//local oMid := oC:oMiddleware
	
	//o:Exec( oC, cVia, cType, cErrorView, hError, lJson, cMsg )
	//oMid:Exec(  'cookie', 'jwt', 'hello' )
	
	//_w( oMid )


RETU Self 

METHOD SetJWT( o ) CLASS TestAccess 

	

	? time(), 'Set JWT'
	_w( o )
	
	//o:oMiddleware:SetJWT()

RETU nil 
