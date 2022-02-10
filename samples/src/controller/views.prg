CLASS Views 

	METHOD New()	CONSTRUCTOR 
	
	METHOD Show()



ENDCLASS 

METHOD New() CLASS Views 


RETU Self 

METHOD Show( oController ) CLASS Views 

	local cId 		:= oController:Get( 'id' )
	local hData 	:= { 'first' => 'Max', 'last' => 'Headrom', 'zip' => '45004X'}
	local cFile 	:= 'views/html' + cId + '.view'

	oController:View( cFile, 200,  hData )

RETU nil 



