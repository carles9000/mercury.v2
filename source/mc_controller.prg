
//	-----------------------------------------------------------	//

CLASS MC_Controller

	DATA cAction 													INIT ''
	DATA oRequest	
	DATA oResponse	
	DATA oMiddleware
	DATA hParam													INIT {=>}
	
	//	---------------------------
	/*
	DATA oView
	DATA lAutenticate												INIT .T.
	DATA aRouteSelect												INIT {=>}

	
	CLASSDATA oRoute					
	*/
	
	METHOD New( cMethod, hPar ) 									CONSTRUCTOR
	
	METHOD View( cFile, ... ) 
	
	METHOD Request 	( cKey, cDefault, cType )				INLINE ::oRequest:Request( cKey, cDefault, cType )
	METHOD Get			( cKey, cDefault, cType )				INLINE ::oRequest:Get	 	( cKey, cDefault, cType )
	METHOD Post		( cKey, cDefault, cType )				INLINE ::oRequest:Post	( cKey, cDefault, cType )
	METHOD PostAll()												INLINE ::oRequest:PostAll()
	METHOD GetAll()												INLINE ::oRequest:GetAll()
	METHOD RequestAll()											INLINE ::oRequest:RequestAll()
	
	METHOD Middleware()

/*	
	METHOD InitView()
	
	METHOD ListController()
	METHOD ListRoute()												INLINE ::oRoute:ListRoute()
	
	
	METHOD Middleware		( cType, cRoute, aExceptionMethods, hError  )					

	METHOD Redirect		( cRoute )
*/
	
ENDCLASS 

//	-------------------------------------------------------------------------	//	

//AQUI POSAR EL MAP SENCER--------

METHOD New( cAction, hParam  ) CLASS MC_Controller
		
	::cAction 			:= cAction
	::hParam 			:= hParam	
	
	::oRequest 		:= MC_Request():New( hParam )
	::oResponse 		:= MC_Response():New()
	::oMiddleware 		:= MC_Middleware():New( ::oRequest , ::oResponse )

RETU Self

//	-------------------------------------------------------------------------	//	

METHOD View( cFile, ... ) CLASS MC_Controller

	LOCAL oView 			:= MC_Viewer():New()
	
	//oView:oRoute		:= ::oRouter
	//oView:oResponse	:= ::oResponse 		
	
	oView:Exec( cFile, ... )

RETU ''

//	-------------------------------------------------------------------------	//	

METHOD Middleware( cVia, cType, cErrorRoute, aExceptionMethods, hError, lJson, cMsg,  aParams ) CLASS MC_Controller

	local nPos := 0
	local lAccess


	DEFAULT cVia					:= 'cookie'
	DEFAULT cType					:= 'jwt'
	DEFAULT cErrorRoute 			:= ''
	DEFAULT aExceptionMethods  	:= array()
	DEFAULT hError  				:= { 'success' => .f., 'error' => 'Error autentication' }
	DEFAULT lJson  				:= .F.
	DEFAULT cMsg  					:= ''

	
	//	If exist some exception, don't autenticate

		nPos := Ascan( aExceptionMethods, {|x,y| lower(x) == lower( ::cAction )} )
		
		if nPos > 0
			retu .t.
		endif
		
	//	

	lAccess := ::oMiddleware:Exec( cVia, cType, cErrorRoute, hError, lJson, cMsg, aParams )

	
retu lAccess 
	/*
	
	cType := lower( cType )
	
	//	Lo mismo 'jwt' que 'token', lo se, lo se...
	
	DO CASE
		CASE cType == 'jwt'
			retu ::lAutenticate := ::oMiddleware:Exec( SELF, cType, cRoute, hError, lJson, aParams )
			
		CASE cType == 'token'
			retu ::lAutenticate := ::oMiddleware:Exec( SELF, cType, cRoute, hError, lJson, aParams )			
	
		CASE cType == 'rool'				
		
	ENDCASE

RETU .F.
	*/

/*
METHOD Middleware( cType, cRoute, aExceptionMethods, hError, lJson, aParams ) CLASS MC_Controller

	local nPos := 0

	DEFAULT cType					:= 'jwt'
	DEFAULT cRoute 				:= ''
	DEFAULT aExceptionMethods  	:= array()
	DEFAULT hError  				:= { 'success' => .f., 'error' => 'Error autentication' }
	DEFAULT lJson  				:= .F.
	
	//	If exist some exception, don't autenticate

		nPos := Ascan( aExceptionMethods, {|x,y| lower(x) == lower( ::cAction )} )
		
		if nPos > 0
			retu .t.
		endif

	cType := lower( cType )
	
	//	Lo mismo 'jwt' que 'token', lo se, lo se...
	
	DO CASE
		CASE cType == 'jwt'
			retu ::lAutenticate := ::oMiddleware:Exec( SELF, cType, cRoute, hError, lJson, aParams )
			
		CASE cType == 'token'
			retu ::lAutenticate := ::oMiddleware:Exec( SELF, cType, cRoute, hError, lJson, aParams )			
	
		CASE cType == 'rool'				
		
	ENDCASE

RETU .F.
*/


/*
METHOD InitView( ) CLASS MC_Controller

	::oView 			:= TView():New()
	::oView:oRoute		:= ::oRoute					//	Xec oApp():oRoute !!!!
	::oView:oResponse	:= App():oResponse 			//::oResponse
	
RETU NIL
*/
/*
METHOD View( cFile, ... ) CLASS MC_Controller

	if _IsLog()
		_l( '[MERCURY] Execute view: ' + cFile )
	endif

	::oView:Exec( cFile, ... )

RETU ''
*/

/*	
	Como mod harbour aun no podemos crear un redirect correctamente, simularemos de esta manera
	https://stackoverflow.com/questions/503093/how-do-i-redirect-to-another-webpage/506004#506004
*/

/*
METHOD Redirect( cRoute ) CLASS MC_Controller

	local oResponse 	:= App():oResponse
	local cHtml := ''

	cHtml += '<script>'
	cHtml += "window.location.replace( '" + cRoute + "'); "
	cHtml += '</script>'
	
	//	Ejecutamos el metodo SendHtml y si hay alguna cookie la enviare previamente...
	
		oResponse:SendHtml( cHtml )	

RETU NIL
*/

/*
METHOD ListController(o) CLASS MC_Controller

	LOCAL oThis := SELF		
	local cHtml := MC_Info_Style()

	BLOCKS VIEW cHtml PARAMS oThis 
	
		<div class="mc-info">
	
			<h3>ListController</h3><hr>
			
			<table class="mc_info" border="1" cellpadding="3" >
			
				<thead>
					<tr>
						<th>Description</th>
						<th>Parameter</th>
						<th>Value</th>							
					</tr>									
				</thead>
				
				<tbody>
				
					<tr>
						<td>ClassName Name</td>
						<td>ClassName()</td>
						<td><$ oThis:ClassName() $></td>
					</tr>
					
					<tr>
						<td>Action</td>
						<td>cAction</td>
						<td><$ oThis:cAction $></td>
					</tr>				
				
					<tr>
						<td>Parameters</td>
						<td>hParam</td>
						<td><$ ValToChar( oThis:hParam ) $></td>
					</tr>				
					
					<tr>
						<td>Method</td>
						<td>oRequest:method()</td>
						<td><$ oThis:oRequest:method() $></td>
					</tr>
					
					<tr>
						<td>Query</td>
						<td>oRequest:GetQuery()</td>
						<td><$ oThis:oRequest:getquery() $></td>
					</tr>				

					<tr>
						<td>Parameters GET</td>
						<td>oRequest:CountGet()</td>
						<td><$ ValToChar(oThis:oRequest:countget()) $></td>
					</tr>	

					<tr>
						<td>Value GET</td>
						<td>oRequest:Get( cKey )</td>
						<td><$ ValToChar(oThis:oRequest:getall()) $></td>
					</tr>

					<tr>
						<td>Parameters POST</td>
						<td>oRequest:CountPost()</td>
						<td><$ ValToChar(oThis:oRequest:countpost()) $></td>
					</tr>	

					<tr>
						<td>Value POST</td>
						<td>oRequest:Post( cKey )</td>
						<td><$ ValToChar(oThis:oRequest:postall()) $></td>
					</tr>	

					<tr>
						<td>Route Select</td>
						<td>aRouteSelect</td>
						<td><$ ValToChar(oThis:aRouteSelect) $></td>
					</tr>								
				
				</tbody>		
				
			</table>
		
		</div>
		
	ENDTEXT 
	
	? cHtml 	

RETU ''
*/
//	-----------------------------------------------------------	//