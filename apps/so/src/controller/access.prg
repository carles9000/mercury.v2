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

		o:View( 'sys/login.view' )
	
RETU NIL

//	---------------------------------------------------------------	//

METHOD Auth( oController ) CLASS Access
	
	local hData 		:= GetMsgServer()
	LOCAL hTokenData 	:= {=>}
	LOCAL hUser	 	:= {=>}
	local oV, oTrace, cRol 
	

	DEFINE VALIDATOR oV WITH hData
		PARAMETER 'user' 	NAME 'User' ROLES 'required|string|maxlen:8' OF oV	
		PARAMETER 'psw' 	NAME 'Psw'  ROLES 'required|maxlen:20' OF oV		
	RUN VALIDATOR oV 
	
	if oV:lError	
		oController:oResponse:SendJson( { 'success' => .f., 'error' => oV:ErrorString() } )			
		retu 
	endif
	
	oTrace		:= TraceModel():New()
	oTrace:Insert()

	//	Validacion de Usuario. Puedes poner un modelo de datos y validar... :-)
	
		IF hData[ 'user' ] == 'demo' .AND. ( hData[ 'psw'] == '1234' .or. hData[ 'psw'] == '777' )					
		
			//	Recojo datos de Usuario (from model)
			
				cRol := if( hData[ 'psw'] == '777', 'A', '' )
			
				hUser := { 'id' => '1000', 'user' => 'demo', 'name' => 'User Demo...', 'rol' => cRol }
			
			//	Datos que incrustar en el token...	
				
				hTokenData := { 'entrada' => time(), 'empresa' => 'Intelligence System', 'user' => hUser } 			
			
			//	Inicamos nuestro sistema de Validación del sistema basado en JWT
			
				CREATE JWT cJWT OF oController WITH hTokenData			
				
			
			//	Mostramos página principal
			
				oController:oResponse:SendJson( { 'success' => .t. } )
				
		ELSE					
			oController:oResponse:SendJson( { 'success' => .f., 'error' => 'Error autenticate' } )
		ENDIF	

RETU NIL

//	---------------------------------------------------------------	//

METHOD Logout( oController ) CLASS Access	

	CLOSE TOKEN OF oController

	oController:View( 'splash.view' )

RETU NIL


//	Load datamodel		------------------------------------------ //

	{% mh_LoadFile( "/src/model/tracemodel.prg" ) %}