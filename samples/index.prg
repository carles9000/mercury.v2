//	{% mh_LoadHrb( '../lib/mercury.hrb' ) %}
// 	{% mc_InitMercury() %}	//	Inicialitza ErrorSystem
	
function main()

	local oApp
	
/*		
	El tema esta en que una definicio AUTH implica que tots els enrutats
	hauran de tenir la mateixa regla.
	Que pasa si vull xec una ruta per un altre via ?			
	Solucio:Es defineix una rgla general i cada modul te el seu autenticate 
	que agafara la config general o creara una definicó local per aquell modul
*/
	
	//mc_Auth():Define( 'MYAPP', 'cookie', 'jwt', 'CHARLES-2022', 'Babe2022', 'html', 'unathorized' )
	//mc_Auth():Define( 'MYAPP', 'query', 'jwt', 'CHARLES-2022', 'Babe2022', 'json', nil , { 'error' => .t., 'msg' => 'Error unauthorized' } )
	//mc_Auth():Define( 'MYAPP', 'query', 'jwt', 'CHARLES-2022', 'Babe2022', 'json' )
		
	//	
	//	Bearer -> token 
	//	Basic auth -> user:psw 
	//	API Key -> token 	
	
	//mc_Auth():Define( 'MYAPP', 'Bearer Token', 'jwt', 'CHARLES-2022', 'Babe2022' )
	//mc_Auth():Define( 'MYAPP', 'Basic Auth', 'jwt', 'CHARLES-2022', 'Babe2022' )
	//mc_Auth():Define( 'MYAPP', 'API Key', 'jwt', 'CHARLES-2022', 'Babe2022' )

	
	//mc_Middleware():Define( 'cookie', 'jwt', 'CHARLES-2022', 'Babe2022', 10, 'html', 'unathorized' )	
	//mc_Middleware():Define( 'query', 'jwt', 'CHARLES-2022', 'Babe2022', 'json', nil , { 'error' => .t., 'msg' => 'Error unauthorized' } )
	//mc_Middleware():Define( 'Bearer Token', 'jwt', nil , 'Babe2022', 'json', nil , { 'error' => .t., 'msg' => 'Error unauthorized' } )
	//mc_Middleware():Define( 'Basic Auth', 'func', nil , 'Babe2022', 'json', nil , { 'error' => .t., 'msg' => 'Error unauthorized' }, {|cToken| MyValid(cToken)} )
	//mc_Middleware():Define( 'API key', 'func', 'CHARLES-2022' , 'Babe2022', 'json', nil , { 'error' => .t., 'msg' => 'Error unauthorized' }, {|cToken| MyValid(cToken)} )
	
	DEFINE APP oApp TITLE 'App Mercury 1.00'  ON INIT TestInit() 
	
		DEFINE CREDENTIALS NAME 'CHARLES-2022' PSW 'Babe@2022' REDIRECT 'unathorized'				
		//DEFINE CREDENTIALS NAME 'CHARLES-2022' PSW 'Babe@2022' TIME 10 REDIRECT 'unathorized'				
		//DEFINE CREDENTIALS TYPE 'token' NAME 'CHARLES-2022' PSW 'Babe@2022' REDIRECT 'unathorized'				

	
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
			
			
/*
			DEFINE ROUTE 'token.crea'			URL 'tk_crea' 			CONTROLLER  'creatoken@testaccess.prg'	OF oApp						
			DEFINE ROUTE 'token.del'			URL 'tk_del' 			CONTROLLER  'deltoken@testaccess.prg'	OF oApp						
			DEFINE ROUTE 'token.hello'			URL 'tk_hello' 			CONTROLLER  'hello_access@testaccess.prg'	OF oApp						
			DEFINE ROUTE 'token.check.jwt'		URL 'tk_check_jwt'		CONTROLLER  'check_jwt@testaccess.prg'	METHOD 'POST'	OF oApp									
			DEFINE ROUTE 'token.check.token'	URL 'tk_check_token'	CONTROLLER  'check_token@testaccess.prg'	METHOD 'POST'	OF oApp						
*/			
			
			
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
	
	_d( mc_getapp():Version() )
	
retu 


