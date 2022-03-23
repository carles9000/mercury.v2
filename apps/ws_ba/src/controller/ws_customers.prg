CLASS WS_Customers

	METHOD New() 	CONSTRUCTOR
	
	METHOD GetByState()	
		
   	
ENDCLASS

//	---------------------------------------------------------------	//

METHOD New( oController ) CLASS WS_Customers
	
	AUTENTICATE CONTROLLER oController 
	
RETU SELF

//	---------------------------------------------------------------	//

METHOD GetByState( oController ) CLASS WS_Customers

	local oCusto
	local hData, hResponse
	local oValidator, aRows, nTotal, nLen 
	
	//	Data Recover	-----------------------------------------------------------
	
		hData 		:= oController:GetAll()	
		

	//	Data validate	-----------------------------------------------------------
	
		DEFINE VALIDATOR oValidator WITH hData
			PARAMETER 'state' 	NAME 'State' ROLES 'required|string|maxlen:2' FORMATTER 'toUpper' OF oValidator	
		RUN VALIDATOR oValidator 
		
		if oValidator:lError
		
			hResponse := {'success' => .f., 'error' => oValidator:ErrorString()} 
						
			OUTPUT 'json' WITH hResponse OF oController
			
			//oController:oResponse:SendJson( {'success' => .f., 'error' => oValidator:ErrorString()} )
			retu nil
		endif
	
	
	//	Data process ------------------------------------------------------------
	
		oCusto	:= CustomerModel():New()	
	
		aRows	:= oCusto:RowsByState( hData[ 'state' ] )
		nTotal	:= oCusto:Count()
		nLen 	:= len( aRows )
		

	//	Send Response	----------------------------------------------------------

		hResponse := {'success' => .t., 'total' => nTotal, 'len' => nLen, 'data' => aRows }
		
		OUTPUT 'json' WITH hResponse OF oController
		
		//oController:oResponse:SendJson( {'success' => .t., 'total' => nTotal, 'len' => nLen, 'data' => aRows} )
	
RETU NIL

//	---------------------------------------------------------------	//

//	Load datamodel	-------------------------------------------------------------

	{% mh_LoadFile( "/src/model/customermodel.prg" ) %}
	