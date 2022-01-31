CLASS TestController 

	METHOD New()	CONSTRUCTOR 
	
	METHOD Get()
	METHOD Post()
	METHOD Request()


ENDCLASS 

METHOD New() CLASS TestController 


RETU Self 

METHOD Get( oController ) CLASS TestController 
	
	? 'id', oController:oRequest:Get( 'id' )
	? 'ID', oController:oRequest:Get( 'ID' )	

RETU nil 

METHOD Post( oController ) CLASS TestController 
	
	? 'id', oController:oRequest:Post( 'id' )
	? 'ID', oController:oRequest:Post( 'ID' )	

RETU nil 

METHOD Request( oController ) CLASS TestController 
	
	? 'get id', oController:oRequest:Get( 'id' )
	? 'get ID', oController:oRequest:Get( 'ID' )
	
	? 'post id', oController:oRequest:Post( 'id' )
	? 'post ID', oController:oRequest:Post( 'ID' )	
	
	? 'request id', oController:oRequest:Request( 'id' )
	? 'request ID', oController:oRequest:Request( 'ID' )		

RETU nil 

