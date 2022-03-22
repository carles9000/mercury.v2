CLASS Middleware_Api 

	METHOD New()	CONSTRUCTOR 

	METHOD Validate()
	
ENDCLASS 

METHOD New( oController ) CLASS Middleware_Api 

	//	A efectos de test, como en el index.prg tenemos ya un DEFINE CREDENTIALS que actua 
	// 	por defecto, coje los parametros definidos. Pero como tenemos varios ejemplos 
	// 	de token, definimos para este prg como debe actuar
	//	En principio, solo definimos un tipo de autenticacion en el index y no deberiamos 
	//	definirlo aqui...

		DEFINE CREDENTIALS VIA 'api key' NAME 'charly' OUT 'json' JSON { 'success' => .f., 'msg' => 'Unauthorized' } ;
			VALID {|uValue| MyAccess( uValue )}
			
	//	------------------------------------------------------------------------------

	AUTENTICATE CONTROLLER oController 

RETU Self 

 
METHOD Validate( oController ) CLASS Middleware_Api 		
	
	local hData := { 'success' => .t., 'msg' => 'Welcome to process...', 'auth' => 'API key' }	
	
	OUTPUT 'json' WITH hData OF oController

RETU nil 

//	---------------------------------------------------------------------------------	//

function MyAccess( u )
	
return ( u == '1234')