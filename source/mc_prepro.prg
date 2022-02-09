

FUNCTION MC_AddPPRules()

   LOCAL cOs := OS()
   LOCAL n, aPair, cExt 
   
   local hPP 
   
   //thread static hPP 

   //IF hPP == nil
      hPP = __pp_Init()

      DO CASE
      CASE "Windows" $ cOs  ; __pp_Path( hPP, "c:\harbour\include" )
      CASE "Linux" $ cOs   ; __pp_Path( hPP, "~/harbour/include" )
      ENDCASE

      IF ! Empty( hb_GetEnv( "HB_INCLUDE" ) )
         __pp_Path( hPP, hb_GetEnv( "HB_INCLUDE" ) )
      ENDIF
   //ENDIF

   __pp_AddRule( hPP, "#xcommand ? [<explist,...>] => ap_Echo( '<br>' [,<explist>] )" )
   __pp_AddRule( hPP, "#xcommand ?? [<explist,...>] => ap_Echo( [<explist>] )" )
   __pp_AddRule( hPP, "#define CRLF hb_OsNewLine()" )
   __pp_AddRule( hPP, "#xcommand TEXT <into:TO,INTO> <v> => #pragma __cstream|<v>:=%s" )
   __pp_AddRule( hPP, "#xcommand TEXT <into:TO,INTO> <v> ADDITIVE => #pragma __cstream|<v>+=%s" )
   __pp_AddRule( hPP, "#xcommand TEMPLATE [ USING <x> ] [ PARAMS [<v1>] [,<vn>] ] => " + ;
      '#pragma __cstream | ap_Echo( mc_InlinePrg( %s, [@<x>] [,<(v1)>][+","+<(vn)>] [, @<v1>][, @<vn>] ) )' )
   __pp_AddRule( hPP, "#xcommand BLOCKS [ PARAMS [<v1>] [,<vn>] ] => " + ;
      '#pragma __cstream | ap_Echo( mc_ReplaceBlocks( %s, "{{", "}}" [,<(v1)>][+","+<(vn)>] [, @<v1>][, @<vn>] ) )' )
   __pp_AddRule( hPP, "#xcommand BLOCKS TO <b> [ PARAMS [<v1>] [,<vn>] ] => " + ;
      '#pragma __cstream | <b>+=mc_ReplaceBlocks( %s, "{{", "}}" [,<(v1)>][+","+<(vn)>] [, @<v1>][, @<vn>] )' )
	  
   __pp_AddRule( hPP, "#xcommand BLOCKS VIEW <b> [ PARAMS [<v1>] [,<vn>] ] => " + ;
      '#pragma __cstream | <b>+=mc_ReplaceBlocks( %s, "<$", "$>" [,<(v1)>][+","+<(vn)>] [, @<v1>][, @<vn>] )' )	  
	  
   __pp_AddRule( hPP, "#command ENDTEMPLATE => #pragma __endtext" )
   __pp_AddRule( hPP, "#xcommand TRY  => BEGIN SEQUENCE WITH {| oErr | Break( oErr ) }" )
   __pp_AddRule( hPP, "#xcommand CATCH [<!oErr!>] => RECOVER [USING <oErr>] <-oErr->" )
   __pp_AddRule( hPP, "#xcommand FINALLY => ALWAYS" )
   __pp_AddRule( hPP, "#xcommand DEFAULT <v1> TO <x1> [, <vn> TO <xn> ] => ;" + ;
      "IF <v1> == NIL ; <v1> := <x1> ; END [; IF <vn> == NIL ; <vn> := <xn> ; END ]" )


 __pp_AddRule( hPP, "#xcommand DEFINE VALIDATOR <oValidator> WITH <hData> "+;
	"[<err:ERROR ROUTE, DEFAULT> <cRoute>] [<json:ERROR JSON> ] => " + ;
	"<oValidator> := MC_Validator():New( <hData>, [<cRoute>], [<.json.>]  )" )
	
 __pp_AddRule( hPP, "#xcommand PARAMETER <cParameter> [NAME <cName>] [ROLES <cRoles>] [FORMATTER <cFormat>] OF <oValidator> => " +;
	"<oValidator>:Set( <cParameter>, <cRoles>, [<cName>], [<cFormat>] )	" )
	
 __pp_AddRule( hPP, "#xcommand RUN VALIDATOR <oValidator> => <oValidator>:Run()" )



// OK	__pp_AddRule( hPP, hb_memoread( 'c:\xampp\htdocs\master\mercury.v2\source\mercury.ch' ) )			

	
//	__pp_AddRule( hPP, 'c:\xampp\htdocs\master\mercury.v2\source\mercury.ch' )			

	//	InitProcess .ch files
	/*
	for n := 1 to len(mh_HashModules())
	
		aPair 	:= HB_HPairAt( mh_HashModules(), n )		
		cExt 	:= lower( hb_FNameExt( aPair[1] ) )

		if cExt == '.ch' 	
			__pp_AddRule( hPP, aPair[2] )			
		endif 
		
	next 
	*/

RETURN hPP




FUNCTION MC_ReplaceBlocks( cCode, cStartBlock, cEndBlock, cParams, ... )

	LOCAL nStart, nEnd, cBlock
	LOCAL lReplaced := .F.   		
			
	hb_default( @cEndBlock, "}}" )
	hb_default( @cParams, "" )   

			
	mc_set( 'type', 'block')
	mc_set( 'code', cCode )
	mc_set( 'error', '' )
	


	WHILE ( nStart := At( cStartBlock, cCode ) ) != 0 .AND. ;
         ( nEnd := At( cEndBlock, cCode ) ) != 0
		 
		cBlock = SubStr( cCode, nStart + Len( cStartBlock ), nEnd - nStart - Len( cEndBlock ) )
	  
//		mh_stackblock( 'error', cStartBlock + cBlock + cEndBlock)
		mc_set( 'error', cStartBlock + cBlock + cEndBlock )


		cCode = SubStr( cCode, 1, nStart - 1 ) + ;
        mh_ValToChar( Eval( &( "{ |" + cParams + "| " + cBlock + " }" ), ... ) ) + ;
        SubStr( cCode, nEnd + Len( cEndBlock ) )		 

		lReplaced = .T.
	END         
   
	mc_set( 'type', '')
	mc_set( 'code', '' )
	mc_set( 'error', '' )
	


//RETURN If( hb_PIsByRef( 1 ), lReplaced, cCode )
RETURN cCode 



// ----------------------------------------------------------------//

function MC_InlinePRG( cText, cParams, ... )

	LOCAl BlocA, BlocB
	LOCAL nStart, nEnd, cCode, cResult
	//local oInfo :=	_PushInfo()
	local cPreCode 	:= cText
	
	DEFAULT cParams	:= ''
	
	//	oInfo[ 'cargo' ] := 'InlinePRG'
	//	oInfo[ 'block' ] := cText

	//hb_default( @oInfo, {=>} )
	
	WHILE ( nStart := At( "<?prg", cText ) ) != 0
	
		nEnd  := At( "?>", SubStr( cText, nStart + 5 ) )
	  
		BlocA := SubStr( cText, 1, nStart - 1 )
		cCode := SubStr( cText, nStart + 5, nEnd - 1 )
		BlocB := SubStr( cText, nStart + nEnd + 6 )	
	

		//oInfo[ 'code' ] := cCode 
		

		cResult := mc_ExecInline( cCode, cParams, ... ) 

		
		IF Valtype( cResult ) != 'C' 

		
			//oInfo[ 'code' ] := cCode  
			//modDoError( "Block don't return string" ) 
			
			return nil //	No podemos usar QUIT 
		ENDIF
		
	
		cText 	:= BlocA + cResult + BlocB              
 
	END
	
	//oInfo := _PopInfo()
	//oInfo[ 'code' ] := cCode 

	
RETU cText 

// ----------------------------------------------------------------//

FUNCTION MC_ExecInline( cCode, cParams, ... )

   IF cParams == nil
      cParams = ""
   ENDIF


RETURN MC_Execute( "function __Inline( " + cParams + " )" + hb_osNewLine() + cCode, ... )
 
// ----------------------------------------------------------------//


FUNCTION MC_Execute( cCode, ... )

	local oHrb := MC_Compile( cCode, ... )	
	local pSym, uRet 
	


   IF ! Empty( oHrb )
   
	  WHILE !hb_mutexLock( mh_Mutex() )
	  ENDDO	  

	  pSym := hb_hrbLoad( HB_HRB_BIND_OVERLOAD, oHrb )
	  

	  hb_mutexUnlock( mh_Mutex() )

      uRet := hb_hrbDo( pSym, ... )


   ENDIF





retu uRet 

// ----------------------------------------------------------------//

function MC_Compile( cCode, cCodePP )

	local oHrb, pSym
	local hPP
	local hError 	
	LOCAL cOs   		:= OS()
	LOCAL cHBHeader  := ''
	//LOCAL cCodePP  := ''

	DEFAULT cCodePP := ''

	DO CASE
		CASE "Windows" $ cOs  ; cHBHeader := "c:\harbour\include"
		CASE "Linux" $ cOs   ; cHBHeader := "~/harbour/include"
	ENDCASE   

	mc_set( 'type', 'mc_compile')
	mc_set( 'code', cCode )
	mc_set( 'error', '' )	
	

	hPP := mc_AddPPRules()   


	mc_ReplaceBlocks( @cCode, "{%", "%}" )
   

	cCodePP := __pp_Process( hPP, cCode )

	oHrb = HB_CompileFromBuf( cCodePP, .T., "-n", "-q2", "-I" + cHBheader, ;
			"-I" + hb_GetEnv( "HB_INCLUDE" ), hb_GetEnv( "HB_USER_PRGFLAGS" ) )	

	mc_set( 'type', '')
	mc_set( 'code', '' )	

retu oHrb

// ----------------------------------------------------------------//


