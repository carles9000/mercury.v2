CLASS Order

	METHOD New() 	CONSTRUCTOR
	
	METHOD Show()	
	METHOD Action()
	METHOD Load()
	
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
	local aRows 		
	
	hParam[ 'tag' ] := lower( hParam[ 'tag' ] )

	do case
		case hParam[ 'tag' ] == 'id' 		;  aRows	:= oPedido:GetId( Val( hParam[ 'search' ] ) )
		case hParam[ 'tag' ] == 'cliente' 	;  aRows	:= oPedido:SearchExact( 'cliente', Val( hParam[ 'search' ] ) )
	endcase		

	oController:oResponse:SendJson( { 'rows' => aRows } )

RETU NIL

//	Load datamodel		---------------------------------------------

	{% mh_LoadFile( "/src/model/pedidomodel.prg" ) %}