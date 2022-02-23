CLASS TestAccess 

	METHOD New()	CONSTRUCTOR 
	
	METHOD CreaJWT()
	METHOD ValidJWT()
	METHOD DelJWT()
	
ENDCLASS 

METHOD New( oController ) CLASS TestAccess 
	
	//AUTENTICATE CONTROLLER oController 	;
		
	
	AUTENTICATE CONTROLLER oController ;
		ERROR ROUTE 'unathorized' ;
		EXCEPTION 'CreaJwt'				
	
	//	ERROR CODE 401		//	Default 401
	

	//oController:oMiddleware:cargo 	:= 'pol'	+ str(hb_milliseconds())
		
RETU Self 

METHOD CreaJWT( oController ) CLASS TestAccess 

	local hData 	:= {=>}
	local nTime	:= 10 	
	local cJwt 	
	
	hData[ 'id' ] 		:= 1234
	hData[ 'name' ] 	:= 'Carla Guttemberg'
	hData[ 'date' ] 	:= date()
	hData[ 'admin' ] 	:= .t.

	cJWT 	:= oController:oMiddleware:SetTokenJWT( hData, nTime )	
	
	
	?? '<h3>Authentication JWT Created!</h3><hr>' 
	? 'Time(sec) validate: ', nTime 
	? 'Token', cJWT 
	? '<hr>'
	? '<a href="' + mc_Route( 'token.validjwt' ) + '">Valid Token JWT</a>'
	? '<a href="' + mc_Route( 'token.deljwt' ) + '">Delete Token JWT</a>'

RETU nil 


METHOD ValidJWT( oController ) CLASS TestAccess 

	?? '<h3>Authentication JWT Validated!</h3><hr>'
	
	_w( oController:oMiddleware:GetData() )	
	
	? 'cargo', oController:oMiddleware:cargo

RETU nil 


METHOD DelJWT( oController ) CLASS TestAccess 
	
	oController:oMiddleware:DeleteToken()

	?? '<h3>Authentication JWT Deleted!</h3><hr>'

retu nil 