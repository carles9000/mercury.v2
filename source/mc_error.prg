

FUNCTION MC_ErrorSys( oError, cCode, cCodePP )

	LOCAL hError

	hb_default( @cCode, "" )
	hb_default( @cCodePP, "" )
	

	//	Delete buffer out
   
		//ts_cBuffer_Out := ''
		
	//	Recover data info error
	
		hError := MC_ErrorInfo( oError, cCode, cCodePP )



		MC_ErrorView( hError )
		//MC_ViewError( hError )

RETU NIL


function MC_ErrorInfo( oError, cCode, cCodePP )

	local cInfo 	:= ''
	local cStack 	:= ''
	local aTagLine 	:= {}
	local hError	:= {=>}
    local n, aLines, nLine, cLine, nPos, nErrorLine, nL  	
	local nLin, nOffSet, lReview, ts_block, cProc
	local lSearch, cSearch
	local lSearchTag := .f. 

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
		hError[ 'view' ]		:= mc_get( 'view', '')
		

	//	Check error from BLOCKS 
	
			
			hError[ 'type' ] 		:= mc_get( 'type', '' )
			
			do case	
				case hError[ 'type' ] == 'block'
					hError[ 'block_code' ] 	:= mc_get( 'code', '' )
					hError[ 'block_error'] 	:= mc_get( 'error', '' )
				
				//case hError[ 'type' ] == 'initprocess'
				//	hError[ 'filename' ]	:= ts_block[ 'filename' ]
					
				otherwise
					hError[ 'block_code' ] 	:= mc_get( 'code', '' )
					hError[ 'block_error'] 	:= mc_get( 'error', '' )				
			endcase
			
	


		
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
	endif  
	
	if !empty( oError:subcode ) 
		hError[ 'subcode' ] :=  mh_valtochar(oError:subcode)
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


	//	Buscamos si oError nos da Linea
	
		nL 			:= 0					
		
		if ! Empty( oError:operation )
	  
			nPos := AT(  'line:', oError:operation )

			if nPos > 0 				
				nL := Val( Substr( oError:operation, nPos + 5 ) ) 
			endif	  	  
		  
		endif 

	
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



    if ValType( oError:Args ) == "A"
		hError[ 'args' ] := oError:Args
    endif	
	

	

    n = 2 

  
    while ! Empty( ProcName( n ) )  
	
		cInfo := "called from: " + If( ! Empty( ProcFile( n ) ), ProcFile( n ) + ", ", "" ) + ;
               ProcName( n ) + ", line: " + ;
               AllTrim( Str( ProcLine( n ) ) ) 
			   
		Aadd( hError[ 'stack' ], cInfo )
		
		n++
		
	end

	//_d( 'STACK-----------------')
	//_d( hError[ 'stack' ] )

	
	cProc := ProcName( 2 )
	lReview = .f.
	
	do case 
		case cProc == '(b)MC_ROUTER_EXECUTECLASS'
		
			//if nL == 0 .and. !lReview 
			if hError[ 'line' ] == 0 .and. !lReview 
			
				n = 2 
			  
				while ! Empty( ProcName( n ) )  
					
					n++						
				
					if ProcFile(n) == 'pcode.hrb'
						nL := ProcLine( n )
						
						lReview := .t.
						exit					
					endif		
					
				end			
		
			endif
			
		case cProc == '(b)MC_VIEWER_EXEC'
		
			nL := ProcLine( 2 )	
			lReview := .t.
			
		otherwise 
		
			if lReview .and. nL > 0 
			
				hError[ 'line' ] := nL 
			
				for n := 1  to len( aTagLine ) 
					
					if aTagLine[n][1] < nL 
						nOffset 			:= aTagLine[n][2]
						hError[ 'line' ]	:= nL + nOffset 
					endif		
				
				next 	

			endif 
		
	endcase 
	

	//	--------------------------------------


		if oError:subsystem  == 'COMPILER'


			if substr( oError:operation, 1, 4 ) == 'line' 


				hError[ 'line' ] := Val(Substr( oError:operation, 6 ))	
	
				
			endif
					

		
		
		endif 	

	
	//	--------------------------------------
	
		if valtype( oError:subcode ) == 'N'
		

			lSearch 	:= .f. 
			lSearchTag	:= .f. 
			cSearch 	:= ''
		
			do case
				case oError:subcode == 1004 	//	Message not found
					lSearch := .t. 
					nPos := At( ':', oError:operation )
					if nPos > 0 
						cSearch := Substr( oError:operation, nPos )
					endif
				case oError:subcode == 6101 	//	Unknown or unregistered symbol
					lSearch := .t. 
					cSearch := oError:operation
					
				case oError:subcode == 100 	//	MC Error. Doesn't exist method
						hError[ 'line' ] := 0								
			endcase
		
			if lSearch 
			
				aLines 	:= hb_ATokens( hError[ 'code' ], chr(10) )
				for n = 1 to Len( aLines )

					cLine := upper(aLines[ n ] )
				
					
					if At( cSearch, cLine ) > 0
			
						hError[ 'line' ] := n 
						lSearchTag := .t. 
					
						exit
					endif 

				next
			
			endif
		
		
		endif 
	
	//	--------------------------------------
	
	if ! lSearchTag 

		nL := hError[ 'line' ]
		for n := 1  to len( aTagLine ) 
			
			if aTagLine[n][1] < nL 
				nOffset 			:= aTagLine[n][2]
				hError[ 'line' ]	:= nL + nOffset 
			endif		
		
		next 

	endif
				


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
	
	
	
	if HB_HHasKey( hError, 'view' ) .and. !empty( hError[ 'view' ] )
		cHtml += '<tr><td class="description">View</td><td class="value">' + hError[ 'view' ] + '</td><tr>'	
	endif
	
	
	cHtml += '<tr><td class="description">Description</td><td class="value">' + hError[ 'description' ] + '</td><tr>'
	
	if !empty( hError[ 'operation' ] )
		cHtml += '<tr><td class="description">Operation</td><td class="value">' + hError[ 'operation' ] + '</td><tr>'
	endif
	
	if !empty( hError[ 'filename' ] )
		cHtml += '<tr><td class="description">Filename</td><td class="value">' + hError[ 'filename' ] + '</td><tr>'
	endif	

	
	if !empty( hError[ 'line' ] )
		cHtml += '<tr><td class="description">Line</td><td class="value">' + ltrim(str(hError[ 'line' ])) + '</td><tr>'
	endif
	
	if hError[ 'subcode' ] == '99999'
		cHtml += '<tr><td class="description">System</td><td class="value">' + hError[ 'subsystem' ]  +  '</td><tr>'
	else
		cHtml += '<tr><td class="description">System</td><td class="value">' + hError[ 'subsystem' ] + if( !empty(hError[ 'subcode' ]), '/' + hError[ 'subcode' ], '') +  '</td><tr>'
	endif
	
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

	if hError[ 'subcode' ] != '99999'	
	
	
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
	
	endif
			
	BLOCKS TO cHtml 
			<h3>Send mail to administrator: <a href="mailto:admin@mh.com">admin@mh.net</a></h3>
		</html>
		
	ENDTEXT 	
	
	ap_rputs( cHtml )


retu nil   