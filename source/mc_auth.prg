/*

	Via: cookie, parameter, header
	Type: jwt, token
	cOut: html, json
	error route: url 
	error json: { error:  , msg: }
	

*/




CLASS mc_Auth 	

	DATA cNameSpace 									INIT ''
	DATA lAuth											INIT .F. 
	DATA hData											INIT {=>}

	METHOD New()										CONSTRUCTOR 
	
	METHOD Define( cNameSpace, cVia, cType, cName, cPsw, cOut, cUrl_Redirect, hError )	CONSTRUCTOR 
	
	METHOD Valid()
	METHOD GetData()									INLINE if( ::lAuth, ::hData, nil )
	
	METHOD OutErrorHtml()
	METHOD OutErrorJson()
	
	METHOD GetAuthorization( cType )
	
ENDCLASS 

METHOD New( cNameSpace ) CLASS mc_Auth 

	DEFAULT cNameSpace 	:= 'MC_APP'		
	
	::cNameSpace := lower( cNameSpace )

_d( 'NEW',_hCredentials )	
	
	
	if _hCredentials == nil 
		_hCredentials := {=>}
	endif 	
	
	if ! HB_HHasKey( _hCredentials, ::cNameSpace )		
		MC_MsgError( 'Auth', 'Namespace: ' + ::cNameSpace + ', dont defined' )				
		retu nil 
	endif
	
	
retu SELF  

METHOD Define( cNameSpace, cVia, cType, cName, cPsw, cOut, cUrl_Redirect, hError ) CLASS mc_Auth 

	DEFAULT cNameSpace 	:= 'MC_APP'
	DEFAULT cVia 			:= 'cookie'
	DEFAULT cType 			:= 'jwt'
	DEFAULT cName 			:= 'v2_auth'
	DEFAULT cPsw 			:= 'MC@2022!AutH'
	DEFAULT cOut			:= 'html'
	DEFAULT cUrl_Redirect	:= ''
	DEFAULT hError			:= { 'error' => .t., 'msg' => 'unauthorized.' }

	if _hCredentials == nil 
		_hCredentials := {=>}
	endif 
	
	cNameSpace := lower( cNameSpace )
	
_d( 'DEFINE', cNameSpace)	

	
	_hCredentials[ cNameSpace ] := { 'via' => lower( cVia ), 'type' => cType, 'name' => cName, 'psw' => cPsw, 'out' => cOut, 'url_redirect' => cUrl_Redirect, 'error_json' => hError }
	

_d( _hCredentials )	
	

RETU Self 

METHOD Valid() CLASS mc_Auth 

	local cToken	:= ''
	local cUrl 	:= ''		
	local cHtml	:= ''
	local oJwt, oRequest

	::hData := {=>}
	::lAuth := .f.

	do case
		case _hCredentials[ ::cNameSpace ][ 'via' ] == 'cookie' 
		
			cToken := mh_GetCookies( _hCredentials[ ::cNameSpace ][ 'name' ] )
			
		case _hCredentials[ ::cNameSpace ][ 'via' ] == 'query' 
		
			oRequest := mc_Request():New()
			cToken := oRequest:Request( _hCredentials[ ::cNameSpace ][ 'name' ] )			
			
		case _hCredentials[ ::cNameSpace ][ 'via' ] == 'bearer token' 		
			
			cToken := ::GetAuthorization( 'bearer token' )
			
		case _hCredentials[ ::cNameSpace ][ 'via' ] == 'basic auth' 		
		
			cToken := ::GetAuthorization( 'basic auth' )
			
		case _hCredentials[ ::cNameSpace ][ 'via' ] == 'api key' 		
			
			cToken := ::GetAuthorization( 'api key', _hCredentials[ ::cNameSpace ][ 'name' ] )															

	endcase
	
	if !empty( cToken )
	
		do case
			case _hCredentials[ ::cNameSpace ][ 'type' ] == 'jwt'
	
				oJWT 		:= MC_JWT():New( _hCredentials[ ::cNameSpace ][ 'psw' ] ) 	
				::lAuth 	:= oJWT:Decode( cToken )

				if ::lAuth				
					::hData := oJWT:GetData()
				endif 
				
		endcase  
	
	endif 
	

	if !::lAuth 
	
		do case
			case _hCredentials[ ::cNameSpace ][ 'via' ] == 'cookie' 	
			
				do case 
					case _hCredentials[ ::cNameSpace ][ 'out' ] == 'html'
					
						::OutErrorHtml()
					
					case _hCredentials[ ::cNameSpace ][ 'out' ] == 'json'
					
						::OutErrorJson()
				endcase
		
			case _hCredentials[ ::cNameSpace ][ 'via' ] == 'parameter' 	
			
				do case 
					case _hCredentials[ ::cNameSpace ][ 'out' ] == 'html'
					
						::OutErrorHtml()
					
					case _hCredentials[ ::cNameSpace ][ 'out' ] == 'json'
					
						::OutErrorJson()
				endcase		
			
		endcase
	
	endif 				

RETU ::lAuth


METHOD GetAuthorization( cType, cName ) CLASS mc_Auth 

	local oRequest 	:= mc_Request():New()
	local cHeader  	
	local cToken 		:= ''
	local nPos 
	
	DEFAULT cType := ''
	
	
	do case
		case cType == 'bearer token'
			cHeader  	:= oRequest:GetHeader( 'Authorization' )	

			nPos := At( 'Bearer', cHeader )
			
			if nPos > 0 
				cToken := alltrim(Substr( cHeader, 7 ))				
			endif				
			
		case cType == 'basic auth'
			cHeader  	:= oRequest:GetHeader( 'Authorization' )	

			nPos := At( 'Basic', cHeader )
			
			if nPos > 0 
				cToken := alltrim(Substr( cHeader, 6 ))	
				cToken := hb_base64Decode(cToken) 
			endif				
			
		case cType == 'api key'
		
			cToken  	:= oRequest:GetHeader( cName )	
		
	endcase
	
	_d( cType )
	_d( oRequest:hHeaders )
	//_d( oRequest:RequestAll() )
	//_d( cToken )
	_d( 'TOKEN', cToken )	
	


retu cToken 

METHOD OutErrorHtml() CLASS mc_Auth 

	local cUrl 

	if empty( _hCredentials[ ::cNameSpace ][ 'url_redirect' ] )

		mh_ExitStatus( CODE_UNAUTHORIZED )
		
		quit
		
	else 


		cUrl := MC_Route( _hCredentials[ ::cNameSpace ][ 'url_redirect' ] )		

		if empty( cUrl )				
			
			MC_MsgError( 'middleware', "Doesn't exist route ==> " + _hCredentials[ ::cNameSpace ][ 'url_redirect' ] )
			
		else
			
			AP_HeadersOutSet( "Location", cUrl  )
			
			mh_ExitStatus( CODE_REDIRECTION  )
			
			quit
			
		endif
	
	endif	
	
retu nil 	


METHOD OutErrorJson() CLASS mc_Auth 

	local cUrl 
	local oResponse := mc_Response():New()
	
	oResponse:SendJson( _hCredentials[ ::cNameSpace ][ 'error_json' ] )

	
retu nil 	
			
			