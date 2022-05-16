CLASS Middleware_Basic 

	METHOD New()	CONSTRUCTOR 

	METHOD Validate()
	
ENDCLASS 

METHOD New( oController ) CLASS Middleware_Basic 

	//	A efectos de test, como en el index.prg tenemos ya un DEFINE CREDENTIALS que actua 
	// 	por defecto, coje los parametros definidos. Pero como tenemos varios ejemplos 
	// 	de token, definimos para este prg como debe actuar
	//	En principio, solo definimos un tipo de autenticacion en el index y no deberiamos 
	//	definirlo aqui...

		DEFINE CREDENTIALS VIA 'basic auth' OUT 'json' JSON { 'success' => .f., 'msg' => 'Unauthorized' } ;
			VALID {|cUser,cPsw| MyAccess( cUser, cPsw )}

	//	------------------------------------------------------------------------------

	AUTENTICATE CONTROLLER oController 

RETU Self 

 
METHOD Validate( oController ) CLASS Middleware_Basic 		
	
	local hData := { 'success' => .t., 'msg' => 'Welcome to process...', 'auth' => 'Basic Auth' }	
	
	OUTPUT 'json' WITH hData OF oController

RETU nil 

//	---------------------------------------------------------------------------------	//

function MyAccess( cKey, cPsw )

	local lAuth := ( cKey == 'charly' .and. cPsw == '1234' )			
	
retu lAuth 
