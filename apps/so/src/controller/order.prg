CLASS Order

	METHOD New() 	CONSTRUCTOR
	
	METHOD Show()	
	METHOD Action()
	METHOD Load()
	
	METHOD Upd()
	
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


//	---------------------------------------------------------------	//

METHOD Upd( oController ) CLASS Order	

	local oPedido		:= PedidoModel():New()		
	local hParam		:= oController:GetAll()
	local oValidator 
	
	DEFINE VALIDATOR oValidator WITH hParam
		PARAMETER 'id' 	NAME 'Id' ROLES 'required|number|maxlen:8' FORMATTER 'tonumber' OF oValidator			
	RUN VALIDATOR oValidator 
	
	if oValidator:lError
		oController:View( 'sys/error.view', 200, oValidator:ErrorString() )				
		retu 
	endif		
	
	aRows := oPedido:GetId( hParam[ 'id' ]  )
	
	if len( aRows ) == 1 
		hRow := aRows[1]
	else 
		oController:View( 'sys/error.view', 200, "Id doesn't exist: " + ltrim(str(hParam[ 'id' ])) )				
		retu nil
	endif

	
	oController:View( 'order/order_upd.view', 200, hRow )	
	
	
RETU NIL 

//	Load datamodel		---------------------------------------------

	{% mh_LoadFile( "/src/model/pedidomodel.prg" ) %}