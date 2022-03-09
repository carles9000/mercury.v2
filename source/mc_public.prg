//	Mercury Functions

function MC_Version()	;		retu MC_VERSION

function MC_App_Url(); 		retu cFilePath( AP_GetEnv( 'SCRIPT_NAME' ) )
function MC_App_Path(); 		retu HB_Getenv( 'PRGPATH' )

function MC_Script_Url(); 	retu AP_GetEnv( 'SCRIPT_NAME' )
function MC_Script_Path(); 	retu AP_GetEnv( 'SCRIPT_FILENAME' )
function MC_Prg();			retu cFileNoPath( AP_GetEnv( 'SCRIPT_NAME' ) )
function MC_Uri(); 			retu AP_GetEnv( 'REQUEST_URI' )	// with query
function MC_Document_Root();	retu AP_GetEnv( 'DOCUMENT_ROOT' )
function MC_Method();			retu AP_GetEnv( 'REQUEST_METHOD' )

function MC_Url_Friendly()
	
	local cApp_Url 		:= MC_App_Url()	
	local cUri				:= MC_Uri()
	local cPrg				:= MC_Prg()
	local aParam 			:= {}
	local n, cRealQuery, aVerb   


	//	Parameters 
	//	cApp_Url 			= /z/router/z.prg
	//	cUri 				= /z/router/z.prg/customer/get/?aaa=pol&bbb=123&ccc
	//	We're looking for = /customer/get/?aaa=pol&bbb=123&ccc
	
	
		n := At( cApp_Url, cUri )
		
		if n > 0 
		
			cRealQuery := Substr( cUri, n + len(cApp_Url) )
			

			//	cRealQuery 
			//	if we use rewrite => /customer/get 
			//	if not cRealquery can be => z.prg/customer/get 
			//	in this case whe need delete => z.prg 			

				n := At( cPrg, cRealQuery )
				
				if n > 0 
					cRealQuery := Substr( cRealQuery, len( cPrg ) + 1 )
				endif 
			
			
			//	Result: /customer/get?aaa=pol&bbb=123&ccc			
			
			n = at( '?', cRealQuery )
			
			if n > 0 
				cRealQuery := Substr( cRealQuery, 1, n-1 )
			endif
			
			//	Result: /customer/get
			
			aVerb 	:= hb_ATokens( cRealQuery, "/" )
			aParam 	:= {}


			for n := 1 to len( aVerb )
				if !empty( aVerb[n] )
					Aadd( aParam, aVerb[n] )
				endif 
			next 
			
			//	Result: { 'customer', 'get' }							
			
		endif 

retu aParam

function MC_Url_Query() 

	local cQuery 	:= AP_Getenv( 'QUERY_STRING' )
	local aParam 	:= hb_ATokens( cQuery, "&" )
	local hParam 	:= {=>}
	local n, j, cTag 

	//	...?aaa=pol&bbb=123&ccc
	//	Result: Query parameters -> aaa=pol&bbb=123&ccc		
		
		for j = 1 to len( aParam )
		
			cTag 	:= aParam[ j ]
			
			if !empty( cTag )
			
				n 	:= At( '=', cTag )
				
				if n > 1 									
					hParam[ alltrim( hb_urldecode(Substr( cTag, 1, n-1 ))) ] := hb_urldecode( Substr( cTag, n+1 ) )
				else
					hParam[ alltrim(hb_urldecode( cTag )) ] := ''				
				endif 
			
			endif 
		next 	

retu hParam 

//	-------------------------------------------------------	//

function MC_IsMail( cMail )
retu len( hb_regex( '^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$', alltrim( cMail ), .F. ) ) == 1

function MC_IsMobile()

	local lMobile 	:= .f. 	
	local cAgent 	:= AP_GetEnv( 'HTTP_USER_AGENT' )
	local aTag		:= { "Mobile", "iPhone", "iPod", "BlackBerry", "Opera mini", "Sony", "MOT (Motorola)", "Nokia", "samsung" }
	local nLen 	:= len( aTag )
	local nI 
	
	for nI := 1 to len( aTag )	
	
		if aTag[nI] $ cAgent			
			lMobile := .t.		
			exit
		endif				
		
	next 						

retu lMobile


//	-------------------------------------------------------	//
//	From Fivewin.lib
//	-------------------------------------------------------	//

//----------------------------------------------------------------------------//

function cFileNoPath( cFile )  // returns just the filename no path
    local lUNC := "/" $ cFile
    local cSep := If( lUNC, "/", "\" )  
    local n := RAt( cSep, cFile )

retu If( n > 0 .and. n < Len( cFile ),;
        Right( cFile, Len( cFile ) - n ),;
        If( ( n := At( ":", cFile ) ) > 0,;
        Right( cFile, Len( cFile ) - n ),;
        cFile ) )

//----------------------------------------------------------------------------//

function cFilePath( cFile )   // returns path of a filename
   
   local lUNC := "/" $ cFile
   local cSep := If( lUNC, "/", "\" )   
   
   local n := RAt( cSep, cFile )

retu Substr( cFile, 1, n )

//----------------------------------------------------------------------------//

function cFileExt( cPathMask ) // returns the ext of a filename

   local cExt := AllTrim( cFileNoPath( cPathMask ) )
   local n    := RAt( ".", cExt )

return AllTrim( If( n > 0 .and. Len( cExt ) > n,;
                    Right( cExt, Len( cExt ) - n ), "" ) )

function cFileNoExt( cPathMask ) // returns the filename without ext

   local cName := AllTrim( cFileNoPath( cPathMask ) )
   local n     := RAt( ".", cName )

return AllTrim( If( n > 0, Left( cName, n - 1 ), cName ) )					