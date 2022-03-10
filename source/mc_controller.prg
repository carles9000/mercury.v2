
//	-----------------------------------------------------------	//

CLASS MC_Controller

	DATA cAction 													INIT ''
	DATA oRequest	
	DATA oResponse	
	DATA oMiddleware
	DATA hParam													INIT {=>}
	
	
	METHOD New( cMethod, hPar ) 									CONSTRUCTOR
	
	METHOD View( cFile, ... ) 
	
	METHOD Request 	( cKey, cDefault, cType )				INLINE ::oRequest:Request( cKey, cDefault, cType )
	METHOD Get			( cKey, cDefault, cType )				INLINE ::oRequest:Get	 	( cKey, cDefault, cType )
	METHOD Post		( cKey, cDefault, cType )				INLINE ::oRequest:Post	( cKey, cDefault, cType )
	METHOD PostAll()												INLINE ::oRequest:PostAll()
	METHOD GetAll()												INLINE ::oRequest:GetAll()
	METHOD RequestAll()											INLINE ::oRequest:RequestAll()

	METHOD Auth()


ENDCLASS 

//	-------------------------------------------------------------------------	//	

METHOD New( cAction, hParam  ) CLASS MC_Controller

	local oApp 		:= mc_GetApp()
		
	::cAction 			:= cAction
	::hParam 			:= hParam	
	
	::oRequest 		:= MC_Request():New( hParam )
	::oResponse 		:= MC_Response():New()
	
	::oMiddleware 		:= MC_Middleware():New( ::oRequest , ::oResponse )	

RETU Self

//	-------------------------------------------------------------------------	//	

METHOD View( cFile, nCode, ... ) CLASS MC_Controller

	LOCAL oView 			:= MC_Viewer():New()
	
	//oView:oRoute		:= ::oRouter
	//oView:oResponse	:= ::oResponse 		
	
	oView:Exec( cFile, nCode, ... )

RETU ''

//	-------------------------------------------------------------------------	//	

METHOD Auth( aExceptionMethods ) CLASS MC_Controller

	local nPos := 0
	local lAccess

	DEFAULT aExceptionMethods := {=>}
	
	//	If exist some exception, don't autenticate

		nPos := Ascan( aExceptionMethods, {|x,y| lower(x) == lower( ::cAction )} )
		
		if nPos > 0
			retu .t.
		endif
		
	//	

	lAccess := ::oMiddleware:Valid()
	
retu lAccess 

//	-------------------------------------------------------------------------	//	


/*	
	Como mod harbour aun no podemos crear un redirect correctamente, simularemos de esta manera
	https://stackoverflow.com/questions/503093/how-do-i-redirect-to-another-webpage/506004#506004
*/

