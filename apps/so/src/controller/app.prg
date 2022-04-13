CLASS App

	METHOD New() 	CONSTRUCTOR
	
	METHOD Default()	
	METHOD About()	
 	
ENDCLASS

//	---------------------------------------------------------------	//

METHOD New( oController ) CLASS App

	AUTENTICATE CONTROLLER oController
	
RETU SELF

//	---------------------------------------------------------------	//

METHOD Default( oController ) CLASS App	

	oController:View( 'main/main.view' )

RETU NIL

//	---------------------------------------------------------------	//

METHOD About( oController ) CLASS App	

	local cHtml := ''
	local cUrl 	:= AppUrlImg()
	

	BLOCKS TO cHtml PARAMS cUrl  
		
		<div>
			<img src="{{ cUrl + 'logo_report.png' }}">
		</div>
	
	ENDTEXT
	

	oController:oResponse:SendJson( { 'html' => cHtml } )	
	

RETU NIL

//	---------------------------------------------------------------	//
