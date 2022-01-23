
function MC_ViewError( hError )

	local cHtml := ''
	local aLines, n, cTitle, cInfo, cLine

	cHtml := MC_Info_Style()	
	cHtml += MC_Msg_Header( 'Mercury Error' )

	BLOCKS TO cHtml 	
		<div>
			<table class="mc_info">
				<tr class="mc_table_title">
					<th>Description</th>
					<th>Value</th>			
				</tr>	
	ENDTEXT 


	cHtml += MC_Msg_Row( 'Date', hError[ 'date' ] + ' ' + hError[ 'time' ] )	
	cHtml += MC_Msg_Row( 'Description', hError[ 'description' ] )	
	
	if !empty( hError[ 'operation' ] )
		cHtml += MC_Msg_Row( 'Operation', hError[ 'operation' ] )			
	endif
	
	
	if !empty( hError[ 'line' ] )
		cHtml += MC_Msg_Row( 'Line', hError[ 'line' ] )					
	endif
	
	if !empty( hError[ 'filename' ] )
		cHtml += MC_Msg_Row( 'Filename', hError[ 'filename' ] )							
	endif 
	
	cHtml += MC_Msg_Row( 'System', hError[ 'subsystem' ] + if( !empty(hError[ 'subcode' ]), '/' + hError[ 'subcode' ], '') )							


	if !empty( hError[ 'args' ] )		
	
		cInfo := ''
	
		for n = 1 to Len( hError[ 'args' ] )
			cInfo += "[" + Str( n, 4 ) + "] = " + ValType( hError[ 'args' ][ n ] ) + ;
					"   " + MH_ValToChar( hError[ 'args' ][ n ] ) + ;
					If( ValType( hError[ 'args' ][ n ] ) == "A", " Len: " + ;
					AllTrim( Str( Len( hError[ 'args' ][ n ] ) ) ), "" ) + "<br>"
		next	
	  
		cHtml += MC_Msg_Row( 'Arguments', cInfo )							
		
	endif 

	/*	Stack sale un churro q no da info...
	if !empty( hError[ 'stack' ] )
	
		cInfo := ''
	
		for n = 1 to Len( hError[ 'stack' ] )
			cInfo += hError[ 'stack' ][n] + '<br>'
		next	
	  
		cHtml += MC_Html_Row( 'Stack', cInfo )							
		
	endif 
	*/
	
	cHtml += '</table></div>'
	
	do case
	
		case hError[ 'type' ] == 'block' 					

			cTitle 	:= 'Code Block'
			cInfo 	:= '<div class="mc_block_error"><b>Error => </b><span class="mc_line_error">' + hError[ 'block_error' ] + '</span></div>'								
			aLines 	:= hb_ATokens( hError[ 'block_code' ], chr(10) )
	
		case hError[ 'type' ] == '' 		

			cTitle 	:= 'Code'
			cInfo 	:= ''
			aLines 	:= hb_ATokens( hError[ 'code' ], chr(10) )
			
		case hError[ 'type' ] == 'initprocess' 					

			cTitle 	:= 'InitProcess'
			cInfo 	:= '<div class="mc_block_error"><b>Filename => </b><span class="mc_line_error">' + hError[ 'filename' ] + '</span></div>'
			aLines 	:= {}		
			
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

	ap_rputs(  cHtml )

retu nil 