CLASS App

	METHOD New() 	CONSTRUCTOR
	
	METHOD Default()	
	
	METHOD Menu()	
	
	METHOD Test1()				
	METHOD Test2()				
	METHOD Test3()				
   	
ENDCLASS

//	---------------------------------------------------------------	//

METHOD New( oController ) CLASS App

	//AUTENTICATE CONTROLLER oController
	
RETU SELF

//	---------------------------------------------------------------	//

METHOD Default( oController ) CLASS App	

	oController:View( 'main/main.view' )

RETU NIL

//	---------------------------------------------------------------	//

METHOD Menu( oController ) CLASS App

	oController:View( 'app/menu.view' )

RETU NIL

//	---------------------------------------------------------------	//

METHOD Test1( oController ) CLASS App

	oController:View( 'app/test1.view' )
	
RETU NIL

//	---------------------------------------------------------------	//

METHOD Test2( oController ) CLASS App

	oController:View( 'app/test2.view' )
	
RETU NIL

//	---------------------------------------------------------------	//

METHOD Test3( oController ) CLASS App

	oController:View( 'app/test3.view', 200, oController:oMiddleware:GetData() )
	
RETU NIL
