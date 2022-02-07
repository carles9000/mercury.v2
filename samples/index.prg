//	{% mh_LoadHrb( '../lib/mercury.hrb' ) %} 

#include "{% MC_App_Path() + '/../lib/mercury.ch' %}"


function main()

	local oApp

	
	DEFINE APP oApp 

	
		DEFINE ROUTE 'root'	URL '/' 				VIEW 'test.view' 				OF oApp
		
		DEFINE ROUTE 'hello' 	URL 'hello' 			CONTROLLER 'hello.prg' 		METHOD 'GET' OF oApp
		
		//	Test View
		
			DEFINE ROUTE 'view'	URL 'view/[id]' 	CONTROLLER 'show@views.prg'	OF oApp	

		//	Test Router
		
			DEFINE ROUTE 'rt.1'	URL 'user' 					CONTROLLER 'test1@route.prg'		OF oApp				
			DEFINE ROUTE 'rt.2'	URL 'user/name/(id)' 		CONTROLLER 'test2@route.prg'		OF oApp					
			DEFINE ROUTE 'rt.3' 	URL 'user/(id)/info/[what]'	CONTROLLER 'test3@route.prg'		OF oApp				
			
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
			
			
			
			
//	--------------------------------------			

		
		DEFINE ROUTE 'r3' URL 'customer/[id]'	CONTROLLER 'customer.prg' 				METHOD 'GET' OF oApp
		DEFINE ROUTE 'r4' URL 'nofile'			CONTROLLER 'nofile.prg' 				METHOD 'GET' OF oApp
		DEFINE ROUTE 'r5' URL 'testclass/[id]'	CONTROLLER 'info@testclass.prg' 		METHOD 'GET' OF oApp
		DEFINE ROUTE 'r6' URL 'testerror'		CONTROLLER 'crash@testclass.prg' 		METHOD 'GET' OF oApp
		DEFINE ROUTE 'r7' URL 'nomethod'		CONTROLLER 'nomethod@testclass.prg' 	METHOD 'GET' OF oApp
		
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

		//	Test Validator
		
			
			//DEFINE ROUTE 'v1'		URL 'valid' 				VIEW  'validator/v1.view'			OF oApp					
			DEFINE ROUTE 'valid.view'	URL 'valid' 				CONTROLLER  'view@validator.prg'	OF oApp					
			
			DEFINE ROUTE 'valid.test'	URL 'valid/test' 			CONTROLLER  'test@validator.prg'	METHOD 'POST' OF oApp					


			
		
			
		
		DEFINE ROUTE 's1' URL 'routes' 		CONTROLLER 'routes@system.prg'	 	METHOD 'GET' OF oApp
			
	INIT APP oApp  
	
	//oApp:oRouter:Show()
	


retu nil


