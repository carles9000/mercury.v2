
//	-----------------------------------------------------------	//

CLASS MC_Middleware

	CLASSDATA cType			          					INIT ''			
	CLASSDATA cVia			          					INIT ''			
	CLASSDATA cErrorView	          					INIT ''			
	CLASSDATA cPsw 			          					INIT 'mcV2!2022@'			
	CLASSDATA cId_Cookie           					INIT 'MC_V2'						
	CLASSDATA nTime			     						INIT 3600
	
	DATA hData				
	
	
	
	
	DATA oController									
	DATA oRequest				
	DATA oResponse				
	DATA hTokenData				
	DATA cError 										INIT ''				
					
					

	
	METHOD New( cAction, hPar ) 						CONSTRUCTOR
	
	METHOD Exec( oController, cVia, cType, cErrorView, hError, lJson, cMsg )
	
	METHOD GetTokenCookie()	
	METHOD GetTokenHeader()	
	
	METHOD ValidateJWT()	
	METHOD Unauthorized()
	
	METHOD SetJWT( hData, nTime )
	
ENDCLASS 

METHOD New( oRequest, oResponse ) CLASS MC_Middleware	

	::oResponse := oResponse
	::oRequest  := oRequest

RETU Self


METHOD Exec( oController, cVia, cType, cErrorView, hError, lJson, cMsg ) CLASS MC_Middleware

	local lValidate 	:= .F.
	local cToken
	
	//LOCAL oResponse 	:= App():oResponse
	//LOCAL cUrl

	__defaultNIL( @cVia, '' )		//	Por defecto habria de ser 'jwt'
	__defaultNIL( @cType, '' )	
	__defaultNIL( @cErrorView, '' )		
	__defaultNIL( @hError, { 'success' => .f., 'error' => 'Error autentication' } )		
	__defaultNIL( @lJson, .F. )		
	__defaultNIL( @cMsg, '' )		
	
	::cType 		:= lower( cType )
	::cVia 			:= lower( cVia )
	::cErrorView	:= lower( cErrorView )
	
_d( 'Exec' )	
	//	Recover token 
	
		do case
			case cVia == 'cookie' 
				cToken := ::GetTokenCookie() 
				
			case cVia == 'header' 
				cToken := ::GetTokenHeader()
		endcase
	
_d( cToken )
	
	//	Validate 
	
	
		do case
			case ::cVia =='jwt'  ; ::ValidateJWT( cToken )
		
		endcase 
	
	
	
retu self

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

	::hData := {=>}	
	
	if empty( cToken )
		::Unauthorized()
		RETU .F.		
	endif	
	
	oJWT 	:= MC_JWT():New( ::cPsw ) 	
	lValid 	:= oJWT:Decode( cToken )						


	IF ! lValid
	
		::Unauthorized()
		
		retu .F.
		
	ELSE
	
		//	En este punto tenemos el token decodificado dentro del objeto oJWT
		
			::hData := oJWT:GetData()
			
		//	Consultamos el lapsus que hay definidio, para ponerla en la nueva cookie
		
			nLapsus 	:= oJWT:GetLapsus()

	
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

	do case
	
		case !empty( ::cErrorView )

			if right( ::cErrorView, 5 ) == '.view'
			
				//	Borrar cookie

					::oResponse:SetCookie( ::cId_Cookie, '', -1 )						

				//	Redireccionamos pantalla incial
				
					::oController:View( ::cErrorView, ::cMsg )
				
			else 
			
				cUrl := MC_Route( ::cErrorView )				

				if empty( cUrl )
				
					if !empty( ::cMsg )
						cUrl += '?' + ::cMsg 
					endif
					
					MC_MsgError( 'middleware', "Doesn't exist route ==> " + ::cErrorView )
				else
					::oResponse:Redirect( cUrl )
				endif
			
			endif
		
		
	endcase 

retu nil 

//	--------------------------------------------------------------------------

METHOD SetJWT( hData, nTime ) CLASS MC_Middleware

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

		::oResponse:SetCookie( ::cId_Cookie, cToken, ::nTime )
		::oResponse:Echo()
		
RETU cToken


