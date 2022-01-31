
FUNCTION MC_GetApp()
	
	thread STATIC oApp
	
	IF oApp == NIL
		oApp := MC_App():New()
		//oApp := TApp():New( cTitle, uInit , cPsw, cId_Cookie, nTime )
	ENDIF

RETU oApp


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
   
	DATA cTitle 
	DATA bInit
	
	
	


   METHOD New() 			CONSTRUCTOR
   METHOD Init()
 
   
ENDCLASS

METHOD New( cTitle, bInit ) CLASS MC_App

	::cTitle 		:= IF( valtype( cTitle ) == 'C', cTitle, AP_GETENV( 'APP_TITLE' ) )
	::bInit 		:= bInit

	//::oRequest 	:= TRequest():New()	
	//::oResponse 	:= TResponse():New()	
	//::oMiddleware 	:= TMiddleware():New()	
	/*

	
	::cUrl					:= App_Url()
	::cPath					:= AP_GETENV( 'DOCUMENT_ROOT' ) + ::cUrl		
	*/
	
	::oRouter 		:= MC_Router():New( self )
//	::oRequest		:= MC_Request():New( self )
	

RETU Self

METHOD Init() CLASS MC_App

	LOCAL oThis := SELF  
	
	IF Valtype( ::bInit ) == 'B'
		Eval( ::bInit, oThis )
	ENDIF
	
	::oRouter:Listen()
	
retu nil


