CLASS Middleware_Bearer 

	METHOD New()	CONSTRUCTOR 

	METHOD Validate()
	
ENDCLASS 

METHOD New( oController ) CLASS Middleware_Bearer 

	//	A efectos de test, como en el index.prg tenemos ya un DEFINE CREDENTIALS que actua 
	// 	por defecto, coje los parametros definidos. Pero como tenemos varios ejemplos 
	// 	de token, definimos para este prg como debe actuar
	//	En principio, solo definimos un tipo de autenticacion en el index y no deberiamos 
	//	definirlo aqui...

		DEFINE CREDENTIALS VIA 'bearer token' OUT 'json' JSON { 'success' => .f., 'msg' => 'Unauthorized' } ;
			VALID {|uValue| MyAccess( uValue )}
			
		_d( oController:oMiddleware:dbg())
			
	//	------------------------------------------------------------------------------

	AUTENTICATE CONTROLLER oController 

RETU Self 

 
METHOD Validate( oController ) CLASS Middleware_Bearer 		
	
	local hData := { 'success' => .t., 'msg' => 'Welcome to process...', 'auth' => 'Bearer token' }	
	
	OUTPUT 'json' WITH hData OF oController

RETU nil 

//	---------------------------------------------------------------------------------	//

function MyAccess( u )

return ( u == '1234' )