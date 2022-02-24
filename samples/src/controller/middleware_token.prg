CLASS Middleware_Token 

	METHOD New()	CONSTRUCTOR 
	
	METHOD CreaToken()
	METHOD ValidToken()
	METHOD DelToken()
	
ENDCLASS 

METHOD New( oController ) CLASS Middleware_Token 
	
	//AUTENTICATE CONTROLLER oController 	;
	

	AUTENTICATE CONTROLLER oController ;
		VIA 'cookie' TYPE 'token' ;
		ERROR ROUTE 'unathorized' ;
		EXCEPTION 'CreaToken'				

	//	ERROR CODE 401		//	Default 401
	

	//oController:oMiddleware:cargo 	:= 'pol'	+ str(hb_milliseconds())


RETU Self 

METHOD CreaToken( oController ) CLASS Middleware_Token 

	local hData 	:= {=>}
	local nTime	:= 10 	
	local cToken 	

	hData[ 'id' ] 		:= 1234
	hData[ 'name' ] 	:= 'Carla Guttemberg'
	hData[ 'date' ] 	:= date()
	hData[ 'admin' ] 	:= .t.

	cToken 	:= oController:oMiddleware:SetToken( hData )	
	
	
	?? '<h3>Authentication Token Created!</h3><hr>' 
	? 'Token', cToken 
	? '<hr>'
	? '<a href="' + mc_Route( 'token.validtoken' ) + '">Valid Token</a>'
	? '<a href="' + mc_Route( 'token.deltoken' ) + '">Delete Token</a>'

RETU nil 


 
METHOD ValidToken( oController ) CLASS Middleware_Token 


	?? '<h3>Authentication Token Validated!</h3><hr>'
	
	_w( oController:oMiddleware:GetData() )	
	
	//? 'cargo', oController:oMiddleware:cargo

RETU nil 


METHOD DelToken( oController ) CLASS Middleware_Token 
	
	oController:oMiddleware:DeleteToken()

	?? '<h3>Authentication Token Deleted!</h3><hr>'

retu nil 