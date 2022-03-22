CLASS TestController 

	METHOD New()	CONSTRUCTOR 
	
	METHOD Get()
	METHOD Post()
	METHOD Request()


ENDCLASS 

METHOD New() CLASS TestController 


RETU Self 

METHOD Get( oController ) CLASS TestController 

	local cId 
	
	? 'id', oController:oRequest:Get( 'id' )
	? 'ID', oController:oRequest:Get( 'ID' )	
	
	? '<hr>' 	
	
	? 'id', oController:Get( 'id' )
	? 'ID', oController:Get( 'ID' )	
	
	? '<hr>' 	
	
	DEFINE cId GET 'id' DEFAULT '100' TYPE 'N' OF oController 
	
	? "DEFINE id GET 'id' DEFAULT '100' TYPE 'N' => ", cId, 'Type: ' + valtype( cId )
	
	DEFINE cId GET 'id' DEFAULT '100' OF oController 
	
	? "DEFINE id GET 'id' DEFAULT '100' => ", cId, 'Type: ' + valtype( cId )

RETU nil 

METHOD Post( oController ) CLASS TestController 
	
	? 'id', oController:oRequest:Post( 'id' )
	? 'ID', oController:oRequest:Post( 'ID' )	
	
	? '<hr>' 	
	
	? 'id', oController:Post( 'id' )
	? 'ID', oController:Post( 'ID' )	

RETU nil 

METHOD Request( oController ) CLASS TestController 
	
	? 'get id', oController:oRequest:Get( 'id' )
	? 'get ID', oController:oRequest:Get( 'ID' )
	
	? 'post id', oController:oRequest:Post( 'id' )
	? 'post ID', oController:oRequest:Post( 'ID' )	
	
	? 'request id', oController:oRequest:Request( 'id' )
	? 'request ID', oController:oRequest:Request( 'ID' )		

RETU nil 

