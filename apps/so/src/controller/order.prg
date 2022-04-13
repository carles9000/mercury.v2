CLASS Order

	METHOD New() 	CONSTRUCTOR
	
	METHOD Show()	
	METHOD Action()
	METHOD Load()
	
	METHOD Upd()
	METHOD Save()
	
ENDCLASS

//	---------------------------------------------------------------	//

METHOD New( oController ) CLASS Order

	//AUTENTICATE CONTROLLER oController
	
RETU SELF

//	---------------------------------------------------------------	//

METHOD Show( oController ) CLASS Order

	oController:View( 'order/order.view', 200, {} )

RETU NIL

//	---------------------------------------------------------------	//


METHOD Action( oController ) CLASS Order	

	local hParam 		:= GetMsgServer()	
	
	do case
		case hParam[ 'action' ] == 'load' ; ::Load( oController, hParam )
	endcase

RETU NIL 

//	---------------------------------------------------------------	//


METHOD Load( oController, hParam ) CLASS Order	
	
	
	local oPedido		:= PedidoModel():New()	
	local oCliente		:= oPedido:oCliente
	local aRows, aClients	
	
	hParam[ 'tag' ] := lower( hParam[ 'tag' ] )

	do case		
		case hParam[ 'tag' ] == 'id' 		;  aRows	:= oPedido:SearchExact( 'id', Val( hParam[ 'search' ] ) )
		case hParam[ 'tag' ] == 'cliente' 	;  aRows	:= oPedido:SearchExact( 'cliente', Val( hParam[ 'search' ] ) )
	endcase		

	oController:oResponse:SendJson( { 'rows' => aRows } )

RETU NIL


//	---------------------------------------------------------------	//

METHOD Upd( oController ) CLASS Order	

	local oPedido		:= PedidoModel():New()		
	local oShipper		:= ShipperModel():New()		
	local hParam		:= oController:GetAll()
	local oValidator 
	local hInfo 		:= {=>}
	local hShipper		:= {=>}
	
	DEFINE VALIDATOR oValidator WITH hParam
		PARAMETER 'id' 	NAME 'Id' ROLES 'required|number|maxlen:8' FORMATTER 'tonumber' OF oValidator			
	RUN VALIDATOR oValidator 
	
	if oValidator:lError
		oController:View( 'sys/error.view', 200, oValidator:ErrorString() )				
		retu 
	endif	

	if hParam[ 'id' ] == 0
	
		hInfo[ 'cab' ] := {}
		hInfo[ 'pos' ] := {}
		hInfo[ 'ocliente' ] := nil
		hInfo[ 'oempleado' ] := nil 
		
	else
		hInfo := oPedido:Load( hParam[ 'id' ] , .T. )
		
	endif
	
	hShipper := oShipper:GetAllCombo( 'id_type', 'name' )

	
	//_w( hInfo )
	//retu
		
	if empty( hInfo )
		oController:View( 'sys/error.view', 200, "Id doesn't exist: " + ltrim(str(hParam['id'])) )				
		retu nil
	endif

	
	oController:View( 'order/order_upd.view', 200, hInfo, hShipper )	
	
	
RETU NIL 


//	---------------------------------------------------------------	//

METHOD Save( oController ) CLASS Order	

	local hParam 		:= GetMsgServer()	
	local oPedido		:= PedidoModel():New()		
	local oValidator 
	local hError 		:= {=>}

	
	DEFINE VALIDATOR oValidator WITH hParam
		PARAMETER 'id' 		NAME 'Id' ROLES 'required|number|maxlen:8' FORMATTER 'tonumber' OF oValidator			
		PARAMETER 'id_cli'		NAME 'Id Cli' ROLES 'required|number|maxlen:8' FORMATTER 'tonumber' OF oValidator			
		PARAMETER 'id_emp'		NAME 'Id Empl' ROLES 'required|number|maxlen:8' FORMATTER 'tonumber' OF oValidator			
		PARAMETER 'data_ped'	NAME 'F. Pedido' ROLES 'ine|date|len:10' FORMATTER 'todate' OF oValidator			
		PARAMETER 'data_req'	NAME 'F. Req' ROLES 'ine|date|len:10' FORMATTER 'todate' OF oValidator			
		PARAMETER 'notes'		NAME 'Notes' ROLES 'maxlen:240' OF oValidator			
		PARAMETER 'id_shipper'	NAME 'Shipper' ROLES 'maxlen:2' OF oValidator			
	RUN VALIDATOR oValidator 	
	
	
	if oValidator:lError
		oController:oResponse:SendJson( { 'process' => .f., 'error' => oValidator:ErrorString() } )				
		retu 
	endif		
	

	//oController:oResponse:SendJson( { 'param' => hParam , 'a' => valtype(hParam['data_ped'])} )	
	

	//	Valid logic data param pos 
	
		hCab := { 	'id' => hParam[ 'id' ], ;
					'id_cli' => hParam[ 'id_cli' ],;
					'id_emp' => hParam[ 'id_emp' ],;
					'data_ped' => hParam[ 'data_ped' ],;
					'data_req' => hParam[ 'data_req' ],;
					'notes' => hParam[ 'notes' ],;
					'id_shipper' => hParam[ 'id_shipper' ];
					}
					
		aPos := hParam[ 'pos' ]
		
		lSave := oPedido:Save( hCab, aPos, @hError )
	
	
	//	Return Response 
	
		oController:oResponse:SendJson( { 'process' => lSave, 'id' => hCab['id'], 'hparam' => hParam, 'error' => hError, 'cab' => hCab } )	
	
RETU NIL 


//	Load datamodel		---------------------------------------------

	{% mh_LoadFile( "/src/model/pedidomodel.prg" ) %}
	{% mh_LoadFile( "/src/model/clientemodel.prg" ) %}
	{% mh_LoadFile( "/src/model/empleadomodel.prg" ) %}
	{% mh_LoadFile( "/src/model/shippermodel.prg" ) %}