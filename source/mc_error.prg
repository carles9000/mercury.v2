
FUNCTION MC_ErrorSys( oError, cCode, cCodePP )

	LOCAL hError

	hb_default( @cCode, "" )
	hb_default( @cCodePP, "" )
	
_d( 'MC_ErrorSys-------------------------' )	
_d( cCode )	
_d( '======================')
_d( oError ) 
_d( '======================')
   
	//	Delete buffer out
   
		//ts_cBuffer_Out := ''
		
	//	Recover data info error
	
		hError := MC_ErrorInfo( oError, cCode, cCodePP )


		MC_ErrorView( hError )
		//MC_ViewError( hError )


/*
// Output of buffered text

   ap_RPuts( ts_cBuffer_Out )

   // Unload hrbs loaded.

   mh_LoadHrb_Clear()
*/
// EXIT.----------------

RETU NIL


function MC_ErrorInfo( oError, cCode, cCodePP )

	local cInfo 	:= ''
	local cStack 	:= ''
	local aTagLine 	:= {}
	local hError	:= {=>}
    local n, aLines, nLine, cLine, nPos, nErrorLine, nL  	
	local nLin, nOffSet, lReview, ts_block

	//	Init hError info 
	
		hError[ 'date' ]		:= DToC( Date() )
		hError[ 'time' ]		:= time()
		hError[ 'description' ]	:= ''
		hError[ 'operation' ]	:= ''
		hError[ 'filename' ]	:= ''
		hError[ 'subsystem' ]	:= ''
		hError[ 'subcode' ]		:= ''
		hError[ 'args' ]		:= {}
		hError[ 'stack' ]		:= {}
		hError[ 'line' ]		:= 0
		hError[ 'type' ] 		:= ''
		hError[ 'block_code' ] 	:= ''
		hError[ 'block_error' ] := ''
		hError[ 'code' ]		:= cCode
		hError[ 'codePP' ]		:= cCodePP
		hError[ 'view' ]		:= ''

_d( 'MC_ErrorInfo------------------------------' )	
	//	Check error from BLOCKS 
	
		ts_block := mc_get_hBlock() 
		
		//hError[ 'view' ]		:= HB_HGetDef( 'ts_block', 'view', '')

	
		if !empty( ts_block )
		
			hError[ 'type' ] 		:= ts_block[ 'type' ]	// 'block'
			
			do case	
				case hError[ 'type' ] == 'block'
					hError[ 'block_code' ] 	:= ts_block[ 'code' ]
					hError[ 'block_error'] 	:= ts_block[ 'error' ]
				
				case hError[ 'type' ] == 'initprocess'
					hError[ 'filename' ]	:= ts_block[ 'filename' ]
					
				otherwise
					hError[ 'block_code' ] 	:= ts_block[ 'code' ]
					hError[ 'block_error'] 	:= ts_block[ 'error' ]					
			endcase
			
		endif 


		
	//		
		
	hError[ 'description' ]	:= oError:description		
	
    if ! Empty( oError:operation )
		if substr( oError:operation, 1, 5 ) != 'line:'
			hError[ 'operation' ] := oError:operation
		endif
    endif   

    if ! Empty( oError:filename )
		hError[ 'filename' ] := oError:filename 
    endif  
   
	if ! Empty( oError:subsystem )
	
		hError[ 'subsystem' ] := oError:subsystem 
		
		if !empty( oError:subcode ) 
			hError[ 'subcode' ] :=  mh_valtochar(oError:subcode)
		endif
		
	endif  

	//	En el código preprocesado, buscamos tags #line (#includes,#commands,...)

		aLines = hb_ATokens( cCodePP, chr(10) )

	
		for n = 1 to Len( aLines )   

			cLine := aLines[ n ] 
		  
			if substr( cLine, 1, 5 ) == '#line' 

				nLin := Val(Substr( cLine, 6 ))				

				Aadd( aTagLine, { n, (nLin-n-1) } )
				
			endif 	  

		next 
		
_d( 'Tagline')		
_d( aTagLine )	

	//	Buscamos si oError nos da Linea
	
		nL 			:= 0					
		
		if ! Empty( oError:operation )
	  
			nPos := AT(  'line:', oError:operation )

			if nPos > 0 				
				nL := Val( Substr( oError:operation, nPos + 5 ) ) 
			endif	  	  
		  
		endif 
		
_d( 'Line1')	
_d( nL )	
	
	//	Procesamos Offset segun linea error
	
		hError[ 'line' ] := nL
		hError[ 'tag' ] := aTagLine
		
		if nL > 0
		
			hError[ 'line' ] := nL 
		
			//	Xec vectors 	
			//	{ nLine, nOffset }
			//	{ 1, 5 }, { 39, 8 }
			
			for n := 1  to len( aTagLine ) 
				
				if aTagLine[n][1] < nL 
					nOffset 			:= aTagLine[n][2]
					hError[ 'line' ]	:= nL + nOffset 
				endif		
			
			next 
	
		else 
		
		/*
			for n := 1  to len( aTagLine ) 
				
				//if aTagLine[n][1] < nL 
					nOffset 			:= aTagLine[n][2]					
					hError[ 'line' ] := ProcLine( 4 ) + nOffset  //	we need validate
				//endif		
			
			next 		
			*/
			
		endif

_d( 'Line2')	
_d( hError[ 'line' ] )		


    if ValType( oError:Args ) == "A"
		hError[ 'args' ] := oError:Args
    endif	
	
	
	/* OLD VERSION 
    n = 2 
	lReview = .f.
  
    while ! Empty( ProcName( n ) )  
	
		cInfo := "called from: " + If( ! Empty( ProcFile( n ) ), ProcFile( n ) + ", ", "" ) + ;
               ProcName( n ) + ", line: " + ;
               AllTrim( Str( ProcLine( n ) ) ) 
			   
		Aadd( hError[ 'stack' ], cInfo )
		
		n++
		
		if nL == 0 .and. !lReview 
	
			if ProcFile(n) == 'pcode.hrb'
				nL := ProcLine( n )
				
				lReview := .t.
			endif
		
		endif
	
		
	end
	
	*/
	
	
	//if ! Empty( ProcName( 2 ) ) .and.  ProcName( 2 ) == '(b)MC_VIEWER_EXEC' 
	if  ProcName( 2 ) == '(b)MC_VIEWER_EXEC' 
		nL := ProcLine( 2 )	
		lReview := .t.
	endif 
	
	
	
	
	
_d( 'Line3')	
_d( nL )		

	if lReview .and. nL > 0 
		
		hError[ 'line' ] := nL 
		
		for n := 1  to len( aTagLine ) 
			
			if aTagLine[n][1] < nL 
				nOffset 			:= aTagLine[n][2]
				hError[ 'line' ]	:= nL + nOffset 
			endif		
		
		next 	

	endif 
	
_d( 'Line4')	
_d( hError[ 'line' ] )

_d( 'STACk....')		
_d( hError[ 'stack' ])

_d( 'BLOCK-----------------' )
_d( mc_get_hBlock() )
_d( 'END BLOCK-----------------' )

	//	--------------------------------------
_d('B1')	
_d(oError:subsystem)	
		if oError:subsystem  == 'COMPILER'
_d('B2')	

			if substr( oError:operation, 1, 4 ) == 'line' 

_d('B3')	
				hError[ 'line' ] := Val(Substr( oError:operation, 6 ))	
_d('B4')	
				
			endif
					

		
		
		endif 	
		
_d( 'LINE' )		
_d( hError[ 'line' ]  )		
_d( 'VIEW')
_d( hError[ 'view' ]  )		
	
	
	
	//	--------------------------------------
	
		if valtype( oError:subcode ) == 'N'
		
			do case
			case oError:subcode == 6101 	//Unknown or unregistered symbol

				aLines 	:= hb_ATokens( hError[ 'code' ], chr(10) )
				
				for n = 1 to Len( aLines )

					cLine := upper(aLines[ n ] )
					
					if At( oError:operation, cLine ) > 0
			
						hError[ 'line' ] := n 
						exit
					endif 

				next
				
			case oError:subcode == 100 	//	MC Error. Doesn't exist method
					hError[ 'line' ] := 0
					
			
			endcase
		
		
		endif 

	//	--------------------------------------	

	//MC_ViewError( hError )
	
retu hError 


// ----------------------------------------------------------------//

function MC_ErrorView( hError )

	local cHtml := ''
    local n, aPair, cInfo 
	local cTitle, aLines, cLine


	BLOCKS TO cHtml 

		<style>
		
			body { background-color: lightgray; }
			
			table { box-shadow: 2px 2px 2px black; }
			
			table, th, td {
				border-collapse: collapse;
				padding: 5px;
				font-family: tahoma;
				border: 1px solid black;
			}
			th, td {
				border-bottom: 1px solid #ddd;
			}			
			th {
			  background-color: #4e4e4e;
			  color: white;
			}	
			
			tr:hover { background-color: yellow; }
			
			.title {
				width:100%;
				height:70px;
			}
			
			.title_error {
				margin-left: 20px;
				float: left;
				margin-top: 20px;
				font-size: 26px;
				font-family: sans-serif;
				font-weight: bold;
			}
			
			.logo {
				float:left;
				width: 65px;
			}
			
			.description {
				font-weight: bold;
				background-color: white;
			}
			
			.value {				
				background-color: white;
			}	

			.mc_container_code {
				width: 100%;
				border: 1px solid black;
				box-shadow: 2px 2px 2px black;
				margin-top: 10px;			
			}
			
			.mc_code_title {
				font-family: tahoma;
			    text-align: center;
				background-color: #4e4e4e;
				padding: 5px;
				color: white;
			}
			
			.mc_code_source {
				padding: 5px;
				font-family: monospace;
				font-size: 12px;
				background-color: #e0e0e0;				
			}
			
			.mc_line_error {
			    background-color: #9b2323;
				color: white;
			}			
			
		</style>
		
		<!DOCTYPE html>
		<html lang="en">
		<head>
			<meta charset="UTF-8">
			<meta name="viewport" content="width=device-width, initial-scale=1">
			<title>ErrorSys</title>										
			<link rel="shortcut icon" type="image/png" href="{{ mh_favicon() }}"/>
		</head>		
		
		<div class="title">
			<img class="logo" src="{{ mc_logo() }}"></img>
			<p class="title_error">Mercury Error</p>			
		</div>
		
		<hr>		
		
		<div>
			<table>
				<tr>
					<th>Description</th>
					<th>Value</th>			
				</tr>	
	ENDTEXT 
/*	
	if !empty( hError[ 'view' ] )
		cHtml += '<tr><td class="description">View</td><td class="value">' + hError[ 'view' ] + '</td><tr>'	
	endif
*/	
	
	cHtml += '<tr><td class="description">Description</td><td class="value">' + hError[ 'description' ] + '</td><tr>'
	
	if !empty( hError[ 'operation' ] )
		cHtml += '<tr><td class="description">Operation</td><td class="value">' + hError[ 'operation' ] + '</td><tr>'
	endif

	
	if !empty( hError[ 'line' ] )
		cHtml += '<tr><td class="description">Line</td><td class="value">' + ltrim(str(hError[ 'line' ])) + '</td><tr>'
	endif
	
	cHtml += '<tr><td class="description">System</td><td class="value">' + hError[ 'subsystem' ] + if( !empty(hError[ 'subcode' ]), '/' + hError[ 'subcode' ], '') +  '</td><tr>'
	
	if !empty( hError[ 'args' ] )		
	
		cInfo := ''
	
		for n = 1 to Len( hError[ 'args' ] )
			cInfo += "[" + Str( n, 4 ) + "] = " + ValType( hError[ 'args' ][ n ] ) + ;
					"   " + MH_ValToChar( hError[ 'args' ][ n ] ) + ;
					If( ValType( hError[ 'args' ][ n ] ) == "A", " Len: " + ;
					AllTrim( Str( Len( hError[ 'args' ][ n ] ) ) ), "" ) + "<br>"
		next	
	  
		cHtml +=  '<tr><td class="description">System</td><td class="value">' + cInfo +  '</td><tr>'					
		
	endif 
	
	
	
	BLOCKS TO cHtml 

				</table>
			</div>		
	ENDTEXT 	
	
	
	do case
	
		case hError[ 'type' ] == 'block' 					

			cTitle 	:= 'Code Block'
			cInfo 		:= '<div class="mc_block_error"><b>Error => </b><span class="mc_line_error">' + hError[ 'block_error' ] + '</span></div>'								
			aLines 	:= hb_ATokens( hError[ 'block_code' ], chr(10) )
	
		case hError[ 'type' ] == '' 		

			cTitle 	:= 'Code'
			cInfo 	:= ''
			aLines 	:= hb_ATokens( hError[ 'code' ], chr(10) )
			
		case hError[ 'type' ] == 'initprocess' 					

			cTitle 	:= 'InitProcess'
			cInfo 	:= '<div class="mc_block_error"><b>Filename => </b><span class="mc_line_error">' + hError[ 'filename' ] + '</span></div>'
			aLines 	:= {}	

		otherwise 
		
			cTitle 	:= hError[ 'type' ]
			cInfo 	:= ''
			aLines 	:= hb_ATokens( hError[ 'block_code' ], chr(10) )			
	endcase	
	
	

	
	for n = 1 to Len( aLines )

		cLine := aLines[ n ] 
		cLine := hb_HtmlEncode( cLine )
		cLine := StrTran( cLine, chr(9), '&nbsp;&nbsp;&nbsp;' )			  
	  
	  
	  if hError[ 'line' ] > 0 .and. hError[ 'line' ] == n
		cInfo += '<b>' + StrZero( n, 4 ) + ' <span class="mc_line_error">' + cLine + '</span></b>'
	  else			
		cInfo += StrZero( n, 4 ) + ' ' + cLine 
	  endif 
	  
	  cInfo += '<br>'

	next	

	cHtml += '<div class="mc_container_code">'
	cHtml += ' <div class="mc_code_title">' + cTitle + '</div>'
	cHtml += ' <div class="mc_code_source">' + cInfo + '</div>'
	cHtml += '</div>' 	
	
	
			
	BLOCKS TO cHtml 
			<h3>Send mail to administrator: <a href="mailto:admin@mh.com">admin@mh.net</a></h3>
		</html>
		
	ENDTEXT 	
	
	ap_rputs( cHtml )


retu nil   