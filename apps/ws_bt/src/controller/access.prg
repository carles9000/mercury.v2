CLASS Access

	METHOD New() 	CONSTRUCTOR
	
	METHOD GetToken() 			
   
ENDCLASS

//	---------------------------------------------------------------	//

METHOD New( o ) CLASS Access	


RETU SELF

//	---------------------------------------------------------------	//

METHOD GetToken( oController ) CLASS Access	
	
	local hData 		:= oController:PostAll()
	LOCAL hUser	 	:= {=>}
	local oValidator 		

	DEFINE VALIDATOR oValidator WITH hData
		PARAMETER 'user' 	NAME 'User' ROLES 'required|string|maxlen:8' FORMATTER 'tolower' OF oValidator	
		PARAMETER 'psw' 	NAME 'Psw'  ROLES 'required' OF oValidator		
	RUN VALIDATOR oValidator 
	
	if oValidator:lError
		OUTPUT 'json' WITH { 'success' => .f., 'error' => oValidator:ErrorString() } OF oController											
		retu 
	endif

	//	Validacion de Usuario
	//	User validation
	
		IF hData[ 'user' ] == 'mercury' .AND. hData[ 'psw'] == '1234'
		
			//	Leo datos de Usuario (from model)
			//	I read User data (from model)
			
				hUser := { 'id' => '1000', 'user' => 'mercury', 'name' => 'User Mercury...' }																											
			
			
			//	Crearemos un token de tipo JSW (Json Web Token)
			//	We will create a token of type JSW (Json Web Token)
			
				CREATE JWT cToken OF oController WITH hUser 
				
			//	Podemos crear un token interno usandoe esta clausula 
			//	We can create an internal token using this clause
			
			//	CREATE TOKEN cToken OF oController WITH hUser 
				
				
			
			//	Devolvemos respuesta con ok 	
			//	We return response with ok
			
				OUTPUT 'json' WITH { 'success' => .t., 'token' => cToken } OF oController											
				
		ELSE
		
			OUTPUT 'json' WITH { 'success' => .f., 'error' => 'error credentials' } OF oController														
			
		ENDIF	

RETU NIL

//	---------------------------------------------------------------	//
