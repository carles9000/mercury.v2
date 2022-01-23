

CLASS MC_App	

	CLASSDATA oRouter					
	CLASSDATA oRequest
	CLASSDATA cLang									INIT 'en'
	CLASSDATA cCharset								INIT 'utf-8'	//	'ISO-8859-1'
		
	CLASSDATA cApp_Url								INIT MC_App_Url()								
	CLASSDATA cApp_Path							INIT MC_App_Path()
	CLASSDATA cPathLib								INIT '/lib/'
	CLASSDATA cPathCss								INIT '/css/'
	CLASSDATA cPathJs								INIT '/js/'
	CLASSDATA cPathView							INIT '/src/view/'
	CLASSDATA cPathController						INIT '/src/controller/'
	CLASSDATA cPathModel							INIT '/src/model/'   
   
	CLASSDATA cTitle 
	
	
	


   METHOD New() 			CONSTRUCTOR
   METHOD Init()
 
   
ENDCLASS

METHOD New( cTitle ) CLASS MC_App

	::cTitle 		:= IF( valtype( cTitle ) == 'C', cTitle, AP_GETENV( 'APP_TITLE' ) )

	//::oRequest 	:= TRequest():New()	
	//::oResponse 	:= TResponse():New()	
	//::oMiddleware 	:= TMiddleware():New()	
	/*

	
	::cUrl					:= App_Url()
	::cPath					:= AP_GETENV( 'DOCUMENT_ROOT' ) + ::cUrl		
	*/
	
	::oRouter 		:= MC_Router():New( self )
	::oRequest		:= MC_Request():New( self )
	

RETU Self

METHOD Init() CLASS MC_App

	::oRouter:Listen()
	
retu nil


