//	{% mh_LoadHrb( '..\lib\mercury.hrb' ) %} 

#include "{% MC_App_Path() + '/../lib/mercury.ch' %}"


function main()

	local oApp

	
	DEFINE APP oApp 

	
		DEFINE ROUTE 'r1' URL '/' 				CONTROLLER 'xxx.prg' 				METHOD 'GET' OF oApp
		DEFINE ROUTE 'r2' URL 'hello' 			CONTROLLER 'hello.prg' 				METHOD 'GET' OF oApp
		DEFINE ROUTE 'r3' URL 'customer/[id]'	CONTROLLER 'customer.prg' 			METHOD 'GET' OF oApp
		DEFINE ROUTE 'r4' URL 'nofile'			CONTROLLER 'nofile.prg' 			METHOD 'GET' OF oApp
		DEFINE ROUTE 'r5' URL 'testclass/[id]'	CONTROLLER 'info@testclass.prg' 	METHOD 'GET' OF oApp
		DEFINE ROUTE 'r6' URL 'testerror'		CONTROLLER 'crash@testclass.prg' 	METHOD 'GET' OF oApp
		DEFINE ROUTE 'r7' URL 'nomethod'		CONTROLLER 'nomethod@testclass.prg' METHOD 'GET' OF oApp
		
		DEFINE ROUTE 's1' URL 'routes' 			CONTROLLER 'routes@system.prg'	 	METHOD 'GET' OF oApp
			
	INIT APP oApp  
	
	//oApp:oRouter:Show()
	


retu nil


