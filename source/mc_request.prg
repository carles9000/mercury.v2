#include 'mercury.ch' 

CLASS MC_Request 

	DATA hGet												INIT {=>}
	DATA hPost												INIT {=>}
	DATA hHeaders											INIT {=>}
	DATA hCookies											INIT {=>}
	DATA hRequest											INIT {=>}
	
	METHOD New()							CONSTRUCTOR	
	
	METHOD Method()										INLINE AP_GetEnv( 'REQUEST_METHOD' )
	
	METHOD Get( cKey, uDefault, cType )		
	METHOD GetAll()										INLINE ::hGet
	METHOD Post( cKey, uDefault, cType )		
	METHOD PostAll()										INLINE ::hPost
	METHOD Request( cKey, uDefault, cType )	
	METHOD RequestAll()									INLINE ::hRequest	
	
	METHOD GetCookie( cKey )								INLINE HB_HGetDef( ::hCookies, cKey, '' ) 
	METHOD GetHeader( cKey )								INLINE HB_HGetDef( ::hHeaders, cKey, '' ) 	
	
	METHOD CountGet()										INLINE len( ::hGet )
	METHOD CountPost()									INLINE len( ::hPost )
	
	METHOD LoadGet()
	METHOD LoadPost()
	METHOD LoadRequest()
	METHOD LoadHeaders()
	
	METHOD ValueToType( uValue, cType )	
	
	METHOD Url_Friendly()									INLINE MC_Url_Friendly()
	METHOD Url_Query()									INLINE MC_Url_Query()

ENDCLASS 

//	------------------------------------------------------------	//

METHOD New( hParam ) CLASS MC_Request 	

	__defaultNIL( @hParam, {=>} )
	
	::LoadGet()	
	::LoadPost()
	::LoadHeaders()
	
	HB_HCaseMatch( ::hGet, .F. )
	HB_HCaseMatch( ::hPost, .F. )
	HB_HCaseMatch( ::hRequest, .F. )
	HB_HCaseMatch( ::hHeaders, .F. )
	HB_HCaseMatch( ::hCookies, .F. )
	
	
	//	Parameters will be add to hash get o post 	

		if !empty( hParam )
		
			do case
				case ::Method() == 'GET'
				
					::hGet := HB_HMerge( ::hGet, hParam )

				case ::Method() == 'POST'
				
					::hPost := HB_HMerge( ::hPost, hParam )
			endcase
		
		endif	

	
	//	Request = get + post
	
		::LoadRequest() 

	
	
	
retu Self 

//	------------------------------------------------------------	//


METHOD Get( cKey, uDefault, cType ) CLASS MC_Request

	LOCAL nType 
	LOCAL uValue	:= ''

	__defaultNIL( @cKey, '' )
	__defaultNIL( @uDefault, '' )
	__defaultNIL( @cType, '' )	

	HB_HCaseMatch( ::hGet, .F. )	

	IF !empty(cKey) .AND. hb_HHasKey( ::hGet, cKey )

		if  valtype( ::hGet[ cKey ] ) == 'A'
			Aeval( ::hGet[ cKey ], {|u| u :=  hb_UrlDecode(u)} ) 
		else
			uValue := if( empty( ::hGet[ cKey ] ), uDefault, hb_UrlDecode(::hGet[ cKey ]) )
		endif					
		
	ELSE
		uValue := uDefault
	ENDIF

	uValue := ::ValueToType( uValue, cType )

RETU uValue

//	------------------------------------------------------------	//

METHOD Post( cKey, uDefault, cType ) CLASS MC_Request

	LOCAL nType 
	LOCAL uValue 	:= ''
	
	__defaultNIL( @cKey, '' )
	__defaultNIL( @uDefault, '' )	
	__defaultNIL( @cType, '' )	


	HB_HCaseMatch( ::hPost, .F. )

	IF hb_HHasKey( ::hPost, cKey )

		if  valtype( ::hPost[ cKey ] ) == 'A'
			Aeval( ::hPost[ cKey ], {|u| u :=  hb_UrlDecode(u)} ) 
		else
			uValue := if( empty( ::hPost[ cKey ] ), uDefault, hb_UrlDecode(::hPost[ cKey ]) )
		endif			
		
	ELSE
		uValue := uDefault
	ENDIF

	uValue := ::ValueToType( uValue, cType )

RETU uValue

//	------------------------------------------------------------	//


METHOD Request( cKey, uDefault, cType ) CLASS MC_Request

	LOCAL nType 
	LOCAL uValue 	:= ''
	
	__defaultNIL( @cKey, '' )
	__defaultNIL( @uDefault, '' )	
	__defaultNIL( @cType, '' )

	HB_HCaseMatch( ::hRequest, .F. )

	IF hb_HHasKey( ::hRequest, cKey )
		uValue := hb_UrlDecode(::hRequest[ cKey ])
	ELSE
	
		uValue := uDefault
	ENDIF

	uValue := ::ValueToType( uValue, cType )	

RETU uValue

//	------------------------------------------------------------	//

METHOD ValueToType( uValue, cType ) CLASS MC_Request

	__defaultNIL( @uValue, '' )
	__defaultNIL( @cType, '' )

	DO CASE
		CASE cType == 'C'
		CASE cType == 'N'; uValue := If( valtype(uValue) == 'N', uValue, Val( uValue ) )
		CASE cType == 'L'; uValue := If( valtype(uValue) == 'L', uValue, IF( lower( mh_valtochar(uValue) ) == 'true', .T., .F. ) )
	ENDCASE

RETU uValue 

//	------------------------------------------------------------	//

METHOD LoadGet( cKey, uDefault, cType ) CLASS MC_Request

	if empty( ::hGet )
		::hGet	:= AP_GetPairs()
	endif 	

retu nil 

//	------------------------------------------------------------	//

METHOD LoadPost( cKey, uDefault, cType ) CLASS MC_Request

	if empty( ::hPost )
		::hPost := AP_PostPairs()
	endif 
	
retu nil 

//	------------------------------------------------------------	//

METHOD LoadRequest() CLASS MC_Request

	//	Directiva request_order = 'EGPCS'
	//	ENV, GET, POST, COOKIE y SERVER
	
	// 	De momento rellenaremos en este orden GET, POST, pero lo trataremos de manera inversa: POST, GET,...
	//	porque HB_HMERGE machaca si existe una key, es decir la ultima q se procesa que es el GET si existe
	//	machacara la key del post. Vale mas GET que POST

	//	POST
	
		::hRequest := HB_HClone( ::hPost ) 
		
	//	GET
	//	https://github.com/zgamero/sandbox/wiki/2.7-Hashes	

		HB_HMerge( ::hRequest, ::hGet, HB_HMERGE_UNION )	

RETU NIL

//	------------------------------------------------------------	//

METHOD LoadHeaders() CLASS MC_Request

	LOCAL nLen := AP_HeadersInCount() - 1 
	LOCAL n, nJ, cKey, cPart, uValue
	
	::hHeaders := {=>}	
	::hCookies := {=>}

	FOR n = 0 to nLen
	
		cKey 	:= AP_HeadersInKey( n )
		uValue 	:= AP_HeadersInVal( n )				
		
		::hHeaders[ cKey ] := uValue
		
		//	Si una de las cabeceras es una Cookie, la cargamos ya en una variable
		//	La cabecera Cookie, puede tener varias cookies, separadas por un ;
		
		IF ( lower(cKey) == 'cookie' )
		
			FOR EACH cPart IN hb_ATokens( uValue, ";" )				
		
				IF ( nJ := At( "=", cPart ) ) > 0
				
					IF ( !empty( cKey := Alltrim(Left( cPart, nJ - 1 )) ) )
						::hCookies[ cKey ] := Alltrim(SubStr( cPart, nJ + 1 ))
					ENDIF
					
				ELSE
				
					IF ( !empty( cKey := Alltrim(Left( cPart, nJ - 1 ))) )					
						::hCookies[ cKey ] :=  ''
					ENDIF
					
				ENDIF
		   
			NEXT		
		
		ENDIF		
		
	NEXT	

RETU NIL

//	------------------------------------------------------------	//