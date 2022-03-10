/*
	Via: cookie, query, bearer token, basic auth, api key
	Type: jwt, token
	cOut: html, json
	error route: url 
	error json: { error:  , msg: }	
*/


//	-----------------------------------------------------------	//

CLASS MC_Middleware

	CLASSDATA cVia			          					INIT 'cookie'			
	CLASSDATA cType			          					INIT 'jwt'			
	CLASSDATA cName			          					INIT 'mc_v2'			
	CLASSDATA cOut 			          					INIT 'html'			
	CLASSDATA cUrl_Redirect          					INIT ''			
	CLASSDATA hError									INIT {=>}		
	CLASSDATA cPsw 			          					INIT 'mcV2!2022@'				
	CLASSDATA nTime			     						INIT 3600
	CLASSDATA bValid 
	
	DATA lAuth											INIT .F. 
	DATA hData											INIT {=>}
	
	DATA cargo											INIT ''		
	
	DATA oController									
	DATA oRequest				
	DATA oResponse				
	
	METHOD New( cAction, hPar ) 						CONSTRUCTOR
	METHOD Define( cVia, cType, cName, cPsw, cOut, cUrl_Redirect, hError, bValid ) CONSTRUCTOR 
	
	
	
	METHOD Valid()
	METHOD GetData()									INLINE if( ::lAuth, ::hData, nil )
	
	METHOD OutErrorHtml()
	METHOD OutErrorJson()
	
	METHOD GetAuthorization( cType )	
	
	METHOD SetJWT( hData, nTime )
	METHOD SetToken( uData )

	METHOD SendToken( cToken, nTime, cVia, cType  )	
	
	METHOD DeleteToken()

	METHOD Dbg()
	
ENDCLASS 

METHOD New( oRequest, oResponse ) CLASS MC_Middleware	

	::oResponse 	:= mc_Response():New()
	::oRequest  	:= mc_Request():New()


RETU Self


//	--------------------------------------------------------------------------

METHOD Define( cVia, cType, cName, cPsw, nTime, cOut, cUrl_Redirect, hError, bValid ) CLASS MC_Middleware

	
	DEFAULT cVia 			:= 'cookie'
	DEFAULT cType 			:= 'jwt'
	DEFAULT cName 			:= 'v2_auth'
	DEFAULT cPsw 			:= 'MC@2022!AutH'
	DEFAULT nTime 			:= 3600
	DEFAULT cOut			:= 'html'
	DEFAULT cUrl_Redirect	:= ''
	DEFAULT hError			:= { 'error' => .t., 'msg' => 'unauthorized.' }
	
	

	::cVia 					:=	lower(cVia)
	
	if 	cVia == 'bearer token' .or. ;
		cVia == 'basic auth' .or. ;
		cVia == 'api key'
	
		cType := 'func'
		
	endif			
	
	::cType 				:=  cType 		
	::cName 				:=  cName 		
	::cPsw 					:=  cPsw 			
	::nTime 				:=  nTime
	::cOut					:=  cOut			
	::cUrl_Redirect		:=  cUrl_Redirect
	::hError				:=  hError		
	::bValid 				:=  bValid


RETU Self 

//	--------------------------------------------------------------------------


METHOD Dbg() CLASS MC_Middleware 

	_d( ::cVia 			)
	_d( ::cType 		)
	_d( ::cName 		)
	_d( ::cPsw 			)
	_d( ::nTime 		)
	_d( ::cOut			)
	_d( ::cUrl_Redirect)
	_d( ::hError		)
    _d( ::bValid 		)

RETU NIL 

//	--------------------------------------------------------------------------


METHOD Valid() CLASS MC_Middleware 

	local cToken	:= ''
	local cUrl 	:= ''		
	local cHtml	:= ''
	local oJwt
	local cRealToken, cData

	::hData := {=>}
	::lAuth := .f.


	do case
		case ::cVia == 'cookie' 
		
			cToken := mh_GetCookies( ::cName )
			
		case ::cVia == 'query' 		
			
			cToken := ::oRequest:Request( ::cName )			
			
		case ::cVia == 'bearer token' 		
			
			cToken := ::GetAuthorization( 'bearer token' )
			
		case ::cVia == 'basic auth' 		
		
			cToken := ::GetAuthorization( 'basic auth' )
			
		case ::cVia == 'api key' 		
			
			cToken := ::GetAuthorization( 'api key', ::cName )															

	endcase
	
//_d( 'VALID' )
//	::Dbg()
//_d( 'VIA ' + ::cVia  )
//_d( 'TYPE ' + ::cType  )
//_d( 'TOKEN', cToken  )
	
	if !empty( cToken )
	
		do case
			case ::cType == 'jwt'
	
				oJWT 		:= MC_JWT():New( ::cPsw ) 	
				::lAuth 	:= oJWT:Decode( cToken )

				if ::lAuth				
					::hData := oJWT:GetData()
					
					cToken 	:= oJWT:Refresh()	
					
					::SendToken( cToken )	//	Refresh Cookie
					
					
				endif 
				
			case ::cType == 'token'
			
				cRealToken := hb_StrReplace( cToken, '-_',  '+/' )	
				cRealToken := hb_base64Decode( cRealToken )			
	
				cData := hb_blowfishDecrypt( hb_blowfishKey( ::cPsw ), cRealToken )					
				
				::lAuth := if( cData == nil, .f., .t. )

				if ::lAuth				
					::hData := hb_jsondecode( cData )
					
					::SendToken( cToken )	//	Refresh Cookie
					
				endif							
				
			case ::cType == 'func'
			
				if valtype( ::bValid ) == 'B' 
					::lAuth 	:= Eval( ::bValid, cToken )
					::lAuth 	:= if( Valtype( ::lAuth ) == 'L', ::lAuth, .f. )
					
				endif 
		endcase  
	
	endif 


	if !::lAuth 
	
		
		
		do case
			case ::cVia == 'cookie' 	
			
				do case 
					case ::cOut == 'html'
					
						::OutErrorHtml()
					
					case ::cOut == 'json'
					
						::OutErrorJson()
				endcase
		
			case ::cVia == 'query' 	
			
				do case 
					case ::cOut == 'html'
					
						::OutErrorHtml()
					
					case ::cOut == 'json'
					
						::OutErrorJson()
				endcase

			otherwise 
			
				do case 
					case ::cOut == 'html'
					
						::OutErrorHtml()
					
					case ::cOut == 'json'
					
						::OutErrorJson()
				endcase			
			
			
		endcase
	
	endif 				

RETU ::lAuth

//	---------------------------------------------------------------------------

METHOD GetAuthorization( cType, cName ) CLASS MC_Middleware 

	
	local cHeader  	
	local cToken 		:= ''
	local nPos 
	
	DEFAULT cType := ''
	
	
	do case
		case cType == 'bearer token'
			cHeader  	:= ::oRequest:GetHeader( 'Authorization' )	

			nPos := At( 'Bearer', cHeader )
			
			if nPos > 0 
				cToken := alltrim(Substr( cHeader, 7 ))				
			endif				
			
		case cType == 'basic auth'
			cHeader  	:= ::oRequest:GetHeader( 'Authorization' )	

			nPos := At( 'Basic', cHeader )
			
			if nPos > 0 
				cToken := alltrim(Substr( cHeader, 6 ))	
				cToken := hb_base64Decode(cToken) 
			endif				
			
		case cType == 'api key'
		
			cToken  	:= ::oRequest:GetHeader( cName )	
		
	endcase
	
	//_d( 'GetAuthorization' )
	//_d( ::oRequest:hHeaders )

retu cToken 

//	---------------------------------------------------------------------------


METHOD OutErrorHtml() CLASS MC_Middleware 

	local cUrl 

	if empty( ::cUrl_Redirect )

		mh_ExitStatus( CODE_UNAUTHORIZED )
		ap_RPuts( '' )
		
		quit
		
	else 


		cUrl := MC_Route( ::cUrl_Redirect )		

		if empty( cUrl )				
			
			MC_MsgError( 'middleware', "Doesn't exist route ==> " + ::cUrl_Redirect )
			
		else
			
			AP_HeadersOutSet( "Location", cUrl  )
			
			mh_ExitStatus( CODE_REDIRECTION  )
			
			quit
			
		endif
	
	endif	
	
retu nil 	


METHOD OutErrorJson() CLASS MC_Middleware 
	
	::oResponse:SendJson( ::hError )
	
retu nil 	

//	--------------------------------------------------------------------------

METHOD SetJWT( hData, nTime ) CLASS MC_Middleware

	local oJWT 		:= MC_JWT():New( ::cPsw )	
	local cToken 

	DEFAULT hData := {=>}		
	DEFAULT nTime := ::nTime

	//	Crearemos un JWT. Default system 3600
		
		oJWT:SetTime( nTime )			
	
		
	//	Añadimos datos al token...
	
		oJWT:SetData( hData )										
		
	//	Cremos Token
	
		cToken := oJWT:Encode()		
	
	
	//	Preparamos la Cookie. NO se envia aun, hasta que haya un sendhtml()...

		::SendToken( cToken, nTime )				

retu cToken  

//	--------------------------------------------------------------------------

METHOD SetToken( uData, nTime ) CLASS MC_Middleware
	
	local cKey 		:= hb_blowfishKey( ::cPsw )		
	local cToken 	

	DEFAULT nTime := ::nTime
	
	if valtype( uData ) != 'H'
		uData := { 'data' => uData }
	endif 

	uData	:= hb_jsonencode( uData )	
	
	cToken 	:= hb_base64Encode( hb_blowfishEncrypt( cKey, uData )	)
	cToken 	:= hb_StrReplace( cToken, '+/', '-_' )


	::SendToken( cToken, nTime )
	
retu cToken  

//	--------------------------------------------------------------------------

METHOD SendToken( cToken, nTime ) CLASS MC_Middleware	
	
	DEFAULT nTime 	:= ::nTime

	do case
		case ::cVia == 'cookie' 
			
			MH_SetCookie( ::cName, cToken, nTime ) 		
		
	endcase				
	
retu .t. 

//	--------------------------------------------------------------------------

METHOD DeleteToken() CLASS MC_Middleware

	
	do case
		case ::cVia == 'cookie' 
		
			MH_SetCookie( ::cName, '', -1 ) 


		
	endcase			
	
retu .t. 

//	--------------------------------------------------------------------------


