//	------------------------------------------------------------------------------
//	Title......: Mercury example test
//	Description: Mercury example test
//	Author.....: Carles Aubia
//	Date.......: 24/03/2022
//	Last Upd...: 24/03/2022
//	------------------------------------------------------------------------------

//	{% mh_LoadHrb( '../lib/mercury.hrb' ) %}		//	Load Mercury lib
//	{% mc_InitMercury( '../lib/mercury.ch' ) %}		//	Init Mercury system


function main()

	local oApp		
	
	DEFINE APP oApp TITLE 'App Mercury 1.00'  ON INIT TestInit() 
	
		DEFINE CREDENTIALS NAME 'CHARLES-2022' PSW 'Babe@2022' REDIRECT 'unathorized'					
	
		DEFINE ROUTE 'root'	URL '/' 				VIEW 'test.view' 				OF oApp
		
		DEFINE ROUTE 'hello' 			URL 'hello' 			CONTROLLER 'hello.prg' 		METHOD 'GET' OF oApp
		DEFINE ROUTE 'unathorized' 	URL 'unathorized' 		VIEW 'unathorized.view' 		METHOD 'GET' OF oApp
		
		//	Test View
		
			DEFINE ROUTE 'view'		URL 'view/[id]' 	CONTROLLER 'show@views.prg'	OF oApp	
			DEFINE ROUTE 'bootstrap'	URL 'bootstrap' 	VIEW 'views/bootstrap.view'		OF oApp	

		//	Test Router
		
			DEFINE ROUTE 'rt.1'	URL 'user' 					CONTROLLER 'test1@route.prg'		OF oApp				
			DEFINE ROUTE 'rt.2'	URL 'user/name/(id)' 		CONTROLLER 'test2@route.prg'		OF oApp					
			DEFINE ROUTE 'rt.3' 	URL 'user/(id)/info/[what]'	CONTROLLER 'test3@route.prg'		OF oApp				
			DEFINE ROUTE 'rt.5' 	URL 'myfunc'				CONTROLLER 'myfunc.prg'		METHOD 'GET,POST' OF oApp				
			
		//	Test Requests
		
			DEFINE ROUTE 'req.1' URL 'get/[id]'		CONTROLLER 'get@testcontroller.prg' 	 METHOD 'GET' OF oApp
			DEFINE ROUTE 'req.2' URL 'post/[id]'		CONTROLLER 'post@testcontroller.prg' 	 METHOD 'POST' OF oApp
			DEFINE ROUTE 'req.3' URL 'request/[id]'	CONTROLLER 'request@testcontroller.prg' METHOD 'GET,POST' OF oApp

		//	Test Response	
		
			DEFINE ROUTE 'response.json' 		URL 'response/json' 	CONTROLLER 'json@response.prg'		OF oApp
			DEFINE ROUTE 'response.xml' 		URL 'response/xml' 		CONTROLLER 'xml@response.prg'		OF oApp
			DEFINE ROUTE 'response.html' 		URL 'response/html'		CONTROLLER 'html@response.prg'		OF oApp
			DEFINE ROUTE 'response.401' 		URL 'response/401'		CONTROLLER 'error401@response.prg'	OF oApp
			DEFINE ROUTE 'response.redirect'	URL 'response/redirect'	CONTROLLER 'redirect@response.prg'	OF oApp	
			
		//	Test Validator					

			DEFINE ROUTE 'valid.view'	URL 'valid' 				CONTROLLER  'view@validator.prg'	OF oApp						
			DEFINE ROUTE 'valid.test'	URL 'valid/test' 			CONTROLLER  'test@validator.prg'	METHOD 'POST' OF oApp					

			
		//	Test Error 
		
			DEFINE ROUTE 'err.nomethod' URL 'nomethod'		CONTROLLER 'nomethod@testerror.prg' 	METHOD 'GET' OF oApp
			DEFINE ROUTE 'err.nofile' 	 URL 'nofile'		CONTROLLER 'nofile.prg' 				METHOD 'GET' OF oApp
			DEFINE ROUTE 'err.check' 	 URL 'crash'		CONTROLLER 'crash@testerror.prg' 		METHOD 'GET' OF oApp
			
		//	Test JWT	
		
			DEFINE ROUTE 'jwt'				URL 'jwt' 			CONTROLLER 'create@test_jwt.prg'		METHOD 'GET'	OF oApp
			DEFINE ROUTE 'jwt_cookiejwt'	URL 'jwt_cookiejwt'	CONTROLLER 'cookiejwt@test_jwt.prg'	METHOD 'GET'	OF oApp
			DEFINE ROUTE 'jwt_cookietoken'	URL 'jwt_cookietoken'	CONTROLLER 'cookietoken@test_jwt.prg'	METHOD 'GET'	OF oApp
			DEFINE ROUTE 'jwt_delcookie'	URL 'jwt_delcookie'		CONTROLLER 'delcookie@test_jwt.prg'	METHOD 'GET'	OF oApp
			DEFINE ROUTE 'jwt.valid'		URL 'jwt/valid' 	CONTROLLER 'valid@test_jwt.prg'		METHOD 'POST'	OF oApp			
			
		//	Test Controller
		
			DEFINE ROUTE 'myfunc'			URL 'myfunc' 		CONTROLLER  'myfunc.prg'	OF oApp						
			DEFINE ROUTE 'myclass'			URL 'myclass' 		CONTROLLER  'info@myclass.prg'	OF oApp						

		//	Test Middleware
		
			DEFINE ROUTE 'token.createjwt'		URL 'tk_createjwt' 		CONTROLLER  'create@middleware_jwt.prg'	OF oApp						
			DEFINE ROUTE 'token.validatejwt'	URL 'tk_validatejwt' 	CONTROLLER  'validate@middleware_jwt.prg'	OF oApp						
			DEFINE ROUTE 'token.deljwt'		URL 'tk_deljwt' 		CONTROLLER  'del@middleware_jwt.prg'	OF oApp						
			
			DEFINE ROUTE 'token.createtoken'	URL 'tk_createtoken' 	CONTROLLER  'create@middleware_token.prg'	OF oApp						
			DEFINE ROUTE 'token.validatetoken'	URL 'tk_validatetoken'	CONTROLLER  'validate@middleware_token.prg'	OF oApp						
			DEFINE ROUTE 'token.deltoken'		URL 'tk_deltoken' 		CONTROLLER  'del@middleware_token.prg'		OF oApp					
			
			DEFINE ROUTE 'token.validatebearer' URL 'tk_validatebearer' CONTROLLER  'validate@middleware_bearer.prg'	METHOD 'POST' OF oApp						
			DEFINE ROUTE 'token.validatebasic'  URL 'tk_validatebasic'  CONTROLLER  'validate@middleware_basic.prg'	METHOD 'POST' OF oApp						
			DEFINE ROUTE 'token.validateapi'    URL 'tk_validateapi'    CONTROLLER  'validate@middleware_api.prg'		METHOD 'POST' OF oApp										
			
		//	Restes
			DEFINE ROUTE 'r5' URL 'testclass/[id]'	CONTROLLER 'info@testclass.prg' 		METHOD 'GET' OF oApp
			DEFINE ROUTE 'r3' URL 'customer/[id]'	CONTROLLER 'customer.prg' 				METHOD 'GET' OF oApp
			
//	--------------------------------------			

		
		
		DEFINE ROUTE 'get1' URL 'get1'			CONTROLLER 'get1@testset.prg' METHOD 'GET' OF oApp
		DEFINE ROUTE 'set2' URL 'set2'			CONTROLLER 'set2@testset.prg' METHOD 'GET' OF oApp
		DEFINE ROUTE 'get2' URL 'get2'			CONTROLLER 'get2@testset.prg' METHOD 'GET' OF oApp
		

		//	Test sub-folder Controller
		
			DEFINE ROUTE 'my_new'	URL 'new' 	CONTROLLER 'module_A/new.prg'		OF oApp	
			
		//	Test MC_Route
		/*
			DEFINE ROUTE 'z0'		URL 'get' 					CONTROLLER 'test1@route.prg'		OF oApp				
			DEFINE ROUTE 'z1'		URL 'get/(id)/name/[st]' 	CONTROLLER 'test1@route.prg'		OF oApp				
			DEFINE ROUTE 'z2'		URL 'get/name/(id)' 		CONTROLLER 'test1@route.prg'		OF oApp				
			DEFINE ROUTE 'route1'	URL 'route1' 	CONTROLLER 'test1@route.prg'		OF oApp		
			*/					
			
		
		DEFINE ROUTE 's1' URL 'routes' 		CONTROLLER 'routes@system.prg'	 	METHOD 'GET' OF oApp
			
	INIT APP oApp  
	
	//oApp:oRouter:Show()
	


retu nil

function TestInit()
	
	SET DATE TO ITALIAN
	
	//_d( mc_getapp():Version() )
	
retu 


