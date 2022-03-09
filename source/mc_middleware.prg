
//	-----------------------------------------------------------	//

CLASS MC_Middleware

	CLASSDATA cVia			          					INIT 'cookie'			
	CLASSDATA cType			          					INIT 'jwt'			
	CLASSDATA cErrorRoute	          					INIT ''			
	CLASSDATA nErrorCode	          					INIT 401
	CLASSDATA cMsg			          					INIT ''			
	
	CLASSDATA cPsw 			          					INIT 'mcV2!2022@'			
	CLASSDATA cId_Cookie           					INIT 'MC_V2'						
	CLASSDATA nTime			     						INIT 3600
	
	DATA hData				
	DATA lAutenticate				
	
	DATA cargo											INIT ''
	
	
	
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
	METHOD Validate()	
	
	METHOD Unauthorized()
	
	METHOD SetJWT( hData, nTime )
	METHOD SetToken( uData )
	
	METHOD SendToken( cToken )
	METHOD DeleteToken()
	
	METHOD GetData()									INLINE ::hData
	
ENDCLASS 

METHOD New( oRequest, oResponse ) CLASS MC_Middleware	


	::oResponse 	:= oResponse
	::oRequest  	:= oRequest

RETU Self


METHOD Exec( cVia, cType, cErrorRoute, nErrorCode, hError, aParams, nTime ) CLASS MC_Middleware

	local lValidate 	:= .F.
	local cToken


	__defaultNIL( @cVia, 'cookie' )		//	Por defecto habria de ser 'cookie'
	__defaultNIL( @cType, 'jwt' )	
	__defaultNIL( @cErrorRoute, '' )		
	__defaultNIL( @nErrorCode, 401 )		
	__defaultNIL( @hError, { 'success' => .f., 'error' => 'Error autentication' } )		
	__defaultNIL( @nTime, 3600 )		
	
	::cVia 			:= lower( cVia )
	::cType 		:= lower( cType )
	::cErrorRoute	:= lower( cErrorRoute )
	::nErrorCode	:= nErrorCode
	::nTime			:= nTime	

	::lAutenticate := .f.
	
	//	Recover token 

		do case
			case ::cVia == 'cookie' ; cToken := ::GetTokenCookie() 				
			case ::cVia == 'header' ; cToken := ::GetTokenHeader()
		endcase


		if empty( cToken )
			::Unauthorized() 
			retu .f.
		endif 
	
	//	Validate 	
	
		do case
			case ::cType =='jwt'  	; ::lAutenticate := ::ValidateJWT( @cToken )		
			case ::cType =='token'	; ::lAutenticate := ::Validate( @cToken )		
		endcase 			

	if !::lAutenticate 
		::Unauthorized()
	else
		do case
			case ::cVia == 'cookie' 
				mh_SetCookie( ::cId_Cookie, cToken, ::nTime )				
				
			case ::cVia == 'header' ; cToken := ::GetTokenHeader()
		endcase			
	endif 
	
retu ::lAutenticate			

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

	//::hData := {=>}	
	::hData := nil 

	if empty( cToken )
		RETU .F.		
	endif	

	
	oJWT 	:= MC_JWT():New( ::cPsw ) 	
	lValid 	:= oJWT:Decode( cToken )						

	IF ! lValid	
		
		retu .F.
		
	endif 

	
	//	En este punto tenemos el token decodificado dentro del objeto oJWT
	
		::hData := oJWT:GetData()
	
	//	Consultamos el lapsus que hay definidio, para ponerla en la nueva cookie
	
		nLapsus 	:= oJWT:GetLapsus()


	//	Si el Token es correcto, prepararemos el sistema para que lo refresque cuando genere una nueva salida

		cToken 	:= oJWT:Refresh()		//	Vuelve a crear el Token teniendo en cuenta el lapsus		

retu .t. 

//	--------------------------------------------------------------------------

METHOD Validate( cRealToken ) CLASS MC_Middleware
	
	local cData, lValid, nLapsus	, lValidate, cToken  
	

	//::hData := {=>}	
	::hData := nil

	if empty( cRealToken )
		RETU .F.		
	endif	
	
	cToken 	:= hb_StrReplace( cRealToken, '-_',  '+/' )
	cToken := hb_base64Decode( cToken )
	
	cData := hb_blowfishDecrypt( hb_blowfishKey( ::cPsw ), cToken )		


	lValidate := if( cData == nil, .f., .t. )

	if lValidate
	
		::hData := hb_jsondecode( cData )

	endif	

retu lValidate

//	--------------------------------------------------------------------------

METHOD Unauthorized() CLASS MC_Middleware

	local cUrl 
	local oViewer
	local oApp		:= MC_GetApp()

		
	do case	
	
		case ::cVia == 'cookie' 
	
			if empty( ::cErrorRoute )

				mh_ExitStatus( ::nErrorCode )

			
			else 
			
				oViewer := MC_Viewer():New()

				if right( ::cErrorRoute, 5 ) == '.view'
				
					//	Borrar cookie

						::oResponse:SetCookie( ::cId_Cookie, '', -1 )
						
					//	Redireccionamos pantalla incial
					
						//::oController:View( ::cErrorRoute, ::nErrorCode, ::cMsg )
						oViewer:Exec( ::cErrorRoute, ::nErrorCode, ::cMsg )
						
					
				else 
				
					cUrl := MC_Route( ::cErrorRoute )		
		

					if empty( cUrl )				
						
						MC_MsgError( 'middleware', "Doesn't exist route ==> " + ::cErrorRoute )
						
					else
										
						if !empty( ::cMsg )
							cUrl += '?' + ::cMsg 
						endif					
		
						::oResponse:Redirect( cUrl )
						//oViewer:Exec( cUrl, ::nErrorCode, ::cMsg )										
					
					endif						
					
				endif		
				
			endif 
			
		case ::cVia == 'header'

		otherwise			
			
			MC_MsgError( 'middleware', "Via error ==> " + ::cVia )
								
	endcase 

retu nil 


//	--------------------------------------------------------------------------

METHOD SetJWT( hData, nTime ) CLASS MC_Middleware

	local oJWT 		:= MC_JWT():New( ::cPsw )	
	local cToken 


	__defaultNIL( @hData, {=>} )		
	
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

METHOD SendToken( cToken , nTime, cVia, cType  ) CLASS MC_Middleware	
	
			
	DEFAULT nTime 	:= ::nTime
	DEFAULT cVia 	:= 'cookie'
	DEFAULT cType	:= 'jwt'
	

	::cVia 	:= cVia 
	::cType := cType 

	if empty( ::cVia ) .or. empty( ::cType )
		MH_DoError( 'SendToken() - Via/Type not defined', 'Middleware',  99999 )
		retu nil
	endif

	if empty( cToken )
		MH_DoError( 'SendToken() - EmptyToken', 'Middleware',  99999 )
		retu .f.
	endif
	

	
	do case
		case ::cVia == 'cookie' 
			
			MH_SetCookie( ::cId_Cookie, cToken, nTime ) 

		case ::cVia == 'header' 
		
	endcase			
	
	
retu .t. 

//	--------------------------------------------------------------------------

METHOD DeleteToken() CLASS MC_Middleware

	
	do case
		case ::cVia == 'cookie' 
		
			MH_SetCookie( ::cId_Cookie, '', -1 ) 

		case ::cVia == 'header' 
		
	endcase			
	
retu .t. 


//	--------------------------------------------------------------------------

