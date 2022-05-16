//	------------------------------------------------------------------------------
//	Title......: Basic
//	Description: Basic app example
//	Date.......: 09/07/2019
//	Last Upd...: 22/03/2022
//	------------------------------------------------------------------------------

//	{% mh_LoadHrb( '../../lib/mercury.hrb' ) %}			//	Load lib
// 	{% mc_InitMercury( '../../lib/mercury.ch' ) %}		//	Init Mercury system

#define APP_VERSION  '1.0a'


FUNCTION Main()

	local oApp
	
		DEFINE APP oApp TITLE 'My First App'
		
		//	Credentials / Security 	
		
			DEFINE CREDENTIALS NAME 'APP-2022' PSW 'MCbaSIc@2022' REDIRECT 'app.login'	

		//	Config Routes	------------------------------------------------------------------
		
		//	Basic pages...		
			
			DEFINE ROUTE 'default' 		URL '/' 				CONTROLLER 'default@myapp.prg' 	METHOD 'GET' OF oApp			
			
		//	Auth				
			
			DEFINE ROUTE 'app.login'		URL 'app/login'			CONTROLLER 'login@access.prg'		METHOD 'GET'	OF oApp
			DEFINE ROUTE 'app.logout'		URL 'app/logout'		CONTROLLER 'logout@access.prg'		METHOD 'GET'	OF oApp
			DEFINE ROUTE 'app.auth'		URL 'app/auth'			CONTROLLER 'auth@access.prg'		METHOD 'POST'	OF oApp
		
		
		//	Basic module
		
			DEFINE ROUTE 'menu'			URL 'menu'				CONTROLLER 'menu@myapp.prg'		METHOD 'GET'	OF oApp
			DEFINE ROUTE 'test1'			URL 'test1'				CONTROLLER 'test1@myapp.prg'		METHOD 'GET'	OF oApp
			DEFINE ROUTE 'test2'			URL 'test2'				CONTROLLER 'test2@myapp.prg'		METHOD 'GET'	OF oApp
			DEFINE ROUTE 'test3'			URL 'test3'				CONTROLLER 'test3@myapp.prg'		METHOD 'GET'	OF oApp
			
			DEFINE ROUTE 'about' 			URL 'about' 			VIEW 'about.view' 					METHOD 'GET' 	OF oApp			
			
	//	Init Aplication
	
		INIT APP oApp	

RETU NIL

function App_Version()
retu APP_VERSION 