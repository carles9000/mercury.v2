//	-----------------------------------------------------------	//
//	New Version V2

CLASS MC_Validator

	DATA hData						INIT {=>}
	DATA hValidate					INIT {=>}
	DATA aErrorMessages			INIT {}	
	DATA cRoute						INIT ''
	DATA lJson						INIT .F.
	DATA lError						INIT .F.

	METHOD New() CONSTRUCTOR

	METHOD Run( hValidate )
	
	METHOD Formatter( hData, hFormat )		
	METHOD EvalValue( cKey, cValue )
	
	METHOD Set( cParameter, cRoles )					
	
	METHOD ErrorMessages()							INLINE ::aErrorMessages	
	METHOD ErrorString()							

ENDCLASS

//	-------------------------------------------------------------------------	//	

METHOD New( hData, cRoute, lJson ) CLASS MC_Validator

	DEFAULT lJson := .F.

	::hData 		:= hData
	::hValidate 	:= {=>}	
	
	//	Disabled
	//::cRoute 		:= MC_RouteToController( cRoute )
	//::lJson			:= lJson
	
RETU Self

//	-------------------------------------------------------------------------	//	

METHOD Run() CLASS MC_Validator

	LOCAL hMsg
	LOCAL n, aH, cKey, aValue, o, hResponse, cRoles, cName, cFormat, uDefault

	
	FOR n := 1 to len( ::hValidate )
	
		aH := hb_HPairAt( ::hValidate, n )
		
		cKey 	:= aH[1]
		aValue 	:= aH[2]
		
		cRoles 		:= aValue[1]
		cName  		:= aValue[2]
		uDefault 	:= aValue[4]

		hMsg 	:= ::EvalValue( cKey, cRoles, cName, uDefault )

		IF hMsg[ 'success' ] == .F.
			
			Aadd( ::aErrorMessages, hMsg )
			
		ENDIF
	
	NEXT		

	::lError := len( ::aErrorMessages ) > 0
	
	if ::lError
		retu ::lError 
	endif
	
	//	Si llegamos aqui, se ha validado correctamente. Pasaremos a Formattear...
	
	FOR n := 1 to len( ::hValidate )
	
		aH := hb_HPairAt( ::hValidate, n )
		
		cKey 	:= aH[1]
		aValue 	:= aH[2]
		
		cRoles 	:= aValue[1]
		cFormat	:= aValue[3]
		
		::Formatter( cKey, cFormat )				
	
	NEXT	

RETU ::lError

//	-------------------------------------------------------------------------	//	

METHOD ErrorString( lBr ) CLASS MC_Validator
	
	LOCAL cError := '' 
	LOCAL nI 
	
	DEFAULT lBr := .t.

	FOR nI := 1 TO len( ::aErrorMessages )

		//cError += 'Param.: ' + ::aErrorMessages[nI][ 'name' ] + ', Error: ' + ::aErrorMessages[nI][ 'msg' ] + '<br>'	
		cError += ::aErrorMessages[nI][ 'name' ] + ', ' + ::aErrorMessages[nI][ 'msg' ] + if( lBr, '<br>', '' )
	NEXT			

RETU cError

//	-------------------------------------------------------------------------	//	

METHOD EvalValue( cKey, cValue, cName, uDefault ) CLASS MC_Validator

	//LOCAL oReq 		:= App():oRequest     //::oRoute:oTRequest	
	LOCAL aRoles, n, nRoles, cRole
	LOCAL uValue, lINE  		
	LOCAL cargo
	//LOCAL cMethod 	:= oReq:Method()
	
	__defaultNIL( @cValue, '' )
	__defaultNIL( @cName, '' )
	
	HB_HCaseMatch( ::hData, .F. )
	
	if HB_HHasKey( ::hData, cKey )	
	
		uValue := ::hData[ cKey ]				
	else
		RETU { 'success' => .F., 'field' => cKey, 'name' => cName,  'msg' => 'Parameter not defined', 'value' => '' }
	endif
	
	if valtype( uValue ) == 'U'
		uValue 				:= uDefault	
		::hData[ cKey ] 	:= uDefault	
		
	endif

	
	aRoles := HB_ATokens( cValue, '|' )
	nRoles := len( aRoles )	
	
	//	Aqui hemos de ponser todos los roles. Escalar !

	lINE := Ascan( aRoles, 'ine' ) > 0 
	
	FOR n = 1 to nRoles
	
		cRole := alltrim(lower(aRoles[n]))
		
		cName := IF( empty( cName ), cKey, cName )

		DO CASE
			CASE cRole == 'required'
				
				IF Valtype( uValue ) != 'L'
					IF ( empty( uValue ) .and. valtype(uValue) != 'N' )
					  
						RETU { 'success' => .F., 'field' => cKey, 'name' => cName,  'msg' => 'Parámetro requerido', 'value' => uValue }
						EXIT
					ENDIF
				ENDIF
				
			CASE cRole == 'numeric'	 .or. cRole == 'number'
			
				IF lINE .and. empty( uValue )
				
				ELSE 						

					IF ! ISDIGIT( alltrim( uValue) )
						RETU { 'success' => .F., 'field' => cKey, 'name' => cName,   'msg' => 'Valor no numérico', 'value' => uValue }
						EXIT
					ENDIF
				
				ENDIF

			CASE cRole == 'string'
			
				IF lINE .and. empty( uValue )
				
				ELSE 							
	
					IF ! ISALPHA( uValue )
						RETU { 'success' => .F., 'field' => cKey, 'name' => cName,   'msg' => 'Valor no string', 'value' => uValue  }
						EXIT
					ENDIF
				ENDIF

			CASE substr(cRole,1,4) == 'len:'
			
				IF lINE .and. empty( uValue )
				
				ELSE 							

					cargo := Val(substr(cRole, 5 ))

					IF len( uValue ) <> cargo	
						RETU { 'success' => .F., 'field' => cKey, 'name' => cName,   'msg' => 'Longitud ha de ser ' + ltrim(str(cargo)), 'value' => uValue  }
						EXIT
					ENDIF
					
				ENDIF
				
			CASE substr(cRole,1,4) == 'max:'
			
				IF lINE .and. empty( uValue )
				
				ELSE 							

					cargo 	:= Val(substr(cRole, 5 ))				

					IF  IF( valtype( uValue ) == 'N', uValue, Val(uValue))  > cargo	
						RETU { 'success' => .F., 'field' => cKey, 'name' => cName,   'msg' => 'Maxima valor de ' + ltrim(str(cargo)), 'value' => uValue  }
						EXIT
					ENDIF	
				
				ENDIF	

			CASE substr(cRole,1,4) == 'min:'
			
				IF lINE .and. empty( uValue )
				
				ELSE 							

					cargo 	:= Val(substr(cRole, 5 ))
					
					IF  IF( valtype( uValue ) == 'N', uValue, Val(uValue))  < cargo	
						RETU { 'success' => .F., 'field' => cKey, 'name' => cName,   'msg' => 'Minimo valor de ' + ltrim(str(cargo)), 'value' => uValue  }
						EXIT
					ENDIF		
					
				ENDIF				

			CASE substr(cRole,1,7) == 'maxlen:'
			
				IF lINE .and. empty( uValue )
				
				ELSE 							

					cargo := Val(substr(cRole, 8 ))

					IF valtype( uValue ) == 'C' .AND. len(uValue) > cargo
						RETU { 'success' => .F., 'field' => cKey,  'name' => cName,  'msg' => 'Maxima longitud de ' + ltrim(str(cargo)), 'value' => uValue  }
						EXIT
					ENDIF	
					
				ENDIF	

			CASE substr(cRole,1,7) == 'minlen:'
			
				IF lINE .and. empty( uValue )
				
				ELSE 							
				
					cargo := Val(substr(cRole, 8 ))

					IF valtype( uValue ) == 'C' .AND. len(uValue) < cargo
						RETU { 'success' => .F., 'field' => cKey, 'name' => cName,   'msg' => 'Minima longitud de ' + ltrim(str(cargo)), 'value' => uValue  }
						EXIT
					ENDIF	
				
				ENDIF	

			CASE cRole == 'ismail'
			
				IF lINE .and. empty( uValue )
				
				ELSE 			
	
					IF ! MC_IsMail( uValue )
						RETU { 'success' => .F., 'field' => cKey, 'name' => cName,   'msg' => 'Valor no mail', 'value' => uValue  }
						EXIT
					ENDIF	
				
				ENDIF	

			CASE cRole == 'date'	

				//	2022-12-01 
				
				IF lINE .and. empty( uValue )
				
				ELSE 
				
					IF len( uValue ) != 10 .or. ;
						Substr( uValue,5,1 ) != '-' .or. ;
						Substr( uValue,8,1 ) != '-' 
						
						RETU { 'success' => .F., 'field' => cKey, 'name' => cName,   'msg' => 'Valor no date', 'value' => uValue  }
						EXIT								
						
					ENDIF 
				
				ENDIF 
				
			CASE cRole == 'ine'		//	If Not Empty == INE
			
			
			OTHERWISE 
			
				RETU { 'success' => .F., 'field' => '', 'name' => '', 'msg' => 'Validator: dont exist role: ' + cRole , 'value' => ''  }
				EXIT			
							
		ENDCASE		
		
	NEXT								

RETU { 'success' => .T. }

//	-------------------------------------------------------------------------	//	

METHOD Formatter( cKey, cFormat ) CLASS MC_Validator

	local cFunc, uValue, cType 
	local cSet, uRet
	
	HB_HCaseMatch( ::hData, .F. )
	
		
	if valtype( cFormat ) == 'B'	
	
		if HB_HHasKey( ::hData, cKey )	
		
			uValue := ::hData[ cKey ]					

			::hData[ cKey ] := eval( cFormat, uValue )
			
		endif 
	
		retu nil 
	endif 		

	cFunc := alltrim(lower(cFormat))
	
	
	if empty( cFunc )
		return nil
	endif 
	
	
	
	
	if HB_HHasKey( ::hData, cKey )	
		uValue := ::hData[ cKey ]
		

		DO CASE
			CASE cFunc == 'upper' .or. cFunc == 'toupper'
			
				IF valtype( uValue ) == 'C' .and. !empty( uValue )			
					::hData[ cKey ] := Upper( uValue )						
				ENDIF
				
			CASE cFunc == 'lower'
			
				IF valtype( uValue ) == 'C' .and. !empty( uValue )			
					::hData[ cKey ] := Lower( uValue )						
				ENDIF	
				
			CASE cFunc == 'tonumber'
			
				IF valtype( uValue ) == 'C' .and. !empty( uValue )			
					::hData[ cKey ] := Val( uValue )						
				ENDIF	
				
			CASE cFunc == 'tologic'
			
				IF valtype( uValue ) == 'C' 
				
					if lower( uValue ) == 'true'
						::hData[ cKey ] := .T.
					ELSE
						::hData[ cKey ] := .F.					
					ENDIF 
				
				ENDIF			
				
			CASE cFunc == 'tobin'
			
				cType := valtype( uValue )
				
				do case				
					case cType == 'L' ; ::hData[ cKey ] := if( uValue, '1', '0')
					
					case cType == 'C' 
					
						if  lower( uValue ) == 'true' .or. uvalue == '1' 
							::hData[ cKey ] := '1'
						else
							::hData[ cKey ] := '0'
						endif
						
					case cType == 'N' ; ::hData[ cKey ] := if( uValue == 1, '1', '0')
					
					otherwise
						::hData[ cKey ] := '0'
				endcase 					
				
				
			CASE cFunc == 'todate'
			
				IF valtype( uValue ) == 'C' .and. !empty( uValue )	
				
					//	El formato fecha que viene en string desde la web es yyyy-mm-dd
					cSet 	:= Set( _SET_DATEFORMAT )				
					SET DATE FORMAT TO 'yyyy-mm-dd'
					::hData[ cKey ] := CTod( uValue )	
					Set( _SET_DATEFORMAT, cSet )					
				ENDIF					
				
				
		ENDCASE									
	else
		//App():ShowError( "Formatter validator doesn't exist: " + cKey , 'Validator' )
		//quit 		//	Atencion con los threads

	endif

RETU NIL

//	-------------------------------------------------------------------------	//	

METHOD Set( cParameter, cRoles, cName, cFormat, cDefault ) CLASS MC_Validator

	DEFAULT cRoles 	:= 'required'
	DEFAULT cName 		:= ''
	DEFAULT cFormat 	:= ''
	DEFAULT cDefault 	:= ''

	::hValidate[ lower( cParameter ) ] := { cRoles, cName, cFormat, cDefault }

RETU NIL