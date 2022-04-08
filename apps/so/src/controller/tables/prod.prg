CLASS Prod

	METHOD New() 	CONSTRUCTOR
	
	METHOD Show()
	
	METHOD Action()
	METHOD Load()
	METHOD Save()
	
	METHOD Search( oController )
	METHOD GetId()		
	
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
		case hParam[ 'action' ] == 'getid' ; ::GetId( oController, hParam )
	endcase

RETU NIL 

//	---------------------------------------------------------------	//

METHOD Save( oController, hParam ) CLASS Prod		
	
	local aData 		:= hParam[ 'data' ]
	local oProd		:= ProdModel():New()	
	local aResume
	local hResponse 
	
	//	Process data...	
	
		aResume := oProd:oDataset:Save( aData )
		
		hResponse := { 'success' => .T., 'resume' => aResume }				
	
	oController:oResponse:SendJson( hResponse )

RETU NIL

//	---------------------------------------------------------------	//

METHOD Load( oController, hParam ) CLASS Prod	
	
	
	local oProd 		:= ProdModel():New()	
	local aRows 		:= oProd:Search( hParam[ 'tag'],  hParam[ 'search' ] )

	oController:oResponse:SendJson( { 'rows' => aRows } )

RETU NIL


//	---------------------------------------------------------------	//

METHOD Search( oController ) CLASS Prod			
	
	local oProd 		:= ProdModel():New()		
	local hParam		:= GetMsgServer()
	local aRows		:= {}


	//	Buscamos en modelo --------------------------------
	
		aRows 		:= oProd:Search( 'nombre', hParam[ 'search' ] )
		
	//	Respuesta -----------------------------------------		
	
	oController:oResponse:SendJson( { 'success' => .t., 'search' => hParam[ 'search' ], 'rows' => aRows } )

RETU NIL


//	---------------------------------------------------------------	//

METHOD GetId( oController, hParam ) CLASS Prod		
	
	local oProd 		:= ProdModel():New()		
	local hRow 		:= oProd:GetId( val( hParam[ 'search' ] ) )

	oController:oResponse:SendJson( { 'success' => !empty( hRow ) , 'row' => hRow } )
	

RETU NIL


//	Load datamodel		---------------------------------------------

	{% mh_LoadFile( "/src/model/prodmodel.prg" ) %}
