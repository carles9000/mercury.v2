thread STATIC oApp

FUNCTION MC_GetApp() ;  RETU oApp

FUNCTION MC_InitApp()

	

retu nil 

FUNCTION MC_Set( key, value )

	local cType := valtype( key  )

	thread STATIC hData
	
	IF hData == NIL
		hData := {=>}
	endif 
	
	if cType == 'L' .and. key 
		hData := {=>}
	elseif cType == 'C'	
		hData[key] := value 
	endif			

RETU hData 

FUNCTION MC_Get( key, uDefault )

	local h := MC_Set()

	HB_HCaseMatch( h, .f. )
	
RETU if( key == nil , h, HB_HGetDef( h, key, uDefault ) )


CLASS MC_App	

	CLASSDATA oRouter					
	CLASSDATA oRequest
	CLASSDATA oResponse
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
	CLASSDATA bInit			

	METHOD New() 			CONSTRUCTOR
	METHOD Init()
   
	METHOD Version()								INLINE MC_VERSION
 
   
ENDCLASS

METHOD New( cTitle, bInit ) CLASS MC_App
	
	
	::cTitle 		:= IF( valtype( cTitle ) == 'C', cTitle, AP_GETENV( 'APP_TITLE' ) )
	::bInit 		:= bInit	

	::oRouter 		:= MC_Router():New( self )
	::oResponse	:= MC_Response():New()
	

	oApp := SELF

RETU Self

METHOD Init() CLASS MC_App

	LOCAL oThis := SELF  
	
	IF Valtype( ::bInit ) == 'B'
		Eval( ::bInit, oThis )
	ENDIF
	
	::oRouter:Listen()
	
retu nil


 


