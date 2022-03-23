//	------------------------------------------------------------------------------
//	Title......: WS_BA
//	Description: WebService whith Basic Auth
//	Date.......: 09/07/2019
//	Last Upd...: 22/03/2022
//	------------------------------------------------------------------------------
//	Example WS with Basic Auth. Try user: mercury , psw:1234 with postman 
//	------------------------------------------------------------------------------

//	{% mh_LoadHrb( '../../lib/mercury.hrb' ) %}
// 	{% mc_InitMercury() %}								//	Init ErrorSystem

#define WS_VERSION  '1.0a'


FUNCTION Main()

	local oApp
	
		DEFINE APP oApp ON INIT MyConfig()
		
		//	Credentials / Security 	
		
			DEFINE CREDENTIALS VIA 'Basic Auth' PSW 'WSCusTO@2022' ;
				OUT 'json' JSON { 'success' => .f., 'error' => 'unauthorized'}	 ;	
				VALID {|uValue| MyAccess( uValue )}


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
//	BASIC AUTHENTICATION
//	Basicamente nos llegará (en el caso que se envie) un cadena
//	formada por 2 partes, separada por :, y que represantará el
//	user y el password. Mercury llamará a la función y le pasará 
//	esta cadena. Luego ya es el programador lo que decide hacer 
//	con la cadena. 
//	-----------------------------------------------------------	//
//  Basically it will arrive (in case it is sent) a string
//  formed by 2 parts, separated by : and that will represent the
//  user and password. Mercury call to the function and will send 
//	this string. After all, it is the programmer who decides to do 
//	whith this string
//	-----------------------------------------------------------	//

function MyAccess( u )

	local nPos 
	local cUser := ''
	local cPsw  := ''
	local lAuth := .f.
	
	_d( 'MyAccess <-- ' + mh_valtochar( u ) )
	
	nPos := At( ':', u )
	
	if nPos > 0 
		cUser := Substr( u, 1, nPos-1 )
		cPsw  := Substr( u, nPos+1 )				
	endif 
	
	_d( 'user: ' + cUser, 'password: ' + cPsw )
	
	//	En este caso solo comprueba que tenga estos valores.
	//	Tu puedes por ejemplo buscar en una base de datos para validar
	//	--------------------------------------------------------------
	//	In this case it only checks that it has these values.
	//	You can for example search in a database to validate
	//	--------------------------------------------------------------	
	
		lAuth := ( cUser == 'mercury' .and. cPsw == '1234' )		

	_d( 'MyAccess Auth --> ' + mh_valtochar( lAuth ) )
	
return lAuth