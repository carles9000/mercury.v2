
//	-----------------------------------------------------------	//

CLASS MC_Middleware

	CLASSDATA cType			          					INIT ''			
	CLASSDATA cVia			          					INIT ''			
	CLASSDATA cErrorRoute	          					INIT ''			
	CLASSDATA cMsg			          					INIT ''			
	
	CLASSDATA cPsw 			          					INIT 'mcV2!2022@'			
	CLASSDATA cId_Cookie           					INIT 'MC_V2'						
	CLASSDATA nTime			     						INIT 3600
	
	DATA hData				
	DATA lAutenticate				
	
	
	
	
	DATA oController									
	DATA oRequest				
	DATA oResponse				
	DATA hTokenData				
	DATA cError 										INIT ''				
					
					

	
	METHOD New( cAction, hPar ) 						CONSTRUCTOR
	
	METHOD Exec( cVia, cType, cErrorRoute, hError, lJson, cMsg )
	
	METHOD GetTokenCookie()	
	METHOD GetTokenHeader()	
	
	METHOD ValidateJWT()	
	METHOD Unauthorized()
	
	//METHOD SetJWT( hData, nTime )
	
	METHOD SetTokenJWT( hData, nTime )
	
	METHOD SendToken( cToken )
	METHOD DeleteToken()
	
ENDCLASS 

METHOD New( oRequest, oResponse ) CLASS MC_Middleware	


	::cVia 			:= 'cookie'
	::cType		:= 'jwt'

	::oResponse 	:= oResponse
	::oRequest  	:= oRequest

RETU Self


METHOD Exec( cVia, cType, cErrorRoute, hError, lJson, cMsg ) CLASS MC_Middleware

	local lValidate 	:= .F.
	local cToken
	
	//LOCAL oResponse 	:= App():oResponse
	//LOCAL cUrl

	__defaultNIL( @cVia, 'cookie' )		//	Por defecto habria de ser 'cookie'
	__defaultNIL( @cType, 'jwt' )	
	__defaultNIL( @cErrorRoute, '' )		
	__defaultNIL( @hError, { 'success' => .f., 'error' => 'Error autentication' } )		
	__defaultNIL( @lJson, .F. )		
	__defaultNIL( @cMsg, '' )		
	
	::cVia 			:= lower( cVia )
	::cType 		:= lower( cType )
	::cErrorRoute	:= lower( cErrorRoute )
	::cMsg			:= cMsg
	
	::lAutenticate := .f.
	
_d( 'Exec' )	
	//	Recover token 
_d( 'VIA ' +  ::cVia)	
		do case
			case ::cVia == 'cookie' ; cToken := ::GetTokenCookie() 				
			case ::cVia == 'header' ; cToken := ::GetTokenHeader()
		endcase
	
_d( 'TOKEN: ' + cToken )

		if empty( cToken )
		_d( 'buid')
			::Unauthorized() 
			retu .f.
		endif 
	
	//	Validate 
	
	
		do case
			case ::cType =='jwt'  ; ::lAutenticate := ::ValidateJWT( cToken )		
		endcase 		
		
	
	_d( 'AUTENTICATE', ::lAutenticate )
	
	if !::lAutenticate
		_d( 'Surtu amb NIL')
		retu .f.
	endif 
	
retu .t.

//	--------------------------------------------------------------------------

METHOD GetTokenCookie() CLASS MC_Middleware

retu ::oRequest:GetCookie( ::cId_Cookie )
	

//	--------------------------------------------------------------------------

METHOD GetTokenHeader() CLASS MC_Middleware

	local cHeader 	:= ::oRequest:GetHeader( 'Authorization' )
	local cToken 	:= ''
	local nPos 
	
	do case
		case ::cType == 'bearer'
		
			nPos := At( 'Bearer', cHeader )
			
			if nPos > 0 
				cToken := alltrim(Substr( cHeader, 7 ))				
			endif				
		
	endcase 

retu cToken


//	--------------------------------------------------------------------------

METHOD ValidateJWT( cToken ) CLASS MC_Middleware
	
	local oJWT, lValid, nLapsus	
_d( 'ValidateJWT' )
	::hData := {=>}	
	
	if empty( cToken )
		::Unauthorized()
		RETU .F.		
	endif	
	
	oJWT 	:= MC_JWT():New( ::cPsw ) 	
	lValid 	:= oJWT:Decode( cToken )						

_d( 'VALID', lValid )

	IF ! lValid
	
		::Unauthorized()
		
		retu .F.
		
	ELSE
	
		//	En este punto tenemos el token decodificado dentro del objeto oJWT
		
			::hData := oJWT:GetData()
_d( 'DATA', ::hData )			
		//	Consultamos el lapsus que hay definidio, para ponerla en la nueva cookie
		
			nLapsus 	:= oJWT:GetLapsus()
_d( 'LAPSUS', nLapsus )
	
		//	Si el Token es correcto, prepararemos el sistema para que lo refresque cuando genere una nueva salida

			cToken 	:= oJWT:Refresh()		//	Vuelve a crear el Token teniendo en cuenta el lapsus
			
		//	Crearemos una cookie con el JWT, con el mismo periodo			
		
			::oResponse:SetCookie( ::cId_Cookie, cToken, nLapsus )
		
			retu .T.
			
		
	ENDIF				

retu .t. 

//	--------------------------------------------------------------------------

METHOD Unauthorized() CLASS MC_Middleware

	local cUrl 
	local oViewer
	local oApp		:= MC_GetApp()
	
	//_d( oApp )
	_d( oApp:CAPP_URL )

_d( 'Unauthorized', ::cErrorRoute )
	do case
	
		case !empty( ::cErrorRoute )
		
			oViewer := MC_Viewer():New()

			if right( ::cErrorRoute, 5 ) == '.view'
			
				//	Borrar cookie

					::oResponse:SetCookie( ::cId_Cookie, '', -1 )						

				//	Redireccionamos pantalla incial
				
					//::oController:View( ::cErrorRoute, ::cMsg )
					oViewer:Exec( ::cErrorRoute, ::cMsg )
					
				
			else 
			
				cUrl := MC_Route( ::cErrorRoute )		
_d( 'Routing to ' + cUrl )				

				if empty( cUrl )
				
					
					MC_MsgError( 'middleware', "Doesn't exist route ==> " + ::cErrorRoute )
					
				else
				
					cUrl := oApp:CAPP_URL + cUrl 
				
					if !empty( ::cMsg )
						cUrl += '?' + ::cMsg 
					endif
					
_d('Redirecciono a ' + cUrl )					
					::oResponse:Redirect( cUrl )
					//oViewer:Exec( cUrl, ::cMsg )
_d( 'Oks redirect' )					
					
_d( 'He fet quit' )					
				endif						
				
			endif		
		
	endcase 

retu nil 


//	--------------------------------------------------------------------------

METHOD SetTokenJWT( hData, nTime ) CLASS MC_Middleware

	local oJWT 		:= MC_JWT():New( ::cPsw )	
	local cToken 

	__defaultNIL( @hData, {=>} )		
	
	DEFAULT nTime := ::nTime

	//	Crearemos un JWT. Default system 3600
		
		oJWT:SetTime( ::nTime )			
		
	//	Añadimos datos al token...

		oJWT:SetData( hData )										
		
	//	Cremos Token
	
		cToken := oJWT:Encode()		
	
	
	//	Preparamos la Cookie. NO se envia aun, hasta que haya un sendhtml()...

		//::oResponse:SetCookie( ::cId_Cookie, cToken, ::nTime )
		//::oResponse:Echo()
		
			

retu cToken  

//	--------------------------------------------------------------------------

METHOD SendToken( cToken ) CLASS MC_Middleware

	DEFAULT cToken := '' 
	
_d( 'SENDTOKEN' )	
_d( 'type ' + ::cType )	

	if empty( cToken )
	
		do case
			case ::cType =='jwt'  ; cToken  := ::SetTokenJWT()		
		endcase 
	endif 
	
_d( cToken  )	
	if empty( cToken )
		retu .f.
	endif
	

_d( 'Via ' + ::cVia )
	
	do case
		case ::cVia == 'cookie' 
		
			MH_SetCookie( ::cId_Cookie, cToken, ::nTime ) 
			
		case ::cVia == 'header' 
		
	endcase			
	

_d( 'SENDTOKEN END' )	
retu .t. 


//	--------------------------------------------------------------------------

METHOD DeleteToken() CLASS MC_Middleware

	
_d( 'DeleteToken' )	


_d( 'Via ' + ::cVia )
	
	do case
		case ::cVia == 'cookie' 
		
			MH_SetCookie( ::cId_Cookie, '', -1 ) 
			
		case ::cVia == 'header' 
		
	endcase			
	

_d( 'DeleteToken END' )	
retu .t. 


