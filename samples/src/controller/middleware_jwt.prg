CLASS Middleware_JWT 

	METHOD New()	CONSTRUCTOR 
	
	METHOD Create()
	METHOD Validate()
	METHOD Del()
	
ENDCLASS 

METHOD New( oController ) CLASS Middleware_JWT 

	//	A efectos de test, como en el index.prg tenemos ya un DEFINE CREDENTIALS que actua 
	// 	por defecto, coje los parametros definidos. Pero como tenemos varios ejemplos 
	// 	de token, definimos para este prg como debe actuar
	//	En principio, solo definimos un tipo de autenticacion en el index y no deberiamos 
	//	definirlo aqui...	

		DEFINE CREDENTIALS VIA 'cookie' TYPE 'jwt' NAME 'CHARLES-2022' PSW 'Babe@2022' ;
			REDIRECT 'unathorized' TIME 10
			
	//	------------------------------------------------------------------------------		
	
	AUTENTICATE CONTROLLER oController EXCEPTION 'Create'		
	
	oController:oMiddleware:cargo 	:= 'my_cargo'	+ str(hb_milliseconds())


RETU Self 

METHOD Create( oController ) CLASS Middleware_JWT 

	local hData 	:= {=>}
	local nTime	:= 10 	
	local cJwt 	
	
	hData[ 'id' ] 		:= 1234
	hData[ 'name' ] 	:= 'Carla Guttemberg'
	hData[ 'date' ] 	:= date()
	hData[ 'admin' ] 	:= .t.

	
	CREATE JWT cJWT OF oController WITH hData TIME nTime 
	
	
	?? '<h3>Authentication JWT Created!</h3><hr>' 
	? 'Time(sec) validate: ', nTime 
	? 'Token', cJWT 
	? '<hr>'
	? '<a href="' + mc_Route( 'token.validatejwt' ) + '">Valid Token JWT</a>'
	? '<a href="' + mc_Route( 'token.deljwt' ) + '">Delete Token JWT</a>'

RETU nil 


METHOD Validate( oController ) CLASS Middleware_JWT 

	local hData 
	
	GET TOKEN DATA hData OF oController
	
	?? '<h3>Authentication JWT Validated!</h3><hr>'
	
	_w( hData  )	
	
	? 'cargo => ', oController:oMiddleware:cargo

RETU nil 


METHOD Del( oController ) CLASS Middleware_JWT 

	CLOSE TOKEN OF oController

	?? '<h3>Authentication JWT Deleted!</h3><hr>'

retu nil 