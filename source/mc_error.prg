function MC_ErrorSys( oError, cCode, cCodePP )

	local cInfo 	:= ''
	local cStack 	:= ''
	local aTagLine 	:= {}
	local hError	:= {=>}
    local n, aLines, nLine, cLine, nPos, nErrorLine, nL  	
	local nLin, nOffSet, lReview

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

	
	//	Check error from BLOCKS 
/*	
		if !empty( ts_block )
		
			hError[ 'type' ] 		:= ts_block[ 'type' ]	// 'block'
			
			do case	
				case hError[ 'type' ] == 'block'
					hError[ 'block_code' ] 	:= ts_block[ 'code' ]
					hError[ 'block_error'] 	:= ts_block[ 'error' ]
				
				case hError[ 'type' ] == 'initprocess'
					hError[ 'filename' ]	:= ts_block[ 'filename' ]
			endcase
			
		endif 
*/
		
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
	
    n = 1 
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

	if lReview .and. nL > 0 
		
		hError[ 'line' ] := nL 
		
		for n := 1  to len( aTagLine ) 
			
			if aTagLine[n][1] < nL 
				nOffset 			:= aTagLine[n][2]
				hError[ 'line' ]	:= nL + nOffset 
			endif		
		
		next 	

	endif 
	

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

	MC_ViewError( hError )
	
retu hError 

