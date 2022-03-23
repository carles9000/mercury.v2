//	------------------------------------------------------------------------------
//	Title......: WS_AK
//	Description: WebService with API Key
//	Date.......: 09/07/2019
//	Last Upd...: 22/03/2022
//	------------------------------------------------------------------------------
//	Example WS with API Key. Try key: mercury , psw:1234 with postman 
//	------------------------------------------------------------------------------

//	{% mh_LoadHrb( '../../lib/mercury.hrb' ) %}
// 	{% mc_InitMercury() %}								//	Init ErrorSystem

#define WS_VERSION  '1.0a'


FUNCTION Main()

	local oApp
	
		DEFINE APP oApp ON INIT MyConfig()
		
		//	Credentials / Security 	

			DEFINE CREDENTIALS VIA 'API Key' NAME 'mercury' ;
				OUT 'json' JSON { 'success' => .f., 'error' => 'unauthorized'}	 ;	
				VALID {|uValue| MyAccess( uValue )} DBG


		//	Config Routes	------------------------------------------------------------------
			
			DEFINE ROUTE 'root' URL '/' VIEW 'message.view' METHOD 'GET' OF oApp	
					
		//	Basic services		
		
			DEFINE ROUTE 'wsstate' URL 'wsstate' CONTROLLER 'getbystate@ws_customers.prg' METHOD 'GET' OF oApp	
			DEFINE ROUTE 'version' URL 'version' CONTROLLER 'version@ws_customers.prg' METHOD 'GET' OF oApp	

	//	Init Aplication
	
		INIT APP oApp	

RETU NIL

//	------------------------------------------------------------	//

function AppPathData() ; retu if(  empty( AP_GetEnv( "PATH_DATA" ) ), MC_App_Path() + '/data/', AP_GetEnv( "PATH_DATA" ) )
function WS_Version() ; retu WS_VERSION 

//	------------------------------------------------------------	//

function MyConfig() 

	SET DATE TO ITALIAN	

retu nil

//	------------------------------------------------------------	//
//	API KEY
//	Basicamente nos llegará un cadena que será el token.
//	Mercury llamará a la función y le pasará este token.
//	Luego ya es el programador lo que decide hacer 
//	-----------------------------------------------------------	//
//	Basically we will get a string that will be the token.
//	Mercury will call the function and pass this token to it.
//	Then it is the programmer what he decides to do
//	-----------------------------------------------------------	//

function MyAccess( cToken )

	local nPos 
	local cUser := ''
	local cPsw  := ''
	local lAuth := .f.
	
	DEFAULT cToken TO ''
	
	_d( 'MyAccess <-- ' + cToken )
	
	//	En este caso solo comprueba que tenga estos valores.
	//	Tu puedes por ejemplo buscar en una base de datos para validar
	//	--------------------------------------------------------------
	//	In this case it only checks that it has these values.
	//	You can for example search in a database to validate
	//	--------------------------------------------------------------	
	
		lAuth := ( cToken == '1234' )		

	_d( 'MyAccess Auth --> ' + mh_valtochar( lAuth ) )
	
return lAuth