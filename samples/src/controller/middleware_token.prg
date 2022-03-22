CLASS Middleware_Token 

	METHOD New()	CONSTRUCTOR 
	
	METHOD Create()
	METHOD Validate()
	METHOD Del()
	
ENDCLASS 

METHOD New( oController ) CLASS Middleware_Token 

	//	A efectos de test, como en el index.prg tenemos ya un DEFINE CREDENTIALS que actua 
	// 	por defecto, coje los parametros definidos. Pero como tenemos varios ejemplos 
	// 	de token, definimos para este prg como debe actuar
	//	En principio, solo definimos un tipo de autenticacion en el index y no deberiamos 
	//	definirlo aqui...

		DEFINE CREDENTIALS VIA 'cookie' TYPE 'token' NAME 'CHARLES-2022' PSW 'Babe@2022' ;
			REDIRECT 'unathorized' TIME 5
			
	//	------------------------------------------------------------------------------

	AUTENTICATE CONTROLLER oController EXCEPTION 'Create'	

RETU Self 

METHOD Create( oController ) CLASS Middleware_Token 

	local hData 	:= {=>}
	local nTime	:= 10 	
	local cToken 	

	hData[ 'id' ] 		:= 1234
	hData[ 'name' ] 	:= 'Carla Guttemberg'
	hData[ 'date' ] 	:= date()
	hData[ 'admin' ] 	:= .t.

	
	CREATE TOKEN cToken OF oController WITH hData TIME nTime 
	
	
	?? '<h3>Authentication Token Created!</h3><hr>' 
	? 'Token', cToken 
	? '<hr>'
	? '<a href="' + mc_Route( 'token.validatetoken' ) + '">Valid Token</a>'
	? '<a href="' + mc_Route( 'token.deltoken' ) + '">Delete Token</a>'

RETU nil 


 
METHOD Validate( oController ) CLASS Middleware_Token 

	local hData

	GET TOKEN DATA hData OF oController
	
	?? '<h3>Authentication Token Validated!</h3><hr>'	
	
	_w( hData )	

RETU nil 


METHOD Del( oController ) CLASS Middleware_Token 

	CLOSE TOKEN OF oController

	?? '<h3>Authentication Token Deleted!</h3><hr>'

retu nil 