CLASS Emp

	METHOD New() 	CONSTRUCTOR
	
	METHOD Show()
	
	METHOD Action()
	METHOD Load()
	METHOD Save()
	
	METHOD Search()	//	Browse Search...
	METHOD GetId()	
	
ENDCLASS

//	---------------------------------------------------------------	//

METHOD New( oController ) CLASS Emp

	AUTENTICATE CONTROLLER oController
	
RETU SELF

//	---------------------------------------------------------------	//

METHOD Show( oController ) CLASS Emp	
	local oEmp		:= EmpleadoModel():New()	
	local hData 	:= oEmp:GetAll()
	
	

	//	Si es una tabla que se puede cargar toda, la pasamos,
	//	sino, no pasaremos nada...

	oController:View( 'tables/emp.view', 200, hData )	

RETU NIL


//	---------------------------------------------------------------	//

METHOD Action( oController ) CLASS Emp	

	local hParam 		:= GetMsgServer()	
	
	do case
		case hParam[ 'action' ] == 'load' ; ::Load( oController, hParam )
		case hParam[ 'action' ] == 'save' ; ::Save( oController, hParam )
		case hParam[ 'action' ] == 'getid' ; ::GetId( oController, hParam )
	endcase

RETU NIL 

//	---------------------------------------------------------------	//

METHOD Save( oController, hParam ) CLASS Emp		
	
	local aData 		:= hParam[ 'data' ]
	local oEmp			:= EmpleadoModel():New()	
	local aResume
	local hResponse 
	
	//	Process data...	
	
		aResume := oEmp:oDataset:Save( aData )
		
		hResponse := { 'success' => .T., 'resume' => aResume }			
		
	oController:oResponse:SendJson( hResponse )

RETU NIL

//	---------------------------------------------------------------	//

METHOD Load( oController, hParam ) CLASS Emp	
	
	
	local oEmp 		:= EmpleadoModel():New()	
	local aRows 		:= oEmp:Search( hParam[ 'tag'],  hParam[ 'search' ] )

	//	hResponse := { 'success' => .T., 'updated' => nUpdated, 'rows_updated' => aUpdated, 'error' => oCliente:oDataset:GetError(), 'errortxt' => oCliente:oDataset:GetErrorString() }
	
	oController:oResponse:SendJson( { 'rows' => aRows } )

RETU NIL


//	---------------------------------------------------------------	//

METHOD Search( oController ) CLASS Emp	
	
	
	local oEmp 		:= EmpleadoModel():New()	
	local hParam		:= GetMsgServer()
	local aRows		:= {}
	
	/*
	if empty( hParam[ 'search' ] )
		oController:oResponse:SendJson( { 'success' => .f., 'rows' => aRows } )
		retu nil
	endif
	*/

	//	Buscamos en modelo --------------------------------
	
		oEmp 		:= EmpleadoModel():New()		
		aRows 		:= oEmp:Search( 'apellido', hParam[ 'search' ] )
		
	//	Respuesta -----------------------------------------		
	
	oController:oResponse:SendJson( { 'success' => .t., 'search' => hParam[ 'search' ], 'rows' => aRows } )

RETU NIL

//	---------------------------------------------------------------	//

METHOD GetId( oController, hParam ) CLASS Emp		
	
	local oEmp 		:= EmpleadoModel():New()	
	local hRow 		:= oEmp:GetId( val( hParam[ 'search' ] ) )
		
	
	oController:oResponse:SendJson( { 'success' => .t. , 'row' => hRow } )


RETU NIL




//	Load datamodel		---------------------------------------------

	{% mh_LoadFile( "/src/model/empleadomodel.prg" ) %}
