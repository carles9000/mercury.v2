CLASS MC_Viewer

	DATA oRoute				INIT ''	
	DATA oResponse			INIT ''	
	
	METHOD New() CONSTRUCTOR	

	METHOD Load( cFile ) 
	METHOD Exec( cFile, ... ) 
	
ENDCLASS 

METHOD New() CLASS MC_Viewer

	::oResponse := MC_Response():New()
		
RETU Self


METHOD Load( cFile ) CLASS MC_Viewer

	//	Por defecto la carpeta de los views estaran en src/view
	LOCAL oApp 	:= MC_GetApp()
	LOCAL cPath 	:= oApp:cApp_Path  + oApp:cPathView
	LOCAL cCode 	:= ''
	LOCAL cProg

	__defaultNIL( @cFile, '' )
	
	if Valtype( cFile ) != 'C'
		MC_MsgError( 'View', "View wrong" )	
		retu nil
	endif
	
	cProg 	:= cPath + cFile
	
	IF File ( cProg )
	
		cCode := MemoRead( cProg )
		
	ELSE		
	
		MC_MsgError( 'View', "Doesn't exist view ==> <strong> " +  cFile + "<strong>" )						
		
	ENDIF		

RETU cCode

METHOD Exec( cFile, nCode, ... ) CLASS MC_Viewer

	LOCAL cHtml	:= ''		
	LOCAL cCode  	:= ::Load( cFile )
	LOCAL cCodePP  := ''
	local hError 

	DEFAULT nCode :=  200

	IF !empty( cCode )

		mc_set( 'view', cFile ) 

		hError 	:= ErrorBlock( {| oError | MC_ErrorSys( oError, @cCode, cCodePP ), Break( oError ) } )
	
		mc_ReplaceBlocks( @cCode, "{{", "}}", nil, ... )			
		
		cHtml := mc_InlinePrg( @cCode, nil, ... )  
		
		IF valtype( cHtml ) == 'C' 
			::oResponse:SendHtml( cHtml, nCode )
		else			
			MC_MsgError( 'View', 'File: ' + cFile + '<br>Message: Bloc prg not return string'  )				
		endif

	ELSE
	
		//MC_MsgError( 'View', 'File: ' + cFile + '<br>Message: File is empty'  )				
	
	ENDIF				

RETU ''


//	-----------------------------------------------------------	//
//	Funcion para usar en los views...
//	-----------------------------------------------------------	//
/*
FUNCTION View( cFile, ... )

	LOCAL cCode := ''
	LOCAL oView := MC_Viewer():New()
	LOCAL oInfo := { => }
	LOCAL oExecute 
	
	oInfo[ 'file' ] := cFile
	
	App():cLastView := cFile 
	
	cCode := oView:Load( cFile )	
	
	zReplaceBlocks( @cCode, '{{', '}}', oInfo, ... )					
				

RETU cCode


FUNCTION Css( cFile )

	//	Por defecto la carpeta de los views estaran en src/view

	LOCAL cPath 		:= App():cPath + App():cPathCss
	LOCAL cCode 		:= ''
	LOCAL cFileCss

	__defaultNIL( @cFile, '' )
	
	cFileCss 			:= cPath + cFile
	
	LOG 'Css: ' + cFileCss
	LOG 'Existe fichero? : ' + ValToChar(file( cFileCss ))
	
	IF File ( cFileCss )
	
		cCode := '<style>' 
		cCode += MemoRead( cFileCss )
		cCode += '</style>'
		
	ELSE
	
		LOG 'Error: No existe Css: ' + cFileCss
			
		App():ShowError( 'No existe Css: ' +  cFileCss,  'Css Error!' )						
	
	ENDIF				

RETU cCode

FUNCTION Js( cFile )

	//	Por defecto la carpeta de los js estaran en js

	LOCAL cPath 		:= App():cPath + App():cPathJs
	LOCAL cCode 		:= ''
	LOCAL cFileJs

	__defaultNIL( @cFile, '' )
	
	cFileJs 			:= cPath + cFile
	
	LOG 'Css: ' + cFileJs
	LOG 'Existe fichero? : ' + ValToChar(file( cFileJs ))
	
	IF File ( cFileJs )
	
		cCode := '<script>'
		cCode += MemoRead( cFileJs )		
		cCode += '</script>'
		
	ELSE
	
		LOG 'Error: No existe Css: ' + cFileJs
			
		App():ShowError( 'No existe Js: ' +  cFileJs,  'Js Error!' )						
	
	ENDIF				

RETU cCode
*/