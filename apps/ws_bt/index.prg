//	------------------------------------------------------------------------------
//	Title......: WS_BT
//	Description: WebService with Bearer Token
//	Date.......: 09/07/2019
//	Last Upd...: 22/03/2022
//	------------------------------------------------------------------------------
//	Example WS with Bearer Token. Try user: mercury , psw:1234 with postman 
//	------------------------------------------------------------------------------

//	{% mh_LoadHrb( '../../lib/mercury.hrb' ) %}			// Load lib
// 	{% mc_InitMercury( '../../lib/mercury.ch' ) %}		// Init Mercury system

#define WS_VERSION  '1.0a'


FUNCTION Main()

	local oApp
	
		DEFINE APP oApp ON INIT MyConfig()
		
		//	Credentials / Security 									
			
			DEFINE CREDENTIALS VIA 'Bearer token' TYPE 'jwt' PSW 'WSCusTO@2022' ;
				OUT 'json' JSON { 'success' => .f., 'error' => 'unauthorized'}	 TIME 3600 
				


		//	Config Routes	------------------------------------------------------------------
		
			DEFINE ROUTE 'root' URL '/' VIEW 'message.view' METHOD 'GET' OF oApp	
			
		//	Basic services		
		
			DEFINE ROUTE 'wsstate' URL 'wsstate' CONTROLLER 'getbystate@ws_customers.prg' METHOD 'GET' OF oApp
			DEFINE ROUTE 'version' URL 'version' CONTROLLER 'version@ws_customers.prg' METHOD 'GET' OF oApp				
			
			
		//	Auth				
			
			DEFINE ROUTE 'gettoken'		URL 'gettoken'			CONTROLLER 'gettoken@access.prg'		METHOD 'GET'	OF oApp

		
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
