CLASS Access

	METHOD New() 	CONSTRUCTOR
	
	METHOD Login() 
	METHOD Auth() 
	METHOD Logout() 
	
   
ENDCLASS

//	---------------------------------------------------------------	//

METHOD New( o ) CLASS Access	


RETU SELF

//	---------------------------------------------------------------	//

METHOD Login( o ) CLASS Access

	//	Crearemos una pagina para entrar datos para posteriormente valorarlos...

		o:View( 'app/login.view' )
	
RETU NIL

//	---------------------------------------------------------------	//

METHOD Auth( oController ) CLASS Access
	
	local hData 		:= oController:PostAll()
	LOCAL hTokenData 	:= {=>}
	LOCAL hUser	 	:= {=>}
	local oV 		

	DEFINE VALIDATOR oV WITH hData
		PARAMETER 'user' 	NAME 'User' ROLES 'required|string|maxlen:8' OF oV	
		PARAMETER 'psw' 	NAME 'Psw'  ROLES 'required' OF oV		
	RUN VALIDATOR oV 
	
	if oV:lError
		oController:View( 'error.view', 200, oV:ErrorString() )				
		retu 
	endif

	//	Validacion de Usuario
	
		IF hData[ 'user' ] == 'dummy' .AND. hData[ 'psw'] == '1234'
		
			//	Recojo datos de Usuario (from model)
			
				hUser := { 'id' => '1000', 'user' => 'dummy', 'name' => 'User Dummy...' }
			
			//	Datos que incrustarer en el token...	
				
				hTokenData := { 'entrada' => time(), 'empresa' => 'Intelligence System', 'user' => hUser } 			
			
			//	Inicamos nuestro sistema de Validación del sistema basado en JWT
			
				CREATE JWT cJWT OF oController WITH hTokenData
			
				
			
			//	Mostramos página principal
			
				oController:View( 'app/menu.view', hTokenData )
				//oController:Redirect( mc_Route( 'app.principal' ) )
				
		ELSE
		
			oController:View( 'app/login.view' , { 'success' => .F., 'type' => 'user', 'error' => 'No se ha podido autenticar correctamente' } )
			
		ENDIF	

RETU NIL

//	---------------------------------------------------------------	//

METHOD Logout( oController ) CLASS Access	

	CLOSE TOKEN OF oController

	oController:View( 'app/default.view' )

RETU NIL