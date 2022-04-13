CLASS Tables

	METHOD New() 	CONSTRUCTOR
	
	METHOD Cliente()	
	METHOD Cliente2()	
	METHOD Cliente2_Save()	
	
	METHOD Prod()
	METHOD Prod_Load()
	METHOD Prod_Save()
	
ENDCLASS

//	---------------------------------------------------------------	//

METHOD New( oController ) CLASS Tables

	AUTENTICATE CONTROLLER oController
	
RETU SELF

//	---------------------------------------------------------------	//

METHOD Cliente( oController ) CLASS Tables	

	local oCliente	:= ClienteModel():New()	
	local hData 	:= oCliente:GetAll()

	//? 'customer'
	//? hData 
	//_w( hData )
	

	oController:View( 'tables/tables.view', 200, hData )

RETU NIL

//	---------------------------------------------------------------	//

METHOD Cliente2( oController ) CLASS Tables	

	local oCliente	:= ClienteModel():New()	
	local hData 	:= oCliente:GetAll()

	oController:View( 'tables/tables2.view', 200, hData )

RETU NIL


//	---------------------------------------------------------------	//

METHOD Cliente2_Save( oController ) CLASS Tables	

	
	local hParam 		:= GetMsgServer()	
	local aData 		:= hParam[ 'data' ]
	local oCliente		:= ClienteModel():New()	
	local nUpdated 		:= 0
	local aUpdated 		:= 0
	local hResponse 
	
	//	Process data...	
	
		aUpdated := oCliente:oDataset:Save( aData )
		nUpdated := len( aUpdated )		

		
		hResponse := { 'success' => .T., 'updated' => nUpdated, 'rows_updated' => aUpdated, 'error' => oCliente:oDataset:GetError(), 'errortxt' => oCliente:oDataset:GetErrorString() }
				
	oController:oResponse:SendJson( hResponse )

RETU NIL

//	---------------------------------------------------------------	//

METHOD Prod( oController ) CLASS Tables	

	local oProd	:= ProdModel():New()	
	local hData 	:= oProd:GetAll()
	
	//	Si es una tabla que se puede cargar toda, la pasamos,
	//	sino, no pasaremos nada...

	oController:View( 'tables/prod.view', 200, hData )	

RETU NIL

//	---------------------------------------------------------------	//

METHOD Prod_Save( oController ) CLASS Tables	

	
	local hParam 		:= GetMsgServer()	
	local aData 		:= hParam[ 'data' ]
	local oProd		:= ProdModel():New()	
	local nUpdated 		:= 0
	local aUpdated 		:= 0
	local hResponse 
	
	//	Process data...	
	
		aUpdated := oProd:oDataset:Save( aData )
		nUpdated := len( aUpdated )		

		
		hResponse := { 'success' => .T., 'updated' => nUpdated, 'rows_updated' => aUpdated, 'error' => oProd:oDataset:GetError(), 'errortxt' => oProd:oDataset:GetErrorString() }
				
	oController:oResponse:SendJson( hResponse )

RETU NIL

//	---------------------------------------------------------------	//

METHOD Prod_Load( oController ) CLASS Tables	

	
	local hParam 		:= GetMsgServer()	
	local oProd 		:= ProdModel():New()	
	local aRows 		:= oProd:Search( hParam[ 'tag'],  hParam[ 'search' ] )

	//	hResponse := { 'success' => .T., 'updated' => nUpdated, 'rows_updated' => aUpdated, 'error' => oCliente:oDataset:GetError(), 'errortxt' => oCliente:oDataset:GetErrorString() }
	
	oController:oResponse:SendJson( { 'rows' => aRows } )

RETU NIL


//	---------------------------------------------------------------	//

//	Load datamodel		---------------------------------------------

	{% mh_LoadFile( "/src/model/clientemodel.prg" ) %}
	{% mh_LoadFile( "/src/model/prodmodel.prg" ) %}
