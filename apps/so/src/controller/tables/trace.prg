CLASS Trace

	METHOD New() 	CONSTRUCTOR
	
	METHOD Show()
	
ENDCLASS

//	---------------------------------------------------------------	//

METHOD New( oController ) CLASS Trace
	
	local hData, hUser 

	AUTENTICATE CONTROLLER oController
	
	//	Check User Rol. This rol was loaded when you logged	
	
	GET TOKEN DATA hData OF oController
	
	hUser := hData[ 'user' ]
	
	do case
		case hUser[ 'rol' ] == 'A' ; retu Self
		otherwise 
			oController:View( 'sys/error.view', 200, "I'm sorry, you don't have authorization" )
			retu nil
	endcase	
	
RETU SELF

//	---------------------------------------------------------------	//

METHOD Show( oController ) CLASS Trace	

	local oTrace	:= TraceModel():New()	
	local hData 	:= oTrace:GetAll()
	
	//	Si es una tabla que se puede cargar toda, la pasamos,
	//	sino, no pasaremos nada...

	oController:View( 'tables/trace.view', 200, hData )	

RETU NIL

//	---------------------------------------------------------------	//

//	Load datamodel		---------------------------------------------

	{% mh_LoadFile( "/src/model/Tracemodel.prg" ) %}
