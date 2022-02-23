CLASS TestAccess 

	METHOD New()	CONSTRUCTOR 
	
	METHOD CreaToken()
	METHOD DelToken()
	
	METHOD Hello_Access()
	METHOD Check_JWT( oController ) 
	METHOD Check_Token( oController ) 

ENDCLASS 

METHOD New( oController ) CLASS TestAccess 
	
	//AUTENTICATE CONTROLLER oController 	
	//AUTENTICATE CONTROLLER oController  ERROR CODE 401
	//AUTENTICATE CONTROLLER oController  ERROR ROUTE 'xxx'
	//AUTENTICATE CONTROLLER oController  ERROR ROUTE 'unathorized'

	//AUTENTICATE CONTROLLER oController VIA 'cookie' TYPE 'token' ;
	//	ERROR ROUTE 'unathorized' EXCEPTION 'creatoken', 'deltoken'
		
	//oController:oMiddleware:cVia  	:= 'cookie'
	//oController:oMiddleware:cType  	:= 'token'
	//oController:oMiddleware:cargo 	:= 'pol'	+ str(hb_milliseconds())
		
RETU Self 

METHOD CreaToken( oController ) CLASS TestAccess 

	local hData := {=>}
	local cJwt, cToken 
	

	
//	? 'VIA', oController:oMiddleware:cVia 
//	? 'TYPE', oController:oMiddleware:cType
	
	
	hData[ 'id' ] 		:= 1234
	hData[ 'name' ] 	:= 'Carla Guttemberg'
	hData[ 'date' ] 	:= date()

	
	//oController:oMiddleware:SendToken( hData, 10, 'cookie', 'token' )
	//oController:oMiddleware:SendToken( hData, 10 )
	
	cJWT 	:= oController:oMiddleware:SetTokenJWT( hData )	
	cToken := oController:oMiddleware:SetToken( hData )
	
	_d( cJWT )
	_d( cToken )


	oController:View( 'token/token.view', 200, cJWT, cToken )
	

RETU nil 


METHOD DelToken( oController ) CLASS TestAccess 

	
	oController:oMiddleware:DeleteToken()

	??  'DeleteToken', time()
	

RETU nil 


METHOD Hello_Access( oController ) CLASS TestAccess 


	? 'VIA', oController:oMiddleware:cVia
	? 'TYPE', oController:oMiddleware:cType 

retu 

	?? '<h2>Hello access...</h2><hr>'
	
	? 'Now: ' + Time()
	
	? '<hr>'
	
	_w( oController:oMiddleware:GetData() )
	

RETU nil 


METHOD Check_JWT(oController ) CLASS TestAccess 

	local cToken := oController:Post( 'token' )
	local lValid, uData 	
	
	oController:oMiddleware:cType := 'jwt' 		
	
	lValid := oController:oMiddleware:ValidateJWT( cToken )
	uData  := oController:oMiddleware:GetData() 
	
	? 'VALID', lValid 
	? uData

	
	? oController:View( 'token/valid_token.view', 200, 'jwt', lValid, cToken, uData )

retu nil 

METHOD Check_Token(oController ) CLASS TestAccess 

	local cToken := oController:Post( 'token' )
	local lValid, uData 
	
	oController:oMiddleware:cType := 'token' 
	
	lValid := oController:oMiddleware:Validate( cToken )
	uData  := oController:oMiddleware:GetData() 

	oController:View( 'token/valid_token.view', 200, 'token', lValid, cToken, uData )

retu nil 