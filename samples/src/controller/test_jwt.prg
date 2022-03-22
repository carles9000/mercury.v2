CLASS Test_JWT

	METHOD New() 	CONSTRUCTOR
	
	METHOD Create() 
	METHOD CookieJWT() 
	METHOD CookieToken() 
	METHOD DelCookie() 
	METHOD Valid() 	
   
ENDCLASS

METHOD New( o ) CLASS Test_JWT	

RETU SELF

METHOD Create( o ) CLASS Test_JWT

	LOCAL oJWT 	:= MC_JWT():New()
	LOCAL cToken 	:= ''

	//	Crearemos un JWT. Tiempo de validez (10 seg.). Default system 3600
	
		oJWT:SetTime( 10 )
		
	//	Añadimos datos al token...
	
		oJWT:SetVar( 'name'	, 'James Brown' )
		oJWT:SetVar( 'IBN'		, 'ABC-01234-654-234' )
		oJWT:SetVar( 'id'		, 12345 )
		oJWT:SetVar( 'date'	, date() )
			
		cToken := oJWT:Encode()
		
	//	Cremos la vista mostrando el Token		

		o:View( 'jwt/jwt.view', 200, cToken )
	
RETU NIL

METHOD CookieJWT ( oController ) CLASS Test_JWT

	local hData  	:= {=>}
	local cToken 
	
	? 'ACTION', oController:cAction
		
	//	Añadimos datos al token...
	
		hData[ 'name' ] := 'Barbara Criet' 
		hData[ 'IBN'  ] := 'XYZ-98765' 
		hData[ 'id'] :=	54321 
		hData[ 'date'] :=	date() 			

	//	Cremos la vista mostrando el Token	

		CREATE JWT cToken OF oController WITH hData 
	
		? 'Token JWT via cookie', cToken		
	
RETU NIL

METHOD CookieToken( oController ) CLASS Test_JWT

	local hData  	:= {=>}
	local cToken 
		
	//	Añadimos datos al token...
	
		hData[ 'name' ] := 'Barbara Criet' 
		hData[ 'IBN'  ] := 'XYZ-98765' 
		hData[ 'id'] :=	54321 
		hData[ 'date'] :=	date() 
			

	//	Cremos la vista mostrando el Token	

		CREATE TOKEN cToken OF oController WITH hData				
	
		? 'Token via cookie', cToken		
	
RETU NIL

METHOD DelCookie( oController ) CLASS Test_JWT

	//	Cremos la vista mostrando el Token	

		CLOSE JWT OF oController
		
		? 'Cookie has deleted'
	
		
	
RETU NIL

METHOD Valid( o ) CLASS Test_JWT

	LOCAL oJWT 	:= MC_JWT():New()
	LOCAL cToken 	:= o:Post( 'token' )
	LOCAL lValid	:= .F.
	LOCAL hData	:= {=>}
	LOCAL cError	:= ''

	//	Crearemos un JWT. Tiempo de validez (10 seg.)
	
		lValid 	:= oJWT:Decode( cToken )
		hData 		:= oJWT:GetData()
		cError 	:= oJWT:GetError()
		
	//	Cremos la vista validacion...

		o:View( 'jwt/jwt_valid.view', 200, lValid, hData, cError )
	
RETU NIL