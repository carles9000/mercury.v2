/*	-----------------------------------------------------------	
	TODAS las respuestas habrian de pasar por este método. 
	Básicamente podemos hacer un ? y esto genera una salida con 
	el AP_RPUTS, pero se ha de empezar a controlar el orden de 
	salida: código de error, cabeceras, validaciones de salida,
	si en un futuro	creamos un buffer per-salida...
	----------------------------------------------------------- */	



CLASS MC_Response

   DATA aHeaders							INIT {}
   DATA cContentType						INIT 'text/plain'
   DATA cBody								INIT ''
   DATA nCode								INIT 200 
   DATA lRedirect							INIT .F.
   DATA cLocation							INIT ''
			
   METHOD New() 							CONSTRUCTOR
   METHOD Echo() 							//	print(), go(), exec(), out(), ...
   
   METHOD SetHeader( cHeader, uValue )
   
   METHOD SendCode( nCode )
   METHOD SendJson( uResult, nCode )
   METHOD SendXml ( uResult, nCode )
   METHOD SendHtml( uResult, nCode )
   
   METHOD Redirect( cUrl )
   
   METHOD SetCookie( cName, cValue, nSecs, cPath, cDomain, lHttps, lOnlyHttp )   

ENDCLASS

METHOD New() CLASS MC_Response
	
	//	Por defecto dejamos activado el intercambio de Recursos de Origen Cruzado (CORS)
	
		::SetHeader( "Access-Control-Allow-Origin", "*" )

RETU Self

METHOD SetHeader( cHeader, cValue ) CLASS MC_Response

	__defaultNIL( @cHeader, '' )
	__defaultNIL( @cValue, '' )
	
	Aadd( ::aHeaders, { cHeader, cValue } ) 

RETU NIL

METHOD SendJson( uResult, nCode, cCharset ) CLASS MC_Response

	DEFAULT nCode 	:= 0	
	DEFAULT cCharSet  := MC_GetApp():cCharset 	//	'ISO-8859-1'	//	'utf-8'	

	::cContentType 	:= "application/json;charset=" + cCharSet	
	::cBody 			:= IF( HB_IsHash( uResult ) .or. HB_IsArray( uResult ), hb_jsonEncode( uResult ), '' )
	
	if !empty(nCode)
		::SendCode(nCode)
	endif	
	
	::echo()	

RETU NIL

METHOD SendXml( uResult, nCode, cCharset ) CLASS MC_Response

	DEFAULT nCode 	:= 0	
	DEFAULT cCharSet  := MC_GetApp():cCharset 	//	'ISO-8859-1'	//	'utf-8'
	
	::cContentType 	:= "text/xml;charset=" + cCharSet	
	::cBody 			:= IF( HB_IsString( uResult ), uResult, '' )
	
	if !empty(nCode)
		::SendCode(nCode)
	endif	
	
	::echo()	

RETU NIL

METHOD SendHtml( uResult, nCode ) CLASS MC_Response

	DEFAULT nCode := 0
	
	::cContentType 	:= "text/html"
	::cBody 			:= IF( HB_IsString( uResult ), uResult, '' )

	if !empty(nCode)
		::SendCode(nCode)
	endif
	
	::echo()

RETU NIL

METHOD Redirect( cUrl ) CLASS MC_Response

	local cHtml := ''
	
	
		//	Tendriamos de decir al controller que cargue el nuevo
		
		//AP_HeadersOutSet( "Location", cUrl )		
	
		//ErrorLevel( REDIRECTION )	
		
		
		
		/*
		::SetHeader( "Location", cUrl )
		
		::nCode := REDIRECTION 
		
		::Echo()
		*/
		

	cHtml += '<script>'
	cHtml += "window.location.replace( '" + cUrl + "'); "
	cHtml += '</script>'

		
	::SendHtml( cHtml )									
	
RETU NIL

METHOD SendCode( nCode ) CLASS MC_Response

	//ErrorLevel( nCode )
	mh_ExitStatus( nCode )

RETU NIL 

METHOD Echo() CLASS MC_Response

	LOCAL aHeader 

	//	La salida de retorno de la respuesta tendra 3 capas de envio:
	//	Errorlevel

	//	 No chuta. Pendiente de revisar
		
		IF ::nCode > 200
			//ErrorLevel( ::nCode )
			mh_ExitStatus( ::nCode )
		ENDIF	
		
	//	Cabeceras

		FOR EACH aHeader IN ::aHeaders

			//	Si tenemos alguna cookie por enviar, la enviamos...					
			IF aHeader[1] == 'Set-Cookie'							
				AP_HeadersOutSet( "Set-Cookie", aHeader[2] )												
			ELSE
				AP_HeadersOutSet( aHeader[1], aHeader[2] )															
			ENDIF
			
		NEXT
		
	//	Set ContentType
		
		AP_SetContentType( ::cContentType )		
		
	//	Sino salida del Body...

		//AP_RPUTS( ::cBody )								
		ap_echo( ::cBody )

RETU NIL

//	El método GetCookie estará en el oRequest
//	https://developer.mozilla.org/es/docs/Web/HTTP/Headers/Set-Cookie
//	Sintaxis
/*
	Set-Cookie: <cookie-name>=<cookie-value>
	Set-Cookie: <cookie-name>=<cookie-value>; Expires=<date>
	Set-Cookie: <cookie-name>=<cookie-value>; Max-Age=<non-zero-digit>
	Set-Cookie: <cookie-name>=<cookie-value>; Domain=<domain-value>
	Set-Cookie: <cookie-name>=<cookie-value>; Path=<path-value>
	Set-Cookie: <cookie-name>=<cookie-value>; Secure
	Set-Cookie: <cookie-name>=<cookie-value>; HttpOnly

	Set-Cookie: <cookie-name>=<cookie-value>; SameSite=Strict
	Set-Cookie: <cookie-name>=<cookie-value>; SameSite=Lax
	Set-Cookie: <cookie-name>=<cookie-value>; SameSite=None

	// Es posible usar múltiples directivas, por ejemplo:
	Set-Cookie: <cookie-name>=<cookie-value>; Domain=<domain-value>; Secure; HttpOnly
	
	Una cookie segura sólo se envía al servidor con una petición cifrada sobre el protocolo HTTPS
*/


METHOD SetCookie( cName, cValue, nSecs, cPath, cDomain, lHttps, lOnlyHttp ) CLASS MC_Response


	MH_SetCookie( cName, cValue, nSecs, cPath, cDomain, lHttps, lOnlyHttp )
	
	/*
	
	LOCAL cCookie := ''

		__defaultNIL( @cName		, '' )
		__defaultNIL( @cValue		, '' )
		__defaultNIL( @nSecs		, 3600 )		//	
		__defaultNIL( @cPath		, '/' )
		__defaultNIL( @cDomain	, '' )
		__defaultNIL( @lHttps		, .F. )
		__defaultNIL( @lOnlyHttp	, .F. )
	
	//	Validacion de parámetros
	
	
	//	Montamos la cookie
	
		cCookie += cName + '=' + cValue + ';'
		cCookie += 'expires=' + CookieExpire( nSecs ) + ';'
		cCookie += 'path=' + cPath + ';'
		cCookie += 'domain=' + cDomain + ';'
		

	//	Pendiente valores logicos de https y OnlyHttp

	//	Envio de la Cookie

		//AP_HeadersOutSet( "Set-Cookie", cCookie )
		::SetHeader( "Set-Cookie", cCookie )

	*/

RETU NIL


//	CookieExpire( nSecs ) Creará el formato de tiempo para la cookie
	
//		Este formato sera: 'Sun, 09 Jun 2019 16:14:00'
static function CookieExpire( nSecs )
    LOCAL tNow		:= hb_datetime()	
	LOCAL tExpire							//	TimeStampp 
	LOCAL cExpire 						//	TimeStamp to String

	
	__defaultNIL( @nSecs, 3600 )
   
    tExpire 	:= hb_ntot( (hb_tton(tNow) * 86400 - hb_utcoffset() + nSecs ) / 86400)

    cExpire 	:= cdow( tExpire ) + ', ' 
	cExpire 	+= alltrim(str(day( hb_TtoD( tExpire )))) + ' ' + cmonth( tExpire ) + ' ' + alltrim(str(year( hb_TtoD( tExpire )))) + ' ' 
    cExpire 	+= alltrim(str( hb_Hour( tExpire ))) + ':' + alltrim(str(hb_Minute( tExpire ))) + ':' + alltrim(str(hb_Sec( tExpire )))

return cExpire

//	-------------------------------------------------------------------	//

function MC_Response_Output( oController, cType, uValue )
	
	
	cType := lower( cType )

	do case
	
		case cType == 'html'
		
			oController:oResponse:SendHtml( uValue )		
	
		case cType == 'json'
		
			oController:oResponse:SendJson( uValue )					
			
		case cType == 'xml'				
			
			oController:oResponse:SendXml( uValue )
			
		otherwise 
		
			oController:oResponse:SendJson( { 'success' => .f., 'error' => 'Format ' + cType + ', not supported' } )							
	endcase 				

retu nil 

//	-------------------------------------------------------------------	//

function mc_Hash2Xml( hData )

	local cXml := ''	
	local nLen := len( hData )
	local n, aPair, cKey, uValue, cType 
		
	cXml := '<xml>'			

	for n := 1 to nLen 
	
		aPair 	:= HB_HPairAt( hData, n )
		cKey	:= aPair[1]
		uValue 	:= aPair[2]
		cType 	:= valtype( uValue )
		
		do case 
		
			case uValue == 'C'
		
				cXml += '<' + cKey + '>' + uValue + '</' + cKey + '>'
				
			case uValue == 'N'
			
				cXml += '<' + cKey + '>' + ltrim(str(uValue)) + '</' + cKey + '>'
				
			case uValue == 'D'
			
				cXml += '<' + cKey + '>' + DToC(uValue) + '</' + cKey + '>'
				
			case uValue == 'L'
			
				cXml += '<' + cKey + '>' + if(uValue, 'true', 'false') + '</' + cKey + '>'
				
			otherwise 
			
				cXml += '<' + cKey + '>' + mh_valtochar(uValue) + '</' + cKey + '>'
				
		endcase 											
	
	next 

	cXml += '</xml>'			

retu cXml 
