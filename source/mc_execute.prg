function MC_Compile( cCode )

	local oHrb, pSym
	local hPP
	local hError 	
	LOCAL cOs   		:= OS()
	LOCAL cHBHeader  := ''
	LOCAL cCodePP  := ''

	DO CASE
		CASE "Windows" $ cOs  ; cHBHeader := "c:\harbour\include"
		CASE "Linux" $ cOs   ; cHBHeader := "~/harbour/include"
	ENDCASE   
  
	hError 	:= ErrorBlock( {| oError | MC_ErrorSys( oError, @cCode, cCodePP ), Break( oError ) } )
	
	hPP := mh_AddPPRules()   

	mh_ReplaceBlocks( @cCode, "{%", "%}" )
   
	cCodePP := __pp_Process( hPP, cCode )

	oHrb = HB_CompileFromBuf( cCodePP, .T., "-n", "-q2", "-I" + cHBheader, ;
			"-I" + hb_GetEnv( "HB_INCLUDE" ), hb_GetEnv( "HB_USER_PRGFLAGS" ) )	

	

	WHILE !hb_mutexLock( MH_Mutex() )
	ENDDO	
	
	pSym := hb_hrbLoad( 2, oHrb )	//HB_HRB_BIND_OVERLOAD							

	
	hb_mutexUnlock( MH_Mutex() )

retu pSym