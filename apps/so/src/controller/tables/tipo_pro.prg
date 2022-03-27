CLASS Tipo_Pro

	METHOD New() 	CONSTRUCTOR
	
	METHOD Show()
	
	METHOD Action()
	METHOD Load()
	METHOD Save()
	
ENDCLASS

//	---------------------------------------------------------------	//

METHOD New( oController ) CLASS Tipo_Pro

	//AUTENTICATE CONTROLLER oController
	
RETU SELF

//	---------------------------------------------------------------	//

METHOD Show( oController ) CLASS Tipo_Pro	

	local oTipo_Pro	:= Tipo_ProModel():New()	
	local hData 		:= oTipo_Pro:GetAll()
	
	//	Si es una tabla que se puede cargar toda, la pasamos,
	//	sino, no pasaremos nada...

	oController:View( 'tables/Tipo_Pro.view', 200, hData )	

RETU NIL


//	---------------------------------------------------------------	//

METHOD Action( oController ) CLASS Tipo_Pro	

	local hParam 		:= GetMsgServer()	
	
	do case
		case hParam[ 'action' ] == 'load' ; ::Load( oController, hParam )
		case hParam[ 'action' ] == 'save' ; ::Save( oController, hParam )
	endcase

RETU NIL 

//	---------------------------------------------------------------	//

METHOD Save( oController, hParam ) CLASS Tipo_Pro		
	
	local aData 		:= hParam[ 'data' ]
	local oTipo_Pro	:= Tipo_ProModel():New()	
	local nUpdated 	:= 0
	local aUpdated 	:= 0
	local hResponse 
	
	//	Process data...	
	
		aUpdated := oTipo_Pro:oDataset:Save( aData )
		nUpdated := len( aUpdated )		

		
		hResponse := { 'success' => .T., 'updated' => nUpdated, 'rows_updated' => aUpdated, 'error' => oTipo_Pro:oDataset:GetError(), 'errortxt' => oTipo_Pro:oDataset:GetErrorString() }
				
	oController:oResponse:SendJson( hResponse )

RETU NIL

//	---------------------------------------------------------------	//

METHOD Load( oController, hParam ) CLASS Tipo_Pro	
	
	
	local oTipo_Pro 	:= Tipo_ProModel():New()	
	local aRows 		:= oTipo_Pro:Search( hParam[ 'tag'],  hParam[ 'search' ] )

	//	hResponse := { 'success' => .T., 'updated' => nUpdated, 'rows_updated' => aUpdated, 'error' => oCliente:oDataset:GetError(), 'errortxt' => oCliente:oDataset:GetErrorString() }
	
	oController:oResponse:SendJson( { 'rows' => aRows } )

RETU NIL


//	---------------------------------------------------------------	//

//	Load datamodel		---------------------------------------------

	{% mh_LoadFile( "/src/model/Tipo_Promodel.prg" ) %}
