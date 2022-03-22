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
			VALID {|uValue| MyAccess( uValue )}
			
	//	------------------------------------------------------------------------------

	AUTENTICATE CONTROLLER oController 

RETU Self 

 
METHOD Validate( oController ) CLASS Middleware_Basic 		
	
	local hData := { 'success' => .t., 'msg' => 'Welcome to process...', 'auth' => 'Basic Auth' }	
	
	OUTPUT 'json' WITH hData OF oController

RETU nil 

//	---------------------------------------------------------------------------------	//

function MyAccess( u )

	local nPos 
	local cUser := ''
	local cPsw  := ''
	local lAuth := .f.
	
	_d( 'MyAccess', u )
	
	nPos := At( ':', u )
	
	if nPos > 0 
		cUser := Substr( u, 1, nPos-1 )
		cPsw  := Substr( u, nPos+1 )				
	endif 
	_d( cUser, cPsw )
	
	lAuth := ( cUser == 'charly' .and. cPsw == '1234' )		

return lAuth