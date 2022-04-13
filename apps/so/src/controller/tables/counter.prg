CLASS Counter

	METHOD New() 	CONSTRUCTOR
	
	METHOD Show()
	
	METHOD Action()
	METHOD Load()
	METHOD Save()
	
	METHOD Search()	//	Browse Search...
	METHOD GetId()	
	
ENDCLASS

//	---------------------------------------------------------------	//

METHOD New( oController ) CLASS Counter

	AUTENTICATE CONTROLLER oController
	
RETU SELF

//	---------------------------------------------------------------	//

METHOD Show( oController ) CLASS Counter	
	local oCounter		:= CounterModel():New()	
	local hData 		:= oCounter:GetAll()
	

	//	Si es una tabla que se puede cargar toda, la pasamos,
	//	sino, no pasaremos nada...

	oController:View( 'tables/counter.view', 200, hData )	

RETU NIL


//	---------------------------------------------------------------	//

METHOD Action( oController ) CLASS Counter	

	local hParam 		:= GetMsgServer()	
	
	do case
		case hParam[ 'action' ] == 'load' ; ::Load( oController, hParam )
		case hParam[ 'action' ] == 'save' ; ::Save( oController, hParam )
		case hParam[ 'action' ] == 'getid' ; ::GetId( oController, hParam )
	endcase

RETU NIL 

//	---------------------------------------------------------------	//

METHOD Save( oController, hParam ) CLASS Counter		
	
	local aData 		:= hParam[ 'data' ]
	local oCounter		:= CounterModel():New()	
	local aResume
	local hResponse 
	
	//	Process data...	
	
		aResume := oCounter:oDataset:Save( aData )		

		hResponse := { 'success' => .T., 'resume' => aResume }			
	
	oController:oResponse:SendJson( hResponse )

RETU NIL

//	---------------------------------------------------------------	//

METHOD Load( oController, hParam ) CLASS Counter	
	
	
	local oCounter 	:= CounterModel():New()	
	local aRows 		:= oCounter:Search( hParam[ 'tag'],  hParam[ 'search' ] )
	
	oController:oResponse:SendJson( { 'rows' => aRows } )

RETU NIL


//	---------------------------------------------------------------	//

METHOD Search( oController ) CLASS Counter	
	
	
	local oCounter 		
	local hParam		:= GetMsgServer()
	local aRows		:= {}


	//	Buscamos en modelo --------------------------------
	
		oCounter 	:= CounterModel():New()		
		aRows 		:= oCounter:Search( 'module', hParam[ 'search' ] )
		
	//	Respuesta -----------------------------------------		
	
	oController:oResponse:SendJson( { 'success' => .t., 'search' => hParam[ 'search' ], 'rows' => aRows } )

RETU NIL

//	---------------------------------------------------------------	//

METHOD GetId( oController, hParam ) CLASS Counter		
	
	local oCounter 	:= CounterModel():New()	
	local hRow 		:= oCounter:GetId( val( hParam[ 'search' ] ) )
		

	oController:oResponse:SendJson( { 'success' => .t. , 'row' => hRow } )
		

RETU NIL




//	Load datamodel		---------------------------------------------

	{% mh_LoadFile( "/src/model/countermodel.prg" ) %}
