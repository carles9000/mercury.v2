CLASS Order

	METHOD New() 	CONSTRUCTOR
	
	METHOD Show()	
	
ENDCLASS

//	---------------------------------------------------------------	//

METHOD New( oController ) CLASS Order

	//AUTENTICATE CONTROLLER oController
	
RETU SELF

//	---------------------------------------------------------------	//

METHOD Show( oController ) CLASS Order	

	oController:View( 'order/order.view' )

RETU NIL

//	---------------------------------------------------------------	//
