CLASS Shipper

	METHOD New() 	CONSTRUCTOR
	
	METHOD Show()
	
	METHOD Action()
	METHOD Load()
	METHOD Save()
	
ENDCLASS

//	---------------------------------------------------------------	//

METHOD New( oController ) CLASS Shipper

	//AUTENTICATE CONTROLLER oController
	
RETU SELF

//	---------------------------------------------------------------	//

METHOD Show( oController ) CLASS Shipper	

	local oShipper	:= ShipperModel():New()	
	local hData 			:= oShipper:GetAll()
	
	//	Si es una tabla que se puede cargar toda, la pasamos,
	//	sino, no pasaremos nada...

	oController:View( 'tables/shipper.view', 200, hData )	

RETU NIL


//	---------------------------------------------------------------	//

METHOD Action( oController ) CLASS Shipper	

	local hParam 		:= GetMsgServer()	
	
	do case
		case hParam[ 'action' ] == 'load' ; ::Load( oController, hParam )
		case hParam[ 'action' ] == 'save' ; ::Save( oController, hParam )
	endcase

RETU NIL 

//	---------------------------------------------------------------	//

METHOD Save( oController, hParam ) CLASS Shipper		
	
	local aData 			:= hParam[ 'data' ]
	local oShipper	:= ShipperModel():New()	
	local nUpdated 	:= 0
	local aUpdated 	:= 0
	local hResponse 
	
	//	Process data...	
	
		aUpdated := oShipper:oDataset:Save( aData )
		nUpdated := len( aUpdated )		

		
		hResponse := { 'success' => .T., 'updated' => nUpdated, 'rows_updated' => aUpdated, 'error' => oShipper:oDataset:GetError(), 'errortxt' => oShipper:oDataset:GetErrorString() }
				
	oController:oResponse:SendJson( hResponse )

RETU NIL

//	---------------------------------------------------------------	//

METHOD Load( oController, hParam ) CLASS Shipper	
	
	
	local oShipper 	:= ShipperModel():New()	
	local aRows 		:= oShipper:Search( hParam[ 'tag'],  hParam[ 'search' ] )

	//	hResponse := { 'success' => .T., 'updated' => nUpdated, 'rows_updated' => aUpdated, 'error' => oCliente:oDataset:GetError(), 'errortxt' => oCliente:oDataset:GetErrorString() }
	
	oController:oResponse:SendJson( { 'rows' => aRows } )

RETU NIL


//	---------------------------------------------------------------	//

//	Load datamodel		---------------------------------------------

	{% mh_LoadFile( "/src/model/shippermodel.prg" ) %}
