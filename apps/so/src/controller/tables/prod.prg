CLASS Prod

	METHOD New() 	CONSTRUCTOR
	
	METHOD Show()
	
	METHOD Action()
	METHOD Load()
	METHOD Save()
	
ENDCLASS

//	---------------------------------------------------------------	//

METHOD New( oController ) CLASS Prod

	//AUTENTICATE CONTROLLER oController
	
RETU SELF

//	---------------------------------------------------------------	//

METHOD Show( oController ) CLASS Prod	

	local oProd	:= ProdModel():New()	
	local hData 	:= oProd:GetAll()
	
	//	Si es una tabla que se puede cargar toda, la pasamos,
	//	sino, no pasaremos nada...

	oController:View( 'tables/prod.view', 200, hData )	

RETU NIL


//	---------------------------------------------------------------	//

METHOD Action( oController ) CLASS Prod	

	local hParam 		:= GetMsgServer()	
	
	do case
		case hParam[ 'action' ] == 'load' ; ::Load( oController, hParam )
		case hParam[ 'action' ] == 'save' ; ::Save( oController, hParam )
	endcase

RETU NIL 

//	---------------------------------------------------------------	//

METHOD Save( oController, hParam ) CLASS Prod		
	
	local aData 		:= hParam[ 'data' ]
	local oProd		:= ProdModel():New()	
	local nUpdated 	:= 0
	local aUpdated 	:= 0
	local hResponse 
	
	//	Process data...	
	
		aUpdated := oProd:oDataset:Save( aData )
		nUpdated := len( aUpdated )		

		
		hResponse := { 'success' => .T., 'updated' => nUpdated, 'rows_updated' => aUpdated, 'error' => oProd:oDataset:GetError(), 'errortxt' => oProd:oDataset:GetErrorString() }
				
	oController:oResponse:SendJson( hResponse )

RETU NIL

//	---------------------------------------------------------------	//

METHOD Load( oController, hParam ) CLASS Prod	
	
	
	local oProd 		:= ProdModel():New()	
	local aRows 		:= oProd:Search( hParam[ 'tag'],  hParam[ 'search' ] )

	//	hResponse := { 'success' => .T., 'updated' => nUpdated, 'rows_updated' => aUpdated, 'error' => oCliente:oDataset:GetError(), 'errortxt' => oCliente:oDataset:GetErrorString() }
	
	oController:oResponse:SendJson( { 'rows' => aRows } )

RETU NIL


//	---------------------------------------------------------------	//

//	Load datamodel		---------------------------------------------

	{% mh_LoadFile( "/src/model/prodmodel.prg" ) %}
