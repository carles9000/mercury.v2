#include 'mercury.ch' 

#define MAP_ID				1
#define MAP_RULE			2
#define MAP_CONTROLLER		3
#define MAP_METHOD			4

CLASS MC_Router 

	CLASSDATA oApp 
	CLASSDATA aMap 				INIT {}

	METHOD New( oApp )		CONSTRUCTOR
	
	METHOD Map( cId, cRule, cController, cMethod )
	METHOD Match( cRule, aRequest_Friendly, hParam )
	METHOD IsVariable( cParam, uValue )	
	METHOD IsOptional( cParam, uValue )	
	METHOD InfoController( cController )
	METHOD ExecuteController( hInfo, hParam, cMap )
	METHOD ExecuteCode( cFile )
	METHOD ExecuteClass( cCode, hParam )
	
	METHOD Listen()
	
	METHOD Show()
	METHOD MC_Tools()
	
	

ENDCLASS 

//	------------------------------------------------------------	//

METHOD New( oApp ) CLASS MC_Router 

	::oApp := oApp 
	
retu Self 

//	------------------------------------------------------------	//

METHOD Map( cId, cRule, cController, cMethod ) CLASS MC_Router

	DEFAULT cMethod := 'GET'

	
	Aadd( ::aMap, { cId, cRule, cController, cMethod } )


retu nil 

//	------------------------------------------------------------	//

METHOD Listen() CLASS MC_Router

	local nRoutes 					:= len( ::aMap )
	local cRequest_Method 		:= MC_Method()
	local aRequest_Friendly		:= MC_Url_Friendly()
	local aMethods 				:= {}
	local hParam 					:= {=>}
	local hId						:= {=>}
	local lRule					:= .f.
	local n, cId, cRule, cMap, cController, hInfo 



	//	Buscamos la regla que se ajuste a la url 

		for n := 1 to nRoutes
			
			aMethods := hb_ATokens( ::aMap[n][ MAP_METHOD ], "," )	
		
			if hb_HHasKey( hId, ::aMap[n][ MAP_ID ] )						
				
				MC_MsgError( 'Router', 'Duplicate Id: ' + ::aMap[n][ MAP_ID ] )				
				exit 
				
			else 
			
				hId[ ::aMap[n][ MAP_ID ] ] := nil	
				
				if Ascan( aMethods, cRequest_Method ) > 0
				
					cId		:= ::aMap[n][ MAP_ID ]		
					cRule 	:= ::aMap[n][ MAP_RULE ]	
				
					lRule	:= ::Match( cRule, aRequest_Friendly, @hParam )				
					
					if lRule	
						cMap := ::aMap[n]
			
						exit
					endif
				
				endif			
			
			endif
			
		next 
	
	
//	? 'Found', lRule, cMap, hParam 

	//	Si existe la regla, ejecutamos su controller 

		if lRule

			if ::InfoController( ::aMap[n], @hInfo )
			
				::ExecuteController( hInfo, hParam, cMap ) 
				
			endif 
			
		else 
		
			//	Check mercury@

			if len( aRequest_Friendly ) > 0 .and. substr( aRequest_Friendly[1], 1, 8 ) == 'mercury@'
				::MC_Tools( substr( aRequest_Friendly[1], 9 ) )
				retu nil
			endif		
			
		endif 
	

retu nil

//	------------------------------------------------------------	//

METHOD Match( cRule, aToken_Url, hParam ) CLASS MC_Router

	local aToken_Rule 	
	local lFound 			:= .f.
	local aRule 			:= {}	
	local uValue 			:= ''	
	local lRule			:= .t.
	local lEmpty			:= .t.
	local n, cParam, nParam, nOptional
	
	
	//	Si rule == '/'
		if cRule == '/'
			aToken_Rule 	:= { '/' }
		else
			aToken_Rule 	:= hb_ATokens( cRule, "/" )
		endif
		
	

	//	Analizamos parametros y cargamos regla 	

		hParam 	:= {=>}			//	Parameters () or []
		nParam 	:= 0
		nOptional 	:= 0
		
		if empty( aToken_Url )
			aToken_Url := { '/' }
		endif
		
		for n := 1  to len( aToken_Rule )
			
			cParam := aToken_Rule[n]
			uValue := ''
			
				
			do case
				case ::IsVariable( cParam, @uValue )	
				
					if ( nOptional > 0 ) .and. nOptional < n 
						lRule := .f.
						exit
					else 								
						Aadd( aRule, { 'v', uValue } )		//	[v]ariable
						nParam++
					endif
		
				case ::IsOptional( cParam, @uValue )	

					nOptional := n 
					
					Aadd( aRule, { 'o', uValue } )			//	[o]ptional
					
				otherwise	

					if ( nOptional > 0 ) .and. nOptional < n 				
						lRule := .f.
						exit					
					else 							
						Aadd( aRule, { '', cParam } )			//	[] Fixed
						nParam++
					endif
					
			endcase 
		
		
		next 


	//	Pre-validacion. 
	
		//	Regla es mala
		
		if ! lRule 	
			retu .f.
		endif
		
		//	Si hay mas tokens de URL que de Regla, es mala
		
		if len(aToken_Url) > len( aToken_Rule )		
			retu .f.
		endif
		
		
		//	Si los tokens de URL son menos que los mínimos valorar de la regla, es mala
		
		if len( aToken_Url ) < nParam
			retu .f.
		endif

	
	//	Parsear Regla...
	
		lFound 	:= .t. 
		lEmpty 	:= .f.
		n 			:= 1

	//	Hemos de valorar toda la url !
	//	Solo guardaremos los token variables/opcionales ()/[]
	
		while lFound .and. n <= len( aToken_Url )
			
			do case 
				case aRule[n][1] == '' 
				
					lFound := !lEmpty .and. aRule[n][2] == aToken_Url[n]
					
				case aRule[n][1] == 'v' 
				
					lFound := !lEmpty .and. !empty(  aToken_Url[n] )

					if lFound 
						hParam[ aRule[n][2] ] := aToken_Url[n]
					endif
					
				case aRule[n][1] == 'o' 
				
					lFound := !lEmpty .and. !empty(  aToken_Url[n] )
					
					if lFound
						hParam[ aRule[n][2] ] := aToken_Url[n]
					endif							

			endcase
		
			n++
			
		end 

retu lFound 

//	-------------------------------------------------------------------------	//	

METHOD IsVariable( cParam, uValue ) CLASS MC_Router

	local lIsVariable := ( Left( cParam, 1 ) == '(' .and. Right( cParam, 1 ) == ')' )
	
	if lIsVariable 
	
		uValue := Alltrim( Substr( cParam, 2, len( cParam ) - 2  )	)
	
	else 
	
		uValue := ''	
	
	endif 
	
retu lIsVariable 		

//	-------------------------------------------------------------------------	//	

METHOD IsOptional( cParam, uValue ) CLASS MC_Router

	local lIsOptional := ( Left( cParam, 1 ) == '[' .and. Right( cParam, 1 ) == ']' )
	
	if lIsOptional 
	
		uValue := Alltrim( Substr( cParam, 2, len( cParam ) - 2  )	)
	
	else 
	
		uValue := ''	
	
	endif 
	
retu lIsOptional 

//	-------------------------------------------------------------------------	//	

METHOD InfoController( aRoute, hInfo ) CLASS MC_Router

	local cId  		:= aRoute[ MAP_ID ]
	local cController := aRoute[ MAP_CONTROLLER ]
	local lAccept 		:= .t. 
	local cType, cExt, nPos, cFile
	
	hInfo 		:= {=>}
	
	hInfo[ 'id' ] 		:= cId
	hInfo[ 'rule' ] 	:= aRoute[ MAP_RULE ]
	hInfo[ 'type' ] 	:= ''
	hInfo[ 'file' ] 	:= ''
	hInfo[ 'class' ] 	:= ''
	hInfo[ 'method' ] 	:= ''
	

		nPos := At( '@', cController )
		
		if ( nPos >  0 )	//	Class
			
			hInfo[ 'type' ]	:= 'class'
			hInfo[ 'file' ] 	:= alltrim( Substr( cController, nPos+1 ) )									
			hInfo[ 'class' ]  	:= cFileNoExt( cFileNoPath( hInfo[ 'file' ] ) )
			hInfo[ 'method' ]  := alltrim( Substr( cController, 1, nPos-1) )
		
		else 
		
			cExt := lower(cFileExt( cController ))				

			hInfo[ 'file' ] 	:= cController
			
			do case
				case cExt == 'prg'
					
					hInfo[ 'type' ]	:= 'func'
					
				case cExt == 'view'
				
					hInfo[ 'type' ]	:= 'view'
					
			endcase		
		
		endif 
		
	//	Xec file 
	
	cFile := ::oApp:cApp_Path + ::oApp:cPathController + hInfo[ 'file' ]
	
	if ! file( cFile )
	
		lAccept := .f.
	
		MC_MsgError( 'Router', 'Id: ' + hInfo[ 'id' ] + '<br>Rule: ' + hInfo[ 'rule' ] + "<br>File prg don't exist: " +  cFile )				
					
	endif 
		
retu lAccept 

//	-------------------------------------------------------------------------	//	

METHOD ExecuteController( hInfo, hParam, cMap ) CLASS MC_Router

	local cFile, cCode 
	
	DEFAULT hParam := {=>}

		
	do case
		case hInfo[ 'type' ] == 'func'

			cFile := ::oApp:cApp_Path + ::oApp:cPathController + hInfo[ 'file' ]

			cCode :=  hb_memoread( cFile )
				
			::ExecuteCode( hInfo, cCode, hParam )
			
		case hInfo[ 'type' ] == 'class'	

			cFile := ::oApp:cApp_Path + ::oApp:cPathController + hInfo[ 'file' ]

			cCode := "#include 'hbclass.ch' "  + HB_OsNewLine()
			cCode += "#include 'hboo.ch' " + HB_OsNewLine() + HB_OsNewLine()
			cCode +=  hb_memoread( cFile )					
		
			::ExecuteClass( hInfo, cCode, hParam )

		otherwise 
		
			? '???'
	endcase 


retu nil

//	-------------------------------------------------------------------------	//	

METHOD ExecuteCode( hInfo, cCode, hParam ) CLASS MC_Router

	mh_Execute( cCode, hParam  )

retu nil 

//	-------------------------------------------------------------------------	//	

METHOD ExecuteClass( hInfo, cCode, hParam ) CLASS MC_Router
	local pSym, oHrb
	local cClass, oClass, hError
	local cCodePP := ''   
	local oController 
  	
	oController 	:= MC_Controller():New( hInfo[ 'method' ], hParam )

	oHrb 	:= MC_Compile( @cCode )

	WHILE !hb_mutexLock( MH_Mutex() )
	ENDDO	
	
	pSym := hb_hrbLoad( 2, oHrb )	//HB_HRB_BIND_OVERLOAD							

	
	hb_mutexUnlock( MH_Mutex() )	
	
	cClass := '{|oController| ' + hInfo[ 'class' ] + '():New( oController ) }' 								
	oClass := Eval( &( cClass ), oController )

 	
	if __objHasMethod( oClass, hInfo[ 'method' ] )		
		__ObjSendMsg( oClass, hInfo[ 'method' ], oController )	
	else 				
		MC_MsgError( 'Router',"Method doesn't exist: " + hInfo[ 'method' ] + ', Controller: ' + hInfo[ 'file' ]  )
	endif 
	
 	
	//ErrorBlock( hError )

retu nil 


//	-------------------------------------------------------------------------	//	

METHOD Show() CLASS MC_Router

	MC_Msg_Table( 'Route define',;
				{ 'Id', 'Rule', 'Controller', 'Method' },;
				::aMap )

retu nil 

//	-------------------------------------------------------------------------	//	

METHOD MC_Tools( cTag ) CLASS MC_Router

/*	
	local lIs_Mercury := .t.
	local hData := {=>}
	
	if lIs_Mercury
		hData[ '<a href="https://github.com/carles9000/mercury">mercury@site</a>' ] 			:= 'Mercury Site'
		hData[ '<a href="mercury@info">mercury@info</a>' ] 			:= 'Information System'
		hData[ '<a href="mercury@log">mercury@log</a>' ] 			:= 'System log'
		hData[ '<a href="mercury@apachelog">mercury@apachelog</a>' ]		:= 'System log Apache (Error)'
		hData[ '<a href="mercury@hrb-router" onclick="return confirm(' + "'Are you sure?'" + ')" >mercury@hrb-router</a>' ]	:= 'Compile router'
		hData[ '<a href="mercury@hrbs" onclick="return confirm(' + "'Are you sure?'" + ')" >mercury@hrbs</a>' ]				:= 'Compile Project: route, controller & models to hrbs files'
	else 
		hData[ '<a href="https://github.com/carles9000/mercury">mercury@site</a>' ] 			:= 'Mercury Site'
		hData[ '<a href="mercury@info">mercury@info</a>' ] 			:= 'Information System'				
	endif
	
	MC_Message( 'Mercury Help', hData )	
*/	

retu nil

//	-------------------------------------------------------------------------	//	

FUNCTION  MC_Route( cRoute, aParams ) 

	LOCAL cUrl 	:= ''
	LOCAL oRouter 	:= MC_GetApp():oRouter
	LOCAL aMap 	:= oRouter:aMap
	LOCAL nLen 	:= len(aMap)
	LOCAL lFound 	:= .F. 
	LOCAL n, nPos, aRoute 
	local cRule, aToken_Rule, cToken 

	DEFAULT aParams := {=>}

	//	Buscamos en el mapa, la ruta con ID == cRoute

		FOR n := 1 to nLen 
		
			IF aMap[n][ MAP_ID ] == cRoute
				aRoute := aMap[n]
				lFound := .t.
				exit
			ENDIF 
		
		NEXT 
		
		if ! lFound
			retu ''
		endif
	
	//	Tokenizamos la regla de la url 
	
		cRule 	:= aRoute[ MAP_RULE ]

		//	Si rule == '/'
		if cRule == '/'
			aToken_Rule 	:= { '/' }
		else
			aToken_Rule 	:= hb_ATokens( cRule, "/" )
		endif
		
		if empty( aToken_Rule )
			aToken_Rule := { '/' }
		endif		
		
	//	Creamos la Url a partir de los tokens de la regla 
	//	y sustituyendo los obligatorios/opcionales por los
	//	parámetros recibidos 
	
		nPos := 0 
		
		for n := 1 to len( aToken_Rule )
		
			cToken := aToken_Rule[n]
			
			if  oRouter:IsVariable( cToken ) .or. oRouter:IsOptional( cToken )	
			
				nPos++ 
				
				if nPos <= len( aParams )
				
					cUrl += '/' + mh_valtochar( aParams[nPos] )
					
				else 
				
					exit 
				endif 
				
			else 				
				
				cUrl += '/' + cToken 
				
			endif 			
		
		next 	
		
		cUrl := Substr( cUrl, 2 )		//	Eliminamos primera /

retu cUrl  


//	-------------------------------------------------------------------------	//	

FUNCTION  MC_RouteToController( cRoute )  //	Controller/View

	LOCAL cUrl 	:= ''
	LOCAL oRouter 	:= MC_GetApp():oRouter
	LOCAL aMap 	:= oRouter:aMap
	LOCAL aRoute
	
	__defaultNIL( @cRoute, '' )		
	
	FOR EACH aRoute IN aMap
	
		IF aRoute[ MAP_ID ] == cRoute
			retu aRoute[ MAP_CONTROLLER ]
		ENDIF				
		
	NEXT	

RETU ''

//	-------------------------------------------------------------------------	//	

/*
FUNCTION MC_RouteToUrl( cRoute, lDirBase )  //	Controller/View

	LOCAL oRouter 	:= MC_GetApp():oRouter
	LOCAL aMap 	:= oRouter:aMap
	LOCAL aRoute
	
	__defaultNIL( @cRoute, '' )		
	__defaultNIL( @lDirBase, .F. )		
	
	FOR EACH aRoute IN aMap
	
		IF aRoute[ MAP_ID ] == cRoute
			if lDirBase				
				retu ( MC_App_Url() + '/' + aRoute[ MAP_URL] )
			else
				retu aRoute[ MAP_URL ]
			endif
		ENDIF				
		
	NEXT	
	
RETU ''
*/

//	-------------------------------------------------------------------------	//	

function _e( ... )
	ap_RPuts( '<code>' + MH_Out( 'web', ... ) + '</code>' )
retu nil
