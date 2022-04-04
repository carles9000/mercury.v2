CLASS Cli

	METHOD New() 	CONSTRUCTOR
	
	METHOD Show()
	
	METHOD Action()
	METHOD Load()
	METHOD Save()
	
	METHOD Search()	//	Browse Search...
	METHOD GetId()	
	
ENDCLASS

//	---------------------------------------------------------------	//

METHOD New( oController ) CLASS Cli

	//AUTENTICATE CONTROLLER oController
	
RETU SELF

//	---------------------------------------------------------------	//

METHOD Show( oController ) CLASS Cli	
	local oCli		:= ClienteModel():New()	
	local hData 	:= oCli:GetAll()

	//	Si es una tabla que se puede cargar toda, la pasamos,
	//	sino, no pasaremos nada...

	oController:View( 'tables/cli.view', 200, hData )	

RETU NIL


//	---------------------------------------------------------------	//

METHOD Action( oController ) CLASS Cli	

	local hParam 		:= GetMsgServer()	
	
	do case
		case hParam[ 'action' ] == 'load' ; ::Load( oController, hParam )
		case hParam[ 'action' ] == 'save' ; ::Save( oController, hParam )
		case hParam[ 'action' ] == 'getid' ; ::GetId( oController, hParam )
	endcase

RETU NIL 

//	---------------------------------------------------------------	//

METHOD Save( oController, hParam ) CLASS Cli		
	
	local aData 		:= hParam[ 'data' ]
	local oCli			:= ClienteModel():New()	
	local nUpdated 	:= 0
	local aUpdated 	:= 0
	local hResponse 
	
	//	Process data...	
	
		aUpdated := oCli:oDataset:Save( aData )
		nUpdated := len( aUpdated )		

		
		hResponse := { 'success' => .T., 'updated' => nUpdated, 'rows_updated' => aUpdated, 'error' => oCli:oDataset:GetError(), 'errortxt' => oCli:oDataset:GetErrorString() }
				
	oController:oResponse:SendJson( hResponse )

RETU NIL

//	---------------------------------------------------------------	//

METHOD Load( oController, hParam ) CLASS Cli	
	
	
	local oCli 		:= ClienteModel():New()	
	local aRows 		:= oCli:Search( hParam[ 'tag'],  hParam[ 'search' ] )

	//	hResponse := { 'success' => .T., 'updated' => nUpdated, 'rows_updated' => aUpdated, 'error' => oCliente:oDataset:GetError(), 'errortxt' => oCliente:oDataset:GetErrorString() }
	
	oController:oResponse:SendJson( { 'rows' => aRows } )

RETU NIL


//	---------------------------------------------------------------	//

METHOD Search( oController ) CLASS Cli	
	
	
	local oCli 		
	local hParam		:= GetMsgServer()
	local aRows		:= {}


	//	Buscamos en modelo --------------------------------
	
		oCli 		:= ClienteModel():New()		
		aRows 		:= oCli:Search( 'cliente', hParam[ 'search' ] )
		
	//	Respuesta -----------------------------------------		
	
	oController:oResponse:SendJson( { 'success' => .t., 'search' => hParam[ 'search' ], 'rows' => aRows } )

RETU NIL

//	---------------------------------------------------------------	//

METHOD GetId( oController, hParam ) CLASS Cli		
	
	local oCli 		:= ClienteModel():New()	
	local hRow 		:= oCli:GetId( val( hParam[ 'search' ] ) )
		

	oController:oResponse:SendJson( { 'success' => .t. , 'row' => hRow } )
		

RETU NIL




//	Load datamodel		---------------------------------------------

	{% mh_LoadFile( "/src/model/ClienteModel.prg" ) %}
